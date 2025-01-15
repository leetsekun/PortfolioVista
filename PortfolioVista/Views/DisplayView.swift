//
//  DisplayView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/4/24.
//

import SwiftUI
import SwiftData

struct DisplayView: View {
    @Query private var transactions: [Transaction]
    @Query private var books: [Book]
    @Query private var accounts: [Account]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Transactions")) {
                    ForEach(transactions) { transaction in
                        VStack(alignment: .leading) {
                            Text("Amount: \(transaction.amount.formatted(.currency(code: transaction.currency)))")
                            Text("Category: \(transaction.category)")
                            Text("Date: \(transaction.datetime, style: .date)")
                        }
                    }
                    .onDelete(perform: deleteTransaction)
                }

                Section(header: Text("Books")) {
                    ForEach(books) { book in
                        Text(book.name)
                    }
                    .onDelete(perform: deleteBook)
                }

                Section(header: Text("Accounts")) {
                    ForEach(accounts) { account in
                        Text(account.name)
                    }
                    .onDelete(perform: deleteAccount)
                }
            }
            .navigationTitle("Model Data")
            .toolbar {
                EditButton()
            }
        }
    }

    private func deleteTransaction(at offsets: IndexSet) {
        for index in offsets { modelContext.delete(transactions[index]) }
    }

    private func deleteBook(at offsets: IndexSet) {
        for index in offsets { modelContext.delete(books[index]) }
    }

    private func deleteAccount(at offsets: IndexSet) {
        for index in offsets { modelContext.delete(accounts[index]) }
    }
}

#Preview {
    DisplayView()
}
