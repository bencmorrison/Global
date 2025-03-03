// Copyright © 2025 Ben Morrison. All rights reserved.

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest


#if canImport(GlobalMacroMacros)
import GlobalMacroMacros

let testMacros: [String: Macro.Type] = [
    "GlobalGet": GlobalFreestandingMacro.self,
    "GlobalSet": GlobalSetFreestandingMacro.self
]
#endif

final class GlobalFreestandingMacroTests: XCTestCase {
    func testGet() throws {
        #if !canImport(GlobalMacroMacros)
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
        
        assertMacroExpansion(
            """
            #GlobalGet(\\.someGlobal)
            """,
            expandedSource: """
            GlobalValues.get(\\.someGlobal)
            """,
            macros: testMacros
        )
    }
    
    func testSet() throws {
        #if !canImport(GlobalMacroMacros)
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
        
        assertMacroExpansion(
            """
            #GlobalSet(\\.someGlobal, setTo: "This is a test value.")
            """,
            expandedSource: """
            GlobalValues.set(\\.someGlobal, to: "This is a test value.")
            """,
            macros: testMacros
        )
    }
}
