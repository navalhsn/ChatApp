//
//  WebSocketAlertsViewModifier.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//
import SwiftUI

struct WebSocketAlertsViewModifier: ViewModifier {
    @ObservedObject var webSocketManager: WebSocketManager

    func body(content: Content) -> some View {
        content
            .alert(isPresented: Binding(get: { webSocketManager.noConnection }, set: { webSocketManager.noConnection = $0 })) {
                Alert(title: Text("No Internet Connection"),
                      message: Text("Please check your network connection."),
                      dismissButton: .default(Text("OK")))
            }
            .alert(item: Binding(get: { webSocketManager.errorMessage }, set: { webSocketManager.errorMessage = $0 })) { alert in
                Alert(title: Text("Error"),
                      message: Text(alert.message),
                      dismissButton: .default(Text("OK")))
            }
    }
}
