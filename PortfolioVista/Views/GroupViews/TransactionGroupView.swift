//
//  TransactionGroupView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/17/24.
//

import SwiftUI
import SwiftData

struct TransactionGroupView: View {
    @Query private var queryTxns: [Transaction]
    @Environment(\.modelContext) private var modelContext
    var selectedBook: Book?
    var searchText: String

    // preview control
    var previewTxns: [Transaction]?
    var isPreview: Bool = false

    private var txns: [Transaction] {
        isPreview ? previewTxns! : queryTxns
    }

    var filteredTxns: [Transaction] {
        txns.filter { txn in
            (selectedBook == nil || txn.book == selectedBook) &&
            (searchText.isEmpty || txn.category?.name.localizedCaseInsensitiveContains(searchText) == true ||
            txn.notes?.localizedCaseInsensitiveContains(searchText) == true)
        }
        .sorted { $0.datetime > $1.datetime } // Sort by datetime, latest first
    }

    var groupedTxns: [String: [Transaction]] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd EEEE"
        return Dictionary(grouping: txns) { txn in
            formatter.string(from: txn.datetime)
        }
    }

    var body: some View {
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

            ForEach(groupedTxns.keys.sorted(), id: \.self) { date in
                LazyVStack(alignment: .leading) {
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
    }

    private func getRightLabel(for date: String) -> String {
        let income = groupedTxns[date]!
            .filter { $0.type == .income }
            .reduce(Decimal(0)) { $0 + $1.amount }
        let expense = groupedTxns[date]!
            .filter { $0.type == .expense }
            .reduce(Decimal(0)) { $0 + $1.amount }
        var label = ""
        if income > 0 {
            label += "收入: \(income.formatted(.currency(code: "USD")))"
        }
        if expense > 0 {
            if !label.isEmpty { label += "  " }
            label += "支出: \(expense.formatted(.currency(code: "USD")))"
        }
        return label
    }
}

#Preview {
    TransactionGroupView(searchText: "", previewTxns: PreviewHelper.sampleTransactions(), isPreview: true)
}
