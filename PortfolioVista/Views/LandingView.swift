//
//  LandingView.swift
//  PortfolioVista
//
//  Created by leetsekun on 9/30/24.
//

import SwiftUI

struct LandingView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            BookView()
                .tabItem {
                    Image(systemName: "book.pages")
                    Text("Book")
                }
                .tag(0)
            
            TestView()
                .tabItem {
                    Image(systemName: "tray.full")
                    Text("Asset")
                }
                .tag(1)
            
            DisplayView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("Analysis")
                }
                .tag(2)
        }
    }
}

#Preview {
    LandingView()
}
