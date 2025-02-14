//
//  TransactionView.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/10/24.
//

import SwiftUI

struct GenericElementView<Content1: View, Content2: View>: View {
    var icon: String
    var title: String
    var bgColor: Color
    var content1: Content1
    var content2: Content2

    var body: some View {
        HStack {
            Image(systemName: icon)
                .genericIconStyle(bgColor: bgColor)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .regular))
                    .bold()
                content1
            }

            Spacer()
            
            content2
            .layoutPriority(1)
        }
        .lineLimit(1)
    }
}
