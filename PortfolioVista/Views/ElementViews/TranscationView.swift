//
//  TranscationView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/17/24.
//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction

    var body: some View {
        GenericElementView(
            icon: transaction.type == .transfer ? "arrow.right.arrow.left.circle" : (transaction.category?.icon ?? "questionmark.circle"),
            title: transaction.type == .transfer ? "Transfer" : (transaction.category?.parent != nil ? "\(transaction.category!.parent!.name)-\(transaction.category!.name)" : transaction.category?.name ?? ""),
            bgColor: transaction.type == .transfer ? .yellow : (transaction.type == .expense ? .red : .green),
            content1: HStack(spacing: 1) {
                Text(transaction.datetime.formatted(.dateTime.hour().minute()))
                    .layoutPriority(1)
                if let notes = transaction.notes, !notes.isEmpty {
                    Text("•")
                    Text(notes)
                }
            }
            .grayTextStyle(font: .footnote),
            content2: VStack(alignment: .trailing, spacing: 6) {
                Text("\(transaction.type == .expense ? "-" : "+")\(transaction.amount.formatted(.currency(code: transaction.currency)))")
                    .font(.callout)
                Text(transaction.type == .transfer ? "\(transaction.transferOutAccount?.name ?? "") → \(transaction.transferInAccount?.name ?? "")" : (transaction.account?.name ?? ""))
                    .grayTextStyle(font: .footnote)
            }
        )
    }
}

#Preview {
    let exampleTransaction = Transaction(
        datetime: Date(),
        amount: 20.50,
        currency: "USD",
        type: .expense,
        category: Category(name: "Food", icon: "fork.knife.circle"),
        book: Book(name: "Personal"),
        account: Account(name: "Cash", currency: "USD", icon: "dollarsign.circle"),
        notes: "Lunch at a restaurant"
    )
    return TransactionView(transaction: exampleTransaction)
}
