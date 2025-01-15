//
//  ViewExtension.swift
//  PortfolioVista
//
//  Created by leetsekun on 10/15/24.
//

import SwiftUI

extension View {
    func monthButtonStyle() -> some View {
        self
            .foregroundColor(.white)
            .background(Circle().fill(Color.gray))
    }
}

extension View {
    func grayTextStyle(font: Font = .footnote) -> some View {
        self
            .font(font)
            .foregroundColor(.gray)
            .lineLimit(1)
            .truncationMode(.tail)
    }
}

extension View {
    func cardGroupStyle() -> some View {
        self
            .padding()
            .background(Color.white)
            .cornerRadius(Constants.cornerRadius)
    }
}

extension View {
    func headerTextStyle() -> some View {
        self
            .font(.footnote.weight(.bold))
            .foregroundColor(.gray)
            .padding(.bottom, 4)
    }
}

extension Image {
    func genericIconStyle(bgColor: Color) -> some View {
        ZStack {
            Circle()
                .fill(bgColor)
                .frame(width: 38, height: 38)
            self
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
                .foregroundColor(.white)
        }
    }
}
