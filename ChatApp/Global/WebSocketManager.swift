//
//  WebSocketManager.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//

import Foundation

class WebSocketManager: ObservableObject {
    @Published var isConnected: Bool = false
    @Published var receivedMessages: [Message] = []
    @Published var errorMessage: IdentifiableAlert?

    private var webSocketTask: URLSessionWebSocketTask?
    let webSocketURL = URL(string: "wss://s14506.blr1.piesocket.com/v3/1?api_key=h1N726iAoJmOdESuurZiEiQ0Ydt6VRY9bU44nRE2&notify_self=1")!

    func connectWebSocket() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: webSocketURL)
        webSocketTask?.resume()
        isConnected = true
        receiveMessage()
    }

    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
    
    func sendMessage(_ message: Message) {
        guard isConnected else { return }
        
        let webMessage = URLSessionWebSocketTask.Message.string(message.content)
        webSocketTask?.send(webMessage) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = IdentifiableAlert(message: "Failed to send message: \(error.localizedDescription)")
                }
            }
        }
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.errorMessage = IdentifiableAlert(message: "Failed to receive message: \(error.localizedDescription)")
                }
            case .success(let message):
                switch message {
                case .string(let text):
                    let newMessage = Message(sender: "Bot", content: text)
                    DispatchQueue.main.async {
                        self?.receivedMessages.append(newMessage)
                    }
                default:
                    break
                }
            }
            self?.receiveMessage()
        }
    }
}

