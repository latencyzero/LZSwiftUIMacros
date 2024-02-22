// The Swift Programming Language
// https://docs.swift.org/swift-book

@freestanding(declaration, names: arbitrary)
public macro FocusedCommand(_ inCommandName: String) = #externalMacro(module: "LZSwiftUIMacrosImpl", type: "FocusedCommandMacro")
