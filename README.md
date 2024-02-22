# LZ SwiftUI Macros

A collection of Swift macros for working with SwiftUI.

Sadly, the only one here doesn’t work, because Swift macros are not powerful enough.

## FocusedCommand

```swift
#FocusedCommand("Duplicate")
```

would expand to

```swift
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
```

But alas, it is not allowed to introduce extensions. So I guess we’re all stuck
with tons of annoying boilerplate.
