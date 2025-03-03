// Copyright © 2025 Ben Morrison. All rights reserved.
import Global

/// Allows you to access the items stored in the `GlobalValues` without using the property
/// wrapper `@Global` or the `@Accessor` macro.
/// - Parameters:
///   - keypath: The keypath of the value you wish to get from `GlobalValues`
/// - Returns: The value stored in `GlobalValues`
@freestanding(expression)
public macro Global<Value>(
    _ keypath:  KeyPath<GlobalValues, Value>
) -> Value = #externalMacro(
    module: "GlobalMacroMacros",
    type: "GlobalFreestandingMacro"
)

/// Allows you to set the stored value in `GlobalValues` _if_ the value is writable. You can use
/// this instead of the property wrapper `@Global` or the `@Accessor` macro.
/// - Parameters:
///   - keypath: The keypath of the value you wish to get from `GlobalValues`
///   - newValue: The value you wish to update the global value to in `GlobalValues`
@freestanding(expression)
public macro Global<Value>(
    _ keypath: WritableKeyPath<GlobalValues, Value>,
    setTo newValue: Value
) = #externalMacro(
    module: "GlobalMacroMacros",
    type: "GlobalSetFreestandingMacro"
)
