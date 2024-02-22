import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when
// cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.

#if canImport(LZSwiftUIMacrosImpl)
import LZSwiftUIMacrosImpl
#endif

final class FocusedCommandTests: XCTestCase
{
	func
	testFocusedCommandMacro()
		throws
	{
#if canImport(LZSwiftUIMacrosImpl)
		assertMacroExpansion(
			#"""
			#FocusedCommand("Duplicate")
			"""#,
			expandedSource: #"""
			struct DuplicateCommandKey : FocusedValueKey {
				typealias Value = (Bool, () -> Void)
			}
			extension FocusedValues {
				var duplicateCommand : DuplicateCommandKey.Value? {
					get {
						self [DuplicateCommandKey.self]
					}
					set {
						self [DuplicateCommandKey.self] = newValue
					}
				}
			}
			extension View {
				func onDuplicate(disabled: Bool = false, perform: @escaping () -> ()) -> some View {
					self.focusedSceneValue(\.duplicateCommand, (disabled, perform))
				}
			}
			"""#,
			macros: ["FocusedCommand": FocusedCommandMacro.self]
		)
#else
		throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
	}
}
