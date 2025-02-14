//
//  PreviewHelper.swift
//  PortfolioVista
//
//  Created by leetsekun on 2/14/25.
//

import Foundation

struct PreviewHelper {
    static func sampleBooks() -> [Book] {
        return [
            Book(name: "Personal"),
            Book(name: "Business")
        ]
    }

    static func sampleAccounts() -> [Account] {
        return [
            Account(name: "Cash", currency: "USD", icon: "dollarsign.circle"),
            Account(name: "Credit Card", currency: "USD", icon: "creditcard"),
            Account(name: "Debit Card", currency: "USD", icon: "debitcard"),
            Account(name: "Bank Transfer", currency: "USD", icon: "banknote"),
            Account(name: "Bank Account", currency: "USD", icon: "banknote"),
            Account(name: "Savings Account", currency: "USD", icon: "banknote")
        ]
    }

    static func sampleCategories() -> [Category] {
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
        
        var categoryDict = [String: Category]()
        
        for categoryData in initialCategories {
            let category = Category(name: categoryData.name, icon: categoryData.systemImage)
            categoryDict[categoryData.name] = category
        }
        
        for categoryData in secondaryCategories {
            if let parentCategory = categoryDict[categoryData.parentName] {
                let category = Category(name: categoryData.name, icon: categoryData.systemImage, parent: parentCategory)
                parentCategory.subcategories.append(category)
                categoryDict[categoryData.name] = category
            }
        }
        
        return Array(categoryDict.values)
    }

    static func sampleTransactions() -> [Transaction] {
        let categoryDict = Dictionary(uniqueKeysWithValues: sampleCategories().map { ($0.name, $0) })
        let bookDict = Dictionary(uniqueKeysWithValues: sampleBooks().map { ($0.name, $0) })
        let accountDict = Dictionary(uniqueKeysWithValues: sampleAccounts().map { ($0.name, $0) })
        
        return [
            Transaction(datetime: Date(), amount: 20.50, currency: "USD", type: .expense, category: categoryDict["Food"], book: bookDict["Personal"], account: accountDict["Cash"], notes: "Lunch at a restaurant"),
            Transaction(datetime: Date(), amount: 15.00, currency: "USD", type: .expense, category: categoryDict["Transport"], book: bookDict["Personal"], account: accountDict["Credit Card"], notes: "Taxi fare"),
            Transaction(datetime: Date(), amount: 45.75, currency: "USD", type: .expense, category: categoryDict["Groceries"], book: bookDict["Personal"], account: accountDict["Debit Card"], notes: "Weekly groceries"),
            Transaction(datetime: Date(), amount: 60.00, currency: "USD", type: .expense, category: categoryDict["Entertainment"], book: bookDict["Personal"], account: accountDict["Cash"], notes: "Movie tickets"),
            Transaction(datetime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, amount: 100.00, currency: "USD", type: .expense, category: categoryDict["Utilities"], book: bookDict["Personal"], account: accountDict["Bank Transfer"], notes: "Electricity bill"),
            Transaction(datetime: Date(), amount: 200.00, currency: "USD", type: .transfer, category: categoryDict["Other"], book: bookDict["Personal"], transferOutAccount: accountDict["Bank Account"], transferInAccount: accountDict["Savings Account"], notes: "Transfer to savings"),
            Transaction(datetime: Date(), amount: 150.00, currency: "USD", type: .transfer, category: categoryDict["Other"], book: bookDict["Personal"], transferOutAccount: accountDict["Bank Account"], transferInAccount: accountDict["Savings Account"]),
            Transaction(datetime: Date(), amount: 75.00, currency: "USD", type: .income, category: categoryDict["Other"], book: bookDict["Personal"], account: accountDict["Bank Account"], notes: "Monthly salary"),
            Transaction(datetime: Date(), amount: 30.00, currency: "USD", type: .expense, category: categoryDict["Other"], book: bookDict["Personal"], account: accountDict["Credit Card"], notes: "Doctor's appointment"),
            Transaction(datetime: Date(), amount: 50.00, currency: "USD", type: .income, category: categoryDict["Other"], book: bookDict["Personal"], account: accountDict["Bank Account"], notes: "Freelance project"),
            Transaction(datetime: Date(), amount: 25.00, currency: "USD", type: .expense, category: categoryDict["Dining Out"], book: bookDict["Personal"], account: accountDict["Cash"], notes: "Dinner with friends"),
            Transaction(datetime: Date(), amount: 120.00, currency: "USD", type: .expense, category: categoryDict["Shopping"], book: bookDict["Personal"], account: accountDict["Debit Card"], notes: "Clothes shopping"),
            Transaction(datetime: Date(), amount: 80.00, currency: "USD", type: .income, category: categoryDict["Other"], book: bookDict["Personal"], account: accountDict["Bank Account"], notes: "Stock dividends"),
        ]
    }
}


