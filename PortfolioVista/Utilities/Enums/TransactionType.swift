//
//  TransactionType.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/5/24.
//

import Foundation
enum TransactionType: String, Codable {
    case income = "Income"
    case expense = "Expense"
    case transfer = "Transfer"
}
