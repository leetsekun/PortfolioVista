//
//  TestView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/4/24.
//

import SwiftUI
import SwiftData

struct TestView: View {
    @State private var accountName = ""
    @State private var bookName = ""
    @State private var transactionAmount = ""
    @State private var transactionCategory = ""
    @State private var transactionCurrency = "USD"
    @State private var transactionNotes = ""
    @State private var selectedBookId: UUID?
    @State private var selectedAccountId: UUID?
    @State private var accountIcon = "book.circle"
    
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book]
    @Query private var accounts: [Account]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Create Account")) {
                    TextField("Account Name", text: $accountName)
                    TextField("Currency", text: $transactionCurrency)
                    TextField("Icon", text: $accountIcon) // New text field for account icon
                    Button("Add Account") {
                        let newAccount = Account(name: accountName, currency: transactionCurrency, icon: accountIcon)
                        modelContext.insert(newAccount)
                        accountName = ""
                        transactionCurrency = "USD"
                        accountIcon = "book.circle" // Reset account icon
                    }
                }
                
                Section(header: Text("Create Book")) {
                    TextField("Book Name", text: $bookName)
                    Button("Add Book") {
                        let newBook = Book(name: bookName)
                        modelContext.insert(newBook)
                        bookName = ""
                    }
                }
                
                Section(header: Text("Create Transaction")) {
                    TextField("Amount", text: $transactionAmount)
                        .keyboardType(.decimalPad)
                    TextField("Category", text: $transactionCategory)
                    TextField("Currency", text: $transactionCurrency)
                    TextField("Notes", text: $transactionNotes)
                    Picker("Book", selection: $selectedBookId) {
                        Text("Select a Book").tag(nil as UUID?)
                        ForEach(books, id: \.id) { book in
                            Text(book.name).tag(book.id as UUID?)
                        }
                    }
                    Picker("Account", selection: $selectedAccountId) {
                        Text("Select an Account").tag(nil as UUID?)
                        ForEach(accounts, id: \.id) { account in
                            Text(account.name).tag(account.id as UUID?)
                        }
                    }
                    Button("Add Transaction") {
                        if let amount = Decimal(string: transactionAmount),
                           let bookId = selectedBookId,
                           let accountId = selectedAccountId,
                           let book = books.first(where: { $0.id == bookId }),
                           let account = accounts.first(where: { $0.id == accountId }) {
                            let newTransaction = Transaction(
                                datetime: Date(),
                                amount: amount,
                                currency: transactionCurrency,
                                type: .expense, // Assuming a default type for simplicity
                                category: nil, // Assuming category is not used in this context
                                book: book,
                                account: account,
                                notes: transactionNotes
                            )
                            modelContext.insert(newTransaction)
                            
                            // Save the model context
                            do {
                                try modelContext.save()
                            } catch {
                                print("Failed to save the model context: \(error)")
                            }
                            
                            transactionAmount = ""
                            transactionCategory = ""
                            transactionCurrency = "USD"
                            transactionNotes = ""
                            selectedBookId = nil
                            selectedAccountId = nil
                        }
                    }
                }
            }
            .navigationTitle("Create Entities")
        }
    }
}

#Preview {
    TestView()
}
