// Copyright © 2025 Ben Morrison. All rights reserved.

/// When a global macro has the opportunity to create a getter and setter
/// when they allow it, they can be configured to generate a setter, getter,
/// or both.
public enum AccessorType {
    /// Tells the macro to create the getter
    case getter
    /// Tells the macro to create the setter
    case setter
    /// Tells the macro to create the setter and getter
    case getterAndSetter
}
