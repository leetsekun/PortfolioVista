//
//  Item.swift
//  PortfolioVista
//
//  Created by 李泽昆 on 1/14/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
