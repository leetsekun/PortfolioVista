//
//  Transaction.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/1/24.
//

import Foundation
import SwiftData

@Model
final class Transaction {
    @Attribute(.unique) var id: UUID
    var datetime: Date
    var amount: Decimal
    var currency: String
    var type: TransactionType
    var category: Category?
    var book: Book?
    var account: Account?
    var transferOutAccount: Account?
    var transferInAccount: Account?
    var notes: String?
    
    init(datetime: Date, amount: Decimal, currency: String, type: TransactionType, category: Category? = nil, book: Book? = nil, account: Account? = nil, transferOutAccount: Account? = nil, transferInAccount: Account? = nil, notes: String = "") {
        self.id = UUID()
        self.datetime = datetime
        self.amount = amount
        self.currency = currency
        self.type = type
        self.category = category
        self.book = book
        self.account = account
        self.transferOutAccount = transferOutAccount
        self.transferInAccount = transferInAccount
        self.notes = notes
    }
}

@Model
final class Book {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var icon: String
    
    init(name: String, icon: String = "book.circle") {
        self.id = UUID()
        self.name = name
        self.icon = icon
    }
    
    static func getExistingBooks(context: ModelContext) -> [Book] {
        let descriptor = FetchDescriptor<Book>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(descriptor)) ?? []
    }
}

@Model
final class Account {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var currency: String
    var icon: String
    
    init(name: String, currency: String, icon: String = "dollarsign.circle") {
        self.id = UUID()
        self.name = name
        self.currency = currency
        self.icon = icon
    }
    
    static func getExistingAccounts(context: ModelContext) -> [Account] {
        let descriptor = FetchDescriptor<Account>(sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(descriptor)) ?? []
    }
}
