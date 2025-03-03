// Copyright © 2025 Ben Morrison. All rights reserved.

public protocol MacroNameProvider {
    static var macroName: String { get }
    static var macroPrefix: String { get }
    static var macroType: MacroType { get }
}

extension MacroNameProvider {
    public static var macroPrefix: String { macroType.prefix }
    public static var macroName: String { macroType.name }
}

public enum MacroType: Sendable {
    case attached(_ name: String)
    case freestanding(_ name: String)
    
    var description: String {
        switch self {
        case .attached(let name):     return "attached(\(name))"
        case .freestanding(let name): return "freestanding(\(name)"
        }
    }
    
    var prefix: String {
        switch self {
        case .attached:     return "@"
        case .freestanding: return "#"
        }
    }
    
    var name: String {
        switch self {
        case .attached(let name):     return name
        case .freestanding(let name): return name
        }
    }
}
