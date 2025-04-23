//
//  View+Extensions.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

extension View {
    func customFont(size: CGFloat, weight: Font.Weight = .regular, color: Color = Color("FontColorDark")) -> some View {
        self.font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}
