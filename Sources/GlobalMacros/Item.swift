// Copyright © 2025 Ben Morrison. All rights reserved.

/// The macro `Item` can be used to make any a `GlobalKey` without adding conformance
/// to the protocol directly to the type. It will also create the code needed in `GlobalValues` to
/// allow use of the value via Global property wrapper and macros.
///
/// To use this you will need to still create an extension to `GlobalValues` and then add the values
/// via the macro.
///
/// ```swift
/// extension GlobalValues {
///     @Item var state: String = "Some string for global use."
/// }
/// ```
///
/// - Parameters:
///   - type: When creating an `Item` you can configure it to create a getter and setter or getter.
///           If you put setter only, it will be ignored.
///   - evaluation: The type of value you want the default property to be. Default: `.constant`
///
@attached(accessor)
@attached(peer, names: prefixed(__GlobalValueEntry_))
public macro Item(accessors: AccessorType = .getterAndSetter, propertyType: PropertyType = .constant) = #externalMacro(
    module: "GlobalMacroMacros", type: "GlobalItemMacro"
)
