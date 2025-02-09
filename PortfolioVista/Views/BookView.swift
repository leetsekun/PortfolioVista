//
//  BookView.swift
//  PortfolioVista
//
//  Created by leetsekun on 9/30/24.
//

import SwiftUI
import SwiftData

struct BookView: View {
    @Query private var transactions: [Transaction]
    @Query private var books: [Book]
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
        .sorted { $0.datetime > $1.datetime } // Sort by datetime, latest first
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
