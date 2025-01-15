//
//  TransactionGroupView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/17/24.
//

import SwiftUI

struct TransactionGroupView: View {
    var txns: [Transaction]

    var groupedTxns: [String: [Transaction]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd EEEE"
        
        return Dictionary(grouping: txns) { txn in
            formatter.string(from: txn.datetime)
        }
    }

    var body: some View {
        ForEach(groupedTxns.keys.sorted(), id: \.self) { date in
            VStack(alignment: .leading) {
                GenericDisclosureGroup(
                    leftLabel: date,
                    rightLabel: getRightLabel(for: date),
                    elements: groupedTxns[date]!,
                    content: { txn in
                        TransactionView(transaction: txn)
                    }
                )
            }
        }
    }

    private func getRightLabel(for date: String) -> String {
        let income = groupedTxns[date]!.filter { $0.type == .income }.reduce(Decimal(0)) { $0 + $1.amount }
        let expense = groupedTxns[date]!.filter { $0.type == .expense }.reduce(Decimal(0)) { $0 + $1.amount }
        var label = ""
        if income > 0 {
            label += "收入: \(income.formatted(.currency(code: "USD")))"
        }
        if expense > 0 {
            if !label.isEmpty {
                label += "  "
            }
            label += "支出: \(expense.formatted(.currency(code: "USD")))"
        }
        return label
    }
}

#Preview {
    let transactions: [Transaction] = [
        Transaction(datetime: Date(), amount: 20.50, currency: "USD", type: .expense, category: Category(name: "Food", icon: "fork.knife"), book: Book(name: "Personal"), account: Account(name: "Cash", currency: "USD", icon: "dollarsign.circle"), notes: "Lunch at a restaurant"),
        Transaction(datetime: Date(), amount: 15.00, currency: "USD", type: .expense, category: Category(name: "Transport", icon: "car", parent: Category(name: "Transport", icon: "car")), book: Book(name: "Personal"), account: Account(name: "Credit Card", currency: "USD", icon: "creditcard"), notes: "Taxi fare"),
        Transaction(datetime: Date(), amount: 45.75, currency: "USD", type: .expense, category: Category(name: "Groceries", icon: "cart", parent: Category(name: "Food", icon: "fork.knife")), book: Book(name: "Personal"), account: Account(name: "Debit Card", currency: "USD", icon: "debitcard"), notes: "Weekly groceries"),
        Transaction(datetime: Date(), amount: 60.00, currency: "USD", type: .expense, category: Category(name: "Entertainment", icon: "gamecontroller"), book: Book(name: "Personal"), account: Account(name: "Cash", currency: "USD", icon: "dollarsign.circle"), notes: "Movie tickets"),
        Transaction(datetime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, amount: 100.00, currency: "USD", type: .expense, category: Category(name: "Utilities", icon: "lightbulb"), book: Book(name: "Personal"), account: Account(name: "Bank Transfer", currency: "USD", icon: "banknote"), notes: "Electricity bill"),
        Transaction(datetime: Date(), amount: 200.00, currency: "USD", type: .transfer, category: Category(name: "Transfer", icon: "arrow.right.arrow.left"), book: Book(name: "Personal"), transferOutAccount: Account(name: "Bank Account", currency: "USD", icon: "banknote"), transferInAccount: Account(name: "Savings Account", currency: "USD", icon: "banknote"), notes: "Transfer to savings"),
        Transaction(datetime: Date(), amount: 150.00, currency: "USD", type: .transfer, category: Category(name: "Transfer", icon: "arrow.right.arrow.left"), book: Book(name: "Personal"), transferOutAccount: Account(name: "Bank Account", currency: "USD", icon: "banknote"), transferInAccount: Account(name: "Savings Account", currency: "USD", icon: "banknote")),
    ]
    TransactionGroupView(txns: transactions)
}
