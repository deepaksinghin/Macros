import Foundation

// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces both a value and a string containing the
/// source code that generated the value. For example,
///
///     #stringify(x + y)
///
/// produces a tuple `(x + y, "x + y")`.
@freestanding(expression)
public macro stringify<T>(_ value: T) -> (T, String) = #externalMacro(module: "TeamMacros", type: "StringifyMacro")

@attached(member, names: named(title))
public macro EnumTitleSupport() = #externalMacro(module: "TeamMacros", type: "EnumTitleMacro")

@freestanding(expression)
public macro URL(_ stringLiteral: String) -> URL? = #externalMacro(module: "TeamMacros", type: "URLMacro")

@attached(member, names: named(log(issue:)))
public macro DebugLogger() = #externalMacro(module: "TeamMacros", type: "DebugLoggerMacro")

@attached(member, names: named(deinit))
public macro PrintDeinit() = #externalMacro(module: "TeamMacros", type: "printdeinitMacro")



