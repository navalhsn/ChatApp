//
//  View+Extensions.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUI

// Font
extension View {
    func customFont(size: CGFloat, weight: Font.Weight = .regular, color: Color = Color("TextPrimary")) -> some View {
        self.font(.system(size: size, weight: weight))
            .foregroundColor(color)
    }
}

// Alert
extension View {
    func withWebSocketAlerts(_ webSocketManager: WebSocketManager) -> some View {
        self.modifier(WebSocketAlertsViewModifier(webSocketManager: webSocketManager))
    }
}
