//
//  AddTransactionView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/6/24.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Binding var isAddTransactionPresented: Bool
    // @Query private var categories: [Category]
    let initialCategories = [
        (name: "Food", systemImage: "fork.knife.circle"),
        (name: "Transport", systemImage: "car.circle"),
        (name: "Utilities", systemImage: "lightbulb.circle"),
        (name: "Entertainment", systemImage: "film.circle"),
        (name: "Shopping", systemImage: "bag.circle"),
        (name: "Other", systemImage: "smallcircle.filled.circle")
    ]

    let secondaryCategories = [
        (name: "Groceries", systemImage: "cart.circle", parentName: "Food"),
        (name: "Dining Out", systemImage: "fork.knife.circle", parentName: "Food"),
        (name: "Public Transport", systemImage: "car.circle", parentName: "Transport"),
        (name: "Fuel", systemImage: "fuelpump.circle", parentName: "Transport")
    ]
    
    @State private var categories: [Category] = []
    @State private var selectedTab = "支出"
    @State private var amount: String = "0.00"
    @State private var note: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var selectedBook: String = "Book 1"
    @State private var selectedAccount: String = "Acc1"
    @State private var isBookPickerPresented = false
    @State private var isAccountPickerPresented = false
    @State private var currentInput: String = ""
    @State private var previousInput: String = ""
    @State private var operation: String = ""
    
    let books = ["Book 1", "Book 2", "Book 3"]
    let accounts = ["Acc1", "Acc2", "Acc3"]

    init(isAddTransactionPresented: Binding<Bool>) {
        self._isAddTransactionPresented = isAddTransactionPresented
        var categoryDict = [String: Category]()
        var categories = [Category]()
        
        for categoryData in initialCategories {
            let category = Category(name: categoryData.name, icon: categoryData.systemImage)
            categoryDict[categoryData.name] = category
            categories.append(category)
        }
        
        for categoryData in secondaryCategories {
            if let parentCategory = categoryDict[categoryData.parentName] {
                let category = Category(name: categoryData.name, icon: categoryData.systemImage, parent: parentCategory)
                parentCategory.subcategories.append(category)
                categories.append(category)
            }
        }
        
        self._categories = State(initialValue: categories)
    }

    var body: some View {
        VStack {
            // Top Navigation Bar
            ZStack {
                HStack {
                    Button("取消") {
                        isAddTransactionPresented = false
                    }
                    .foregroundColor(.gray)

                    Spacer()

                    Button(action: {
                        isBookPickerPresented = true
                    }) {
                        Text(selectedBook)
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $isBookPickerPresented) {
                        Picker("选择账本", selection: $selectedBook) {
                            ForEach(books, id: \.self) { book in
                                Text(book).tag(book)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                    .frame(maxWidth: 100, alignment: .trailing) // Align to the right
                }
                .font(.callout)

                Picker("Category", selection: $selectedTab) {
                    Text("支出").tag("支出")
                    Text("收入").tag("收入")
                    Text("转账").tag("转账")
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 120, alignment: .center)
            }
            .padding(.vertical)
            
            // Categories Grid
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 16) {
                    ForEach(categories, id: \.self) { category in
                        VStack {
                            Image(systemName: category.icon)
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(category == selectedCategory ? .red : .gray)
                            Text(category.name)
                                .font(.caption2)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        .onTapGesture {
                            selectedCategory = category
                        }
                    }
                }
            }
            .overlay(
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            isAccountPickerPresented = true
                        }) {
                            HStack(spacing: 2) {
                                Image(systemName: "message.circle.fill") // Placeholder for WeChat icon
                                    .foregroundColor(.green)
                                Text(selectedAccount)
                            }
                            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                            .background(Color.white)
                            .cornerRadius(Constants.cornerRadius)
                        }
                        .font(.callout)
                        .sheet(isPresented: $isAccountPickerPresented) {
                            Picker("选择账户", selection: $selectedAccount) {
                                ForEach(accounts, id: \.self) { account in
                                    Text(account).tag(account)
                                }
                            }
                            .pickerStyle(WheelPickerStyle())
                        }
                        Spacer()
                    }
                }
            )
            
            VStack(spacing: 6) {
                // Amount Entry Field
                HStack(spacing: 2) {
                    Text("$")
                    Text(amount)
                    Spacer()
                }
                .foregroundColor(.red)
                .font(.system(size: 40, weight: .medium))
                .fontWidth(.compressed)
                
                Divider()
                
                HStack {
                    Button(action: {
                        // Action for the button
                    }) {
                        HStack(spacing: 2) {
                            Image(systemName: "clock")
                            Text("00:41")
                        }
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                        .background(Color(.systemGray6))
                        .cornerRadius(Constants.cornerRadius)
                    }

                    TextField("点击填写备注", text: $note)
                }
                .grayTextStyle(font: .callout)
                .padding(.top, 10)
            }
            .padding(EdgeInsets(top: 6, leading: 16, bottom: 16, trailing: 16))
            .background(Color.white)
            .cornerRadius(Constants.cornerRadius)
            .monospacedDigit()

            // Number Pad
            CalculatorView(displayText: $amount)
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
    }
    
    private func switchAccount() {
        // Implement the switch account action
        if let currentIndex = accounts.firstIndex(of: selectedAccount) {
            let nextIndex = (currentIndex + 1) % accounts.count
            selectedAccount = accounts[nextIndex]
        }
    }
}

#Preview {
    AddTransactionView(isAddTransactionPresented: .constant(true))
}
