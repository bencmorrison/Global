// Copyright © 2025 Ben Morrison. All rights reserved.

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct GlobalMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        GlobalItemMacro.self,
        GlobalAccessorMacro.self
    ]
}
