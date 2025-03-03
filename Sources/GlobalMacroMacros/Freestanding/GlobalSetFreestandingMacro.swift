// Copyright © 2025 Ben Morrison. All rights reserved.
import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct GlobalSetFreestandingMacro: ExpressionMacro, FreestandingSupport, MacroNameProvider {
    public static let macroType: MacroType = .freestanding("Global(_, setTo:)")
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        let expressions = node.arguments.compactMap({ $0.expression })
        guard expressions.count == 2 else { throw GlobalMacroError.notEnoughArguments(2, macro: self) }
        
        let keyPathExpr = expressions[0]
        let newValueExpr = expressions[1]
        
        let globalValueGet = FunctionCallExprSyntax(
            calledExpression: DeclReferenceExprSyntax(baseName: .identifier("GlobalValues.set")),
            leftParen: .leftParenToken(),
            arguments: [
                LabeledExprSyntax(label: nil, expression: keyPathExpr, trailingComma: .commaToken()),
                LabeledExprSyntax(label: "to", expression: newValueExpr)
            ],
            rightParen: .rightParenToken()
        )
        
        return ExprSyntax(globalValueGet)
    }
}
