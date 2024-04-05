import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(TeamMacros)
import TeamMacros

let testMacros: [String: Macro.Type] = [
    "stringify": StringifyMacro.self,
    "EnumTitle": EnumTitleMacro.self
]
#endif

final class TeamTests: XCTestCase {
    
//    func testEnumTitleMacro() {
//        
//        assertMacroExpansion("""
//            
//            @EnumTitleSupport
//            enum Genre {
//                case horror
//                case comedy
//                case kids
//                case action
//            }
//            
//            
//            """, expandedSource: """
//
//            @EnumTitleSupport
//            enum Genre {
//                case horror
//                case comedy
//                case kids
//                case action
//                var title: String {
//                    switch self {
//                    case .horror:
//                        return "Horror"
//                    case .comedy:
//                        return "Comedy"
//                    case .kids:
//                        return "Kids"
//                    case .action:
//                        return "Action"
//                    }
//                }
//            }
//""" , macros: testMacros)
//        
//    }
    
    func testMacro() throws {
        #if canImport(TeamMacros)
        assertMacroExpansion(
            """
            #stringify(a + b)
            """,
            expandedSource: """
            (a + b, "a + b")
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }

    func testMacroWithStringLiteral() throws {
        #if canImport(TeamMacros)
        assertMacroExpansion(
            #"""
            #stringify("Hello, \(name)")
            """#,
            expandedSource: #"""
            ("Hello, \(name)", #""Hello, \(name)""#)
            """#,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
