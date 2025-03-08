//
//  TransactionDetailView.swift
//  PortfolioVista
//
//  Created by leetsekun on 3/2/25.
//

import SwiftUI

struct TransactionDetailView: View {
    @Namespace var namespace
    @Bindable var txn: Transaction
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Header with Back Button and Matched Geometry Effect
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                }
                
                Text(txn.book?.name ?? "Unknown Book")
                    .font(.title2)
                    .bold()
                    .matchedGeometryEffect(id: txn.id, in: namespace)
                
                Spacer()
            }
            .padding()
            
            // Transaction Details Form
            Form {
                Section {
                    NavigationLink(destination: Text("Choose Category")) {
                        HStack {
                            Text("类型")
                            Spacer()
                            Text(txn.type.rawValue)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    HStack {
                        Text("账本")
                        Spacer()
                        Text(txn.book?.name ?? "Unknown Book")
                            .foregroundColor(.gray)
                    }
                }
                
                Section {
                    // DatePicker("时间", selection: $txn.timestamp, displayedComponents: .date)
                    
                    // HStack {
                    //     Text("金额")
                    //     Spacer()
                    //     TextField("金额", value: $txn.amount, format: .currency(code: txn.currency))
                    //         .multilineTextAlignment(.trailing)
                    //         .keyboardType(.decimalPad)
                    // }
                    
                    NavigationLink(destination: Text("选择货币")) {
                        HStack {
                            Text("货币")
                            Spacer()
                            Text(txn.currency)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: Text("选择账户")) {
                        HStack {
                            Text("账户")
                            Spacer()
                            Text(txn.account?.name ?? "Unknown Account")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: Text("输入备注")) {
                        HStack {
                            Text("备注")
                            Spacer()
                            Text(txn.notes?.isEmpty ?? true ? "无" : txn.notes!)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    @Namespace var namespace
    let mockTransaction = Transaction(
        datetime: Date(),
        amount: Decimal(100.00),
        currency: "USD",
        type: .expense,
        category: nil,
        book: Book(name: "Personal", icon: "book.circle"),
        account: Account(name: "Checking", currency: "USD", icon: "dollarsign.circle"),
        notes: "Grocery shopping"
    )
    TransactionDetailView(txn: mockTransaction)
}
