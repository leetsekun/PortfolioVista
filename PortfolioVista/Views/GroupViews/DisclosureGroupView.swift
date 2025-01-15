//
//  DisclosureGroupView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/17/24.
//

import SwiftUI

struct GenericDisclosureGroup<Element: Identifiable, Content: View>: View {
    @State private var isExpanded: Bool = true

    var leftLabel: String
    var rightLabel: String
    var elements: [Element]
    var content: (Element) -> Content
    
    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(spacing: 16) {
                ForEach(elements) { element in
                    content(element)
                    if element.id != elements.last?.id {
                        Divider()
                    }
                }
            }
            .cardGroupStyle()
        } label: {
            HStack {
                Text(leftLabel)
                Spacer()
                Text(rightLabel)
            }
            .headerTextStyle()
        }
        .accentColor(.gray)
    }
}
