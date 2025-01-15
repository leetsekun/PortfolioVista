//
//  SelectionView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/14/24.
//

import SwiftUI

struct SelectionView: View {
    var items: [SheetItem]

    var body: some View {
        VStack {
            Text("我的帐本")
                .padding(.top, 10)
            
            ScrollView {
                VStack(spacing: 2) {
                    ForEach(items) { item in
                        VStack(spacing: 2) {
                            HStack {
                                Image(systemName: item.icon)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 4)
                                
                                Text(item.name)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding(8)
                            if item.id != items.last?.id {
                                Divider()
                            }
                        }
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                )
            }
            .background(Color(.systemGray6))
        }
    }
}

#Preview {
    let exampleItems = [
        SheetItem(name: "Example 1", icon: "star"),
        SheetItem(name: "Example 2", icon: "heart"),
        SheetItem(name: "Example 3", icon: "bell"),
        SheetItem(name: "Example 4", icon: "bookmark"),
        SheetItem(name: "Example 5", icon: "flag")
    ]
    SelectionView(items: exampleItems)
}
