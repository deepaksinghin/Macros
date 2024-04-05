import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation
import SwiftSyntax
/// Implementation of the `stringify` macro, which takes an expression
/// of any type and produces a tuple containing the value of that expression
/// and the source code that produced the value. For example
///
///     #stringify(x + y)
///
///  will expand to
///
///     (x + y, "x + y")
public struct StringifyMacro: ExpressionMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> ExprSyntax {
        guard let argument = node.argumentList.first?.expression else {
            fatalError("compiler bug: the macro does not have any arguments")
        }

        return "(\(argument), \(literal: argument.description))"
    }
}

enum EnumInitError: CustomStringConvertible, Error {
    case onlyApplicableToEnum
    
    var description: String {
        switch self {
        case .onlyApplicableToEnum: return "This macro can only be applied to a enum."
        }
    }
}

public struct EnumTitleMacro: MemberMacro {
    
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        
        // this macro can only be assigned to enums
        guard let enumDel = declaration.as(EnumDeclSyntax.self) else {
            throw EnumInitError.onlyApplicableToEnum
        }
        
        let members = enumDel.memberBlock.members
        let caseDecl = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let cases = caseDecl.compactMap {
            $0.elements.first?.name.text
        }
        
        var title = """
        var title: String {
            switch self {
        """
        
        for titleCase in cases {
            title += "case .\(titleCase):"
            title += "return \"\(titleCase.capitalized)\""
        }
        
        title += """
            }
        }
        """
        
        return [DeclSyntax(stringLiteral: title)]
    }
}


enum DebugLoggerError: CustomStringConvertible, Error {
    case notCorrectType

    var description: String {
        switch self {
        case .notCorrectType: return "@DebugLogger can only be applied to a class & struct"
        }
    }
}

public struct DebugLoggerMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        // TODO: add type check for other DeclSyntax
        let identifier: TokenSyntax
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            identifier = classDecl.name
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            identifier = structDecl.name
        } else {
            throw DebugLoggerError.notCorrectType
        }

        // We could make issue generic but for now let's leave it as a string parameter
        let printFunc = try FunctionDeclSyntax("func log(issue: String)") {
            StmtSyntax(stringLiteral:
                """
                \n
                #if DEBUG
                print(\"In \(identifier.text) - \\(issue)\")
                #endif
                """
            )
        }

        return [
            DeclSyntax(printFunc)
        ]
    }
}

public struct printdeinitMacro: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        // TODO: add type check for other DeclSyntax
        let identifier: TokenSyntax
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            identifier = classDecl.name
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            identifier = structDecl.name
        } else {
            throw DebugLoggerError.notCorrectType
        }
        
        // We could make issue generic but for now let's leave it as a string parameter
        let printFunc = try FunctionDeclSyntax("deinit") {
            StmtSyntax(stringLiteral:
                """
                \nprint(\"\(identifier) deint")
                """
            )
        }
        
        return [
            DeclSyntax(printFunc)
        ]
    }
}

@main
struct SharpPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        StringifyMacro.self,
        EnumTitleMacro.self,
        DebugLoggerMacro.self,
        printdeinitMacro.self,
    ]
}
