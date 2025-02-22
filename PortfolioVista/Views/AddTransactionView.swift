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
    @Query private var categories: [Category]
    @Query private var books: [Book]
    @Query private var accounts: [Account]
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedTab = "支出"
    @State private var amount: String = "0.00"
    @State private var note: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var selectedBook: Book? = nil
    @State private var selectedAccount: Account? = nil
    @State private var isBookPickerPresented = false
    @State private var isAccountPickerPresented = false
    @State private var currentInput: String = ""
    @State private var previousInput: String = ""
    @State private var operation: String = ""
    
    // save transaction time
    @State private var selectedHour: Int = 0  // Default hour
    @State private var selectedMinute: Int = 0 // Default minute
    let hours = Array(0...23)
    let minutes = Array(0...59)
    // Stores valid Date object
    @State private var selectedTime: Date?
    
    init(isAddTransactionPresented: Binding<Bool>) {
        self._isAddTransactionPresented = isAddTransactionPresented
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
                        Text(selectedBook?.name ?? "选择账本")
                            .foregroundColor(.blue)
                    }
                    .sheet(isPresented: $isBookPickerPresented) {
                        Picker("选择账本", selection: $selectedBook) {
                            ForEach(books, id: \.self) { book in
                                Text(book.name).tag(book as Book?)
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
                                Text(selectedAccount?.name ?? "选择账户")
                            }
                            .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                            .background(Color.white)
                            .cornerRadius(Constants.cornerRadius)
                        }
                        .font(.callout)
                        .sheet(isPresented: $isAccountPickerPresented) {
                            Picker("选择账户", selection: $selectedAccount) {
                                ForEach(accounts, id: \.self) { account in
                                    Text(account.name).tag(account as Account?)
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
                        addTransaction()
                    }) {
                        // Hour Picker
                        Picker("Hour", selection: $selectedHour) {
                            ForEach(hours, id: \.self) { hour in
                                Text(String(format: "%02d", hour)).tag(hour)
                            }
                        }
                        .pickerStyle(WheelPickerStyle()) // Wheel-style selection
                        .frame(width: 80, height: 80) // Adjust size
                        
                        Text(":") // Separator
                        
                        // Minute Picker
                        Picker("Minute", selection: $selectedMinute) {
                            ForEach(minutes, id: \.self) { minute in
                                Text(String(format: "%02d", minute)).tag(minute)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 80) // Adjust size
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
            CalculatorView(displayText: $amount, onAddTransaction: {
                addTransaction()
            })
        }
        .padding(.horizontal)
        .background(Color(.systemGray6))
    }
    
    private func addTransaction() {
        guard let selectedCategory = selectedCategory,
              let selectedBook = selectedBook,
              let selectedAccount = selectedAccount,
              let amountValue = Decimal(string: amount) else { return }
        
        let transactionType: TransactionType = selectedTab == "支出" ? .expense : .income
        
        let newTransaction = Transaction(datetime: convertToDate(hour: selectedHour, minute: selectedMinute), amount: amountValue, currency: selectedAccount.currency, type: transactionType, category: selectedCategory, book: selectedBook, account: selectedAccount, notes: note)
        modelContext.insert(newTransaction)
        do {
            try modelContext.save()
            print("Transaction saved successfully.")
        } catch {
            print("Error saving data: \(error)")
        }
        isAddTransactionPresented = false
    }
    
    // Function to create Date object from selected hour & minute
    private func convertToDate(hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        let now = Date()
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) ?? now
    }
}

#Preview {
    AddTransactionView(isAddTransactionPresented: .constant(true))
}
