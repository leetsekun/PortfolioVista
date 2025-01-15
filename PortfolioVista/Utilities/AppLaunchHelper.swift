//
//  AppFirstLaunchHelper.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/6/24.
//

import Foundation
import SwiftData

struct AppLaunchHelper {
    private static let launchedBeforeKey = "hasLaunchedBefore"
    
    static func isFirstLaunch() -> Bool {
        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: launchedBeforeKey)
        if !hasLaunchedBefore {
            UserDefaults.standard.set(true, forKey: launchedBeforeKey)
            return true
        }
        return false
    }

    static func insertInitialModelRecords(context: ModelContext) {
        let initialCategories = [
            (name: "Food", systemImage: "fork.knife"),
            (name: "Transport", systemImage: "car"),
            (name: "Utilities", systemImage: "lightbulb"),
            (name: "Entertainment", systemImage: "film"),
            (name: "Shopping", systemImage: "bag"),
            (name: "Other", systemImage: "wrench")
        ]

        let secondaryCategories = [
            (name: "Groceries", systemImage: "cart", parentName: "Food"),
            (name: "Dining Out", systemImage: "fork.knife", parentName: "Food"),
            (name: "Public Transport", systemImage: "bus", parentName: "Transport"),
            (name: "Fuel", systemImage: "fuelpump", parentName: "Transport")
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
        
        for (_, category) in categoryDict {
            context.insert(category)
        }
        
        do {
            try context.save()
        } catch {
            fatalError("Could not save initial model records: \(error)")
        }
    }
}
