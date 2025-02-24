// Copyright © 2025 Ben Morrison. All rights reserved.

import Global

/// The macro `GlobalAccessor` is used in extensions when you can't use the `@Global` property
/// wrapper to access the global value. It will create all the code needed to access the value
/// stored in `GlobalValues`.
///
/// To use this macro in an extension like so:
/// ```swift
/// extension UIView {
///     @GlobalAccessor(\.globalStatus) var status: Status
/// }
/// ```
///
/// - Note: This macro is not able to check if this value exists in another extension.
/// It will also _ignore_ any variable assigning and computing and rewrite getter and
/// setters for getting the value.
///
/// - Parameters:
///   - keyPath: The KeyPath of the value you wish to access in `GlobalValues`
///   - type: Defines if the macro should create a getter only, or both getter and setter.
///   Default: `.getter`
///
@available(*, deprecated, renamed: "Accessor", message: "Renamed to `Accessor` for succintness.")
@attached(accessor)
public macro GlobalAccessor<V>(
    _ keyPath: WritableKeyPath<GlobalValues, V>,
    type: AccessorMethod = .getter
) = #externalMacro(
    module: "GlobalMacroMacros", type: "GlobalAccessorMacro"
)

/// The macro `Accessor` is used in extensions when you can't use the `@Global` property
/// wrapper to access the global value. It will create all the code needed to access the value
/// stored in `GlobalValues`.
///
/// To use this macro in an extension like so:
/// ```swift
/// extension UIView {
///     @Accessor(\.globalStatus) var status: Status
/// }
/// ```
///
/// - Note: This macro is not able to check if this value exists in another extension.
/// It will also _ignore_ any variable assigning and computing and rewrite getter and
/// setters for getting the value.
///
/// - Parameters:
///   - keyPath: The KeyPath of the value you wish to access in `GlobalValues`
///   - type: Defines if the macro should create a getter only, or both getter and setter.
///   Default: `.getter`
///
@attached(accessor)
public macro Accessor<V>(
    _ keyPath: WritableKeyPath<GlobalValues, V>,
    type: AccessorMethod = .getter
) = #externalMacro(
    module: "GlobalMacroMacros", type: "GlobalAccessorMacro"
)
