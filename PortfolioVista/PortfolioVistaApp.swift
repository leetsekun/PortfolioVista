//
//  PortfolioVistaApp.swift
//  PortfolioVista
//
//  Created by leetsekun on 9/30/24.
//

import SwiftUI
import SwiftData

@main
struct PortfolioVistaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Transaction.self,
            Book.self,
            Account.self,
            Category.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            print("ModelContainer created")
            if AppLaunchHelper.isFirstLaunch() {
                print("First launch")
                let context = container.mainContext
                insertInitialModelRecords(context: context)
            }
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LandingView()
        }
        .modelContainer(sharedModelContainer)
    }

    private static func insertInitialModelRecords(context: ModelContext) {
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
