// Copyright © 2025 Ben Morrison. All rights reserved.
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct GlobalFreestandingMacro: ExpressionMacro, FreestandingSupport, MacroNameProvider {
    public static let macroType: MacroType = .freestanding("Global")
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let expressions = node.arguments.compactMap({ $0.expression })
        guard expressions.count == 1 else { throw GlobalMacroError.notEnoughArguments(1, macro: self) }
        
        let keyPathExpr = expressions[0]
        
        let globalValueGet = FunctionCallExprSyntax(
            calledExpression: DeclReferenceExprSyntax(baseName: .identifier("GlobalValues.get")),
            leftParen: .leftParenToken(),
            arguments: [
                LabeledExprSyntax(label: nil, expression: keyPathExpr)
            ],
            rightParen: .rightParenToken()
        )
        
        return ExprSyntax(globalValueGet)
    }
}
