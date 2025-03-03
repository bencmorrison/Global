// Copyright © 2025 Ben Morrison. All rights reserved.

import SwiftSyntax

protocol FreestandingSupport: MacroNameProvider {
    static func expression(labeled: String, in arguments: LabeledExprListSyntax) throws -> ExprSyntax
}

extension FreestandingSupport {
    static func expression(labeled: String, in arguments: LabeledExprListSyntax) throws -> ExprSyntax {
        guard let syntaxElement = arguments.first(where: { $0.label?.text == labeled }) else {
            throw GlobalMacroError.missingRequiredArgument(labeled, forMacro: self)
        }
        return syntaxElement.expression
    }
}
