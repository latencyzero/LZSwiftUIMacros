import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros




@main
struct
FocusedCommandPlugin : CompilerPlugin
{
	let providingMacros: [Macro.Type] =
	[
		FocusedCommandMacro.self,
	]
}




public
struct
FocusedCommandMacro : DeclarationMacro
{
	public
	static
	func
	expansion(of inNode: some SwiftSyntax.FreestandingMacroExpansionSyntax,
				in inContext: some SwiftSyntaxMacros.MacroExpansionContext)
		throws
		-> [SwiftSyntax.DeclSyntax]
	{
		guard
			let argument = inNode.argumentList.first?.expression,
			let segments = argument.as(StringLiteralExprSyntax.self)?.segments,
			segments.count == 1,
			case .stringSegment(let commandNameSyntax)? = segments.first
		else
		{
			throw FocusedCommandMacroError.requiresStaticStringLiteral
		}
		
		let commandName = commandNameSyntax.content.text
		let minorCommandName = commandName.prefix(1).lowercased() + commandName.dropFirst()
		print("Command name: \(commandName)")
		
		let commandKeyName = "\(commandName)CommandKey"
		
		return [
			"""
			struct \(raw: commandKeyName) : FocusedValueKey {
				typealias Value = (Bool, () -> Void)
			}
			""",
			"""
			extension FocusedValues {
				var \(raw: minorCommandName)Command : \(raw: commandKeyName).Value? {
					get {
						self[\(raw: commandKeyName).self]
					}
					set {
						self[\(raw: commandKeyName).self] = newValue
					}
				}
			}
			""",
			"""
			extension View {
				func on\(raw: commandName)(disabled: Bool = false, perform: @escaping () -> ()) -> some View {
					self.focusedSceneValue(\\.\(raw: minorCommandName)Command, (disabled, perform))
				}
			}
			"""]
	}
	
}



enum
FocusedCommandMacroError : Error, CustomStringConvertible
{
	case requiresStaticStringLiteral

	var
	description: String
	{
		switch self
		{
			case .requiresStaticStringLiteral:
				return "#FocusedCommand requires a static string literal command name"
		}
	}
}
