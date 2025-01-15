//
//  BookView.swift
//  PortfolioVista
//
//  Created by leetsekun on 9/30/24.
//

import SwiftUI
import SwiftData

struct BookView: View {
    // @Query private var transactions: [Transaction]
    // @Query private var books: [Book]
    @State private var transactions: [Transaction] = [
        Transaction(datetime: Date(), amount: 20.50, currency: "USD", type: .expense, category: Category(name: "Food", icon: "fork.knife"), book: Book(name: "Personal"), account: Account(name: "Cash", currency: "USD", icon: "dollarsign.circle"), notes: "Lunch at a restaurant"),
        Transaction(datetime: Date(), amount: 15.00, currency: "USD", type: .expense, category: Category(name: "Transport", icon: "car", parent: Category(name: "Transport", icon: "car")), book: Book(name: "Personal"), account: Account(name: "Credit Card", currency: "USD", icon: "creditcard"), notes: "Taxi fare"),
        Transaction(datetime: Date(), amount: 45.75, currency: "USD", type: .expense, category: Category(name: "Groceries", icon: "cart", parent: Category(name: "Food", icon: "fork.knife")), book: Book(name: "Personal"), account: Account(name: "Debit Card", currency: "USD", icon: "debitcard"), notes: "Weekly groceries"),
        Transaction(datetime: Date(), amount: 60.00, currency: "USD", type: .expense, category: Category(name: "Entertainment", icon: "gamecontroller"), book: Book(name: "Personal"), account: Account(name: "Cash", currency: "USD", icon: "dollarsign.circle"), notes: "Movie tickets"),
        Transaction(datetime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, amount: 100.00, currency: "USD", type: .expense, category: Category(name: "Utilities", icon: "lightbulb"), book: Book(name: "Personal"), account: Account(name: "Bank Transfer", currency: "USD", icon: "banknote"), notes: "Electricity bill"),
        Transaction(datetime: Date(), amount: 200.00, currency: "USD", type: .transfer, category: Category(name: "Transfer", icon: "arrow.right.arrow.left"), book: Book(name: "Personal"), transferOutAccount: Account(name: "Bank Account", currency: "USD", icon: "banknote"), transferInAccount: Account(name: "Savings Account", currency: "USD", icon: "banknote"), notes: "Transfer to savings"),
        Transaction(datetime: Date(), amount: 150.00, currency: "USD", type: .transfer, category: Category(name: "Transfer", icon: "arrow.right.arrow.left"), book: Book(name: "Personal"), transferOutAccount: Account(name: "Bank Account", currency: "USD", icon: "banknote"), transferInAccount: Account(name: "Savings Account", currency: "USD", icon: "banknote")),
        Transaction(datetime: Date(), amount: 75.00, currency: "USD", type: .income, category: Category(name: "Salary", icon: "dollarsign"), book: Book(name: "Personal"), account: Account(name: "Bank Account", currency: "USD", icon: "banknote"), notes: "Monthly salary"),
        Transaction(datetime: Date(), amount: 30.00, currency: "USD", type: .expense, category: Category(name: "Health", icon: "heart"), book: Book(name: "Personal"), account: Account(name: "Credit Card", currency: "USD", icon: "creditcard"), notes: "Doctor's appointment"),
        Transaction(datetime: Date(), amount: 50.00, currency: "USD", type: .income, category: Category(name: "Freelance", icon: "briefcase"), book: Book(name: "Personal"), account: Account(name: "Bank Account", currency: "USD", icon: "banknote"), notes: "Freelance project"),
        Transaction(datetime: Date(), amount: 25.00, currency: "USD", type: .expense, category: Category(name: "Dining", icon: "fork.knife"), book: Book(name: "Personal"), account: Account(name: "Cash", currency: "USD", icon: "dollarsign.circle"), notes: "Dinner with friends"),
        Transaction(datetime: Date(), amount: 120.00, currency: "USD", type: .expense, category: Category(name: "Shopping", icon: "bag"), book: Book(name: "Personal"), account: Account(name: "Debit Card", currency: "USD", icon: "debitcard"), notes: "Clothes shopping"),
        Transaction(datetime: Date(), amount: 80.00, currency: "USD", type: .income, category: Category(name: "Investment", icon: "chart.bar"), book: Book(name: "Personal"), account: Account(name: "Bank Account", currency: "USD", icon: "banknote"), notes: "Stock dividends"),
    ]
    @State private var books: [Book] = [
        Book(name: "Personal"),
        Book(name: "Business")
    ]
    @State private var selectedBook: Book?
    @State private var searchText = ""
    @State private var isTitleVisible = false
    @State private var isAddTransactionPresented = false

    var filteredTransactions: [Transaction] {
        transactions.filter { transaction in
            (selectedBook == nil || transaction.book == selectedBook) &&
            (searchText.isEmpty || transaction.category?.name.localizedCaseInsensitiveContains(searchText) == true ||
            transaction.notes?.localizedCaseInsensitiveContains(searchText) == true)
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Menu {
                        Picker(selection: $selectedBook) {
                            Text("All").tag(nil as Book?)
                            ForEach(books) { book in
                                Text(book.name).tag(book as Book?)
                            }
                        } label: {
                            EmptyView()
                        }
                    } label: {
                        Image(systemName: "arrow.left.arrow.right.circle")
                    }
                    
                    Spacer()
                    
                    if isTitleVisible {
                        Text(selectedBook?.name ?? "All")
                            .font(.title3)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Action for profile
                    }) {
                        Image(systemName: "ellipsis.circle") // Placeholder for profile picture
                    }
                }
                .imageScale(.large)
                .padding(.top, 16)

                // Main Title and Search Bar
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedBook?.name ?? "All")
                            .font(.system(.largeTitle).weight(.bold))
                            .onScrollVisibilityChange(threshold: 0.1) { isVisible in
                                isTitleVisible = !isVisible
                            }
                        
                        TextField("输入关键词", text: $searchText)
                            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .background(Color(.systemGray5))
                            .cornerRadius(Constants.cornerRadius)
                            .padding(.bottom)
                            .font(.title3)

                        // Month and navigation buttons
                        HStack {
                            Text("2024年9月")
                                .font(.system(.title3, design: .rounded).weight(.bold))
                            HStack {
                                Button(action: {
                                    // Previous Month
                                }) {
                                    Image(systemName: "chevron.backward.circle.fill")
                                        .monthButtonStyle()
                                }
                                Button(action: {
                                    // Next Month
                                }) {
                                    Image(systemName: "chevron.forward.circle.fill")
                                        .monthButtonStyle()
                                }
                            }
                            .padding(.trailing)
                        }

                        VStack {
                            // Main Card View for Total Balance
                            VStack(alignment: .leading) {
                                HStack(spacing: 4) {
                                    Text("总支出").font(.headline)
                                    Image(systemName: "arrow.left.arrow.right").font(.caption)
                                    Spacer()
                                }
                                .foregroundColor(.red)
                                .fontWeight(.bold)
                                Text("$6,892.63")
                                    .font(.system(size: 40, weight: .medium))
                                    .fontWidth(.compressed)
                                    .monospacedDigit()
                                    .foregroundColor(.black)
                                    .padding(.bottom, 16)
                                HStack {
                                    Text("总收入 ").fontWeight(.semibold)
                                     + Text("$11,122.07").foregroundColor(Color(white: 0.3))
                                    Spacer().frame(width: 16)
                                    Text("月结余 ").fontWeight(.semibold)
                                     + Text("$4,229.44").foregroundColor(Color(white: 0.3))
                                }
                                .grayTextStyle(font: .callout)
                                .monospacedDigit()
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(Constants.cornerRadius)

                            // Transaction List
                            TransactionGroupView(txns: filteredTransactions)
                        }
                    }
                }
            }
            .padding(.horizontal, 24)
            .background(Color(.systemGray6)) // Background color for entire view
            
            // Add Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isAddTransactionPresented = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .padding()
                            .background(Color.yellow)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                            .font(.title.weight(.heavy))
                    }
                    .padding(26)
                    .sheet(isPresented: $isAddTransactionPresented) {
                        AddTransactionView(isAddTransactionPresented: $isAddTransactionPresented)
                    }
                }
            }
        }
    }
}

#Preview {
    BookView()
}
