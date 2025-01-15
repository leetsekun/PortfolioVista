//
//  Category.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/5/24.
//

import Foundation
import SwiftData

@Model
final class Category {
    @Attribute(.unique) var name: String
    var icon: String
    @Relationship(inverse: \Category.subcategories) var parent: Category?
    @Relationship(deleteRule: .cascade) var subcategories: [Category] = []
    
    init(name: String, icon: String, parent: Category? = nil) {
        self.name = name
        self.icon = icon
        self.parent = parent
    }
    
    static func getRootCategories(context: ModelContext) -> [Category] {
        let descriptor = FetchDescriptor<Category>(predicate: #Predicate { $0.parent == nil }, sortBy: [SortDescriptor(\.name)])
        return (try? context.fetch(descriptor)) ?? []
    }
}
