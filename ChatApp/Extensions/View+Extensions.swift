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
    func withWebSocketAlerts(_ manager: WebSocketManager) -> some View {
        self
            .alert(isPresented: Binding(get: { !(manager.isConnected) }, set: { manager.isConnected = $0 })) {
                Alert(
                    title: Text("No Internet Connection"),
                    message: Text("Please check your network connection."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .alert(item: Binding(get: { manager.errorMessage }, set: { manager.errorMessage = $0 })) { alert in
                Alert(
                    title: Text("Error"),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
    
    func withOfflineAlert(_ manager: WebSocketManager) -> some View {
        self
            .alert(isPresented: Binding(get: { manager.showOfflineAlert }, set: { manager.showOfflineAlert = $0 })) {
                Alert(
                    title: Text("Text saved offline"),
                    message: Text("Once connection is back, your text will be sent."),
                    dismissButton: .default(Text("OK"))
                )
            }
    }
}

