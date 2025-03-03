// Copyright © 2025 Ben Morrison. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct GlobalItemMacro: GlobalMacroSupport {
    public static let macroType: MacroType = .attached("Item")
    @usableFromInline static let extensionName: String = "GlobalValues"
    @usableFromInline static let prefix: String = "__GlobalValueEntry_"
    @usableFromInline static let propertyTypeArgumentName: String = "propertyType"
    @usableFromInline static let propertyTypeNameComputed: String = "computed"
    @usableFromInline static let propertyTypeNameConstant: String = "constant"
    
    @inlinable
    static func defaultValue(from variableDecl: VariableDeclSyntax, andTypeAnnotation typeAnnotation: TypeSyntax) throws -> ExprSyntax {
        if typeAnnotation.as(OptionalTypeSyntax.self) != nil {
            return variableDecl.bindings.first?.initializer?.value ?? "nil"
        } else if let value = variableDecl.bindings.first?.initializer?.value {
            return value
        } else {
            throw GlobalMacroError.requiresVariableInitalization(macro: self)
        }
    }
}

extension GlobalItemMacro: AccessorMacro {
    static let methodArgumentName = "accessors"
    static let methodValueGetter = "getter"
    static let methodValueGetterAndSetter = "getterAndSetter"
    
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        let variableDecl = try variableDeclaration(in: declaration)
        let identifier = try identifier(from: variableDecl)
        try ensureInProtocol(named: extensionName, in: context)

        let type = argumentNamed(methodArgumentName, from: node) {
            guard let memberAccess = $0?.expression.as(MemberAccessExprSyntax.self) else { return methodValueGetterAndSetter }
            return memberAccess.declName.baseName.text
        }
        
        let keyName = "\(prefix)\(identifier.text)"
        var retVal: [AccessorDeclSyntax] = [ AccessorDeclSyntax("get { self[\(raw: keyName).self] }") ]
        if type == methodValueGetterAndSetter {
            retVal.append(AccessorDeclSyntax("set { self[\(raw: keyName).self] = newValue }"))
        }

        return retVal
    }
}

extension GlobalItemMacro: PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        let variableDecl = try variableDeclaration(in: declaration)
        let identifier = try identifier(from: variableDecl)
        
        try ensureInProtocol(named: extensionName, in: context)
        
        let typeAnnotation = try typeAnnotation(from: variableDecl)
        let keyName = "\(prefix)\(identifier.text)"
        let defaultValue = try defaultValue(from: variableDecl, andTypeAnnotation: typeAnnotation)
                
        let evaluationType = argumentNamed(propertyTypeArgumentName, from: node) {
            guard let memberAccess = $0?.expression.as(MemberAccessExprSyntax.self) else { return propertyTypeNameConstant }
            return memberAccess.declName.baseName.text
        }
        
        var source: String = """
        private struct \(keyName): GlobalKey {
            typealias Value = \(typeAnnotation)
        """
        
        switch evaluationType {
        case propertyTypeNameConstant:
            source += "\n    static let defaultValue: Value = \(defaultValue)"
        case propertyTypeNameComputed:
            source += "\n    static var defaultValue: Value { \(defaultValue) }"
        default:
            throw GlobalMacroError.unknownType(evaluationType, forMacro: self)
        }
        
        source += "\n}"
        
        return [
            DeclSyntax(stringLiteral: source)
        ]
        
    }
}
