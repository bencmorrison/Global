// Copyright © 2025 Ben Morrison. All rights reserved.

import SwiftSyntax
import SwiftParser
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import GlobalMacros

#if canImport(GlobalMacroMacros)
@testable import GlobalMacroMacros
#endif

final class EntryMacroFailureTests: XCTestCase {
    let propertyTypes = PropertyType.allCases
    
    let testMacros: [String: Macro.Type] = {
        #if canImport(GlobalMacroMacros)
        [
            "Item": GlobalItemMacro.self,
        ]
        #else
        []
        #endif
    }()
    
    func testMacroRequiesVariableDeclaration() throws {
        #if canImport(GlobalMacroMacros)
        let invalidInput = """
        struct GlobalValues {
            @Item func someFunction() -> String { "" }
        }
        """
        
        let expectedOutput = """
        struct GlobalValues {
            func someFunction() -> String { "" }
        }
        """
        assertMacroExpansion(
            invalidInput,
            expandedSource: expectedOutput,
            diagnostics: [
                DiagnosticSpec(
                    from: .requiresVariableDeclaration(macro: GlobalItemMacro.self),
                    line: 2, column: 5
                )
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroThrowsWhenOutsideGlobalValuesInNotExtension() throws {
        #if canImport(GlobalMacroMacros)
        let invalidInput = """
        struct OtherType {
            @Item var state: String = "Some value"
        }
        """
        
        let expectedOutput = """
        struct OtherType {
            var state: String = "Some value"
        }
        """
        
        assertMacroExpansion(
            invalidInput,
            expandedSource: expectedOutput,
            diagnostics: [
                DiagnosticSpec(
                    from: .requiresUseInExtension(forMacro: GlobalItemMacro.self),
                    line: 2, column: 5
                ),
                DiagnosticSpec(
                    from: .requiresUseInExtension(forMacro: GlobalItemMacro.self),
                    line: 2, column: 5
                )
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroThrowsWhenOutsideGlobalValuesInOtherExtension() throws {
        #if canImport(GlobalMacroMacros)
        let invalidInput = """
        extension Thing {
            @Item var state: String = "Some value"
        }
        """
        
        let expectedOutput = """
        extension Thing {
            var state: String = "Some value"
        }
        """
        
        assertMacroExpansion(
            invalidInput,
            expandedSource: expectedOutput,
            diagnostics: [
                DiagnosticSpec(
                    from: .requiresUseInExtension(GlobalItemMacro.extensionName, forMacro: GlobalItemMacro.self),
                    line: 2, column: 5
                ),
                DiagnosticSpec(
                    from: .requiresUseInExtension(GlobalItemMacro.extensionName, forMacro: GlobalItemMacro.self),
                    line: 2, column: 5
                )
            ],
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
    
    func testMacroThowsWhenTypeAnnotationRequired() throws {
    #if canImport(GlobalMacroMacros)
        let invalidInput = """
        extension GlobalValues {
            @Item var state = "Some String"
        }
        """
        
        let expectedOutput = """
        extension GlobalValues {
            var state {
                get {
                    self[__GlobalValueEntry_state.self]
                }
                set {
                    self[__GlobalValueEntry_state.self] = newValue
                }
            }
        }
        """
        
        assertMacroExpansion(
            invalidInput,
            expandedSource: expectedOutput,
            diagnostics: [
                DiagnosticSpec(
                    from: .requiresTypeAnnotation(macro: GlobalItemMacro.self),
                    line: 2, column: 5
                )
            ],
            macros: testMacros
        )
    #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
    }
    
    func testMacroThowsWhenVariableInitalizationRequired() throws {
    #if canImport(GlobalMacroMacros)
        let invalidInput = """
        extension GlobalValues {
            @Item var state: String
        }
        """
        
        let expectedOutput = """
        extension GlobalValues {
            var state: String {
                get {
                    self[__GlobalValueEntry_state.self]
                }
                set {
                    self[__GlobalValueEntry_state.self] = newValue
                }
            }
        }
        """
        
        assertMacroExpansion(
            invalidInput,
            expandedSource: expectedOutput,
            diagnostics: [
                DiagnosticSpec(
                    from: .requiresVariableInitalization(macro: GlobalItemMacro.self),
                    line: 2, column: 5
                )
            ],
            macros: testMacros
        )
    #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
    }
    
    func testMacroThowsWhenThePropertyTypeIsUnknown() throws {
    #if canImport(GlobalMacroMacros)
        let propertyType = "random"
        let invalidInput = """
        extension GlobalValues {
            @Item(propertyType: .\(propertyType)) var state: String = "Thing"
        }
        """
        
        let expectedOutput = """
        extension GlobalValues {
            var state: String {
                get {
                    self[__GlobalValueEntry_state.self]
                }
                set {
                    self[__GlobalValueEntry_state.self] = newValue
                }
            }
        }
        """
        
        assertMacroExpansion(
            invalidInput,
            expandedSource: expectedOutput,
            diagnostics: [
                DiagnosticSpec(
                    from: .unknownType(propertyType, forMacro: GlobalItemMacro.self),
                    line: 2, column: 5
                )
            ],
            macros: testMacros
        )
    #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
    }
}
