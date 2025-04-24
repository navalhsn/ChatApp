//
//  WebSocketManager.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//

import Foundation

class WebSocketManager: ObservableObject {
    @Published var isConnected: Bool = false
    @Published var errorMessage: IdentifiableAlert?
    @Published var noConnection: Bool = false
    private let offlineQueueManager = OfflineMessageQueueManager()
    @Published var messages: [Message] = []
    
    private var webSocketTask: URLSessionWebSocketTask?
    let webSocketURL = URL(string: "wss://s14506.blr1.piesocket.com/v3/1?api_key=h1N726iAoJmOdESuurZiEiQ0Ydt6VRY9bU44nRE2&notify_self=1")!

    func connectWebSocket() {
        let session = URLSession(configuration: .default)
        webSocketTask = session.webSocketTask(with: webSocketURL)
        webSocketTask?.resume()
        
        // ✅ Confirm connection using a ping
        webSocketTask?.sendPing { [weak self] error in
            DispatchQueue.main.async {
                if error == nil {
                    self?.isConnected = true // ✅ Update only if connection is confirmed
                } else {
                    self?.isConnected = false
                    self?.errorMessage = IdentifiableAlert(message: "WebSocket failed to connect")
                }
            }
        }
        
        receiveMessage()
    }

    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        isConnected = false
    }
    
    func checkNetworkConnection() {
        if !isConnected {
            noConnection = true
        } else {
            noConnection = false
            // Retry messages on reconnection
            offlineQueueManager.retryMessagesIfConnected(isConnected: isConnected, sendMessage: sendMessageDirectly)
        }
    }
    
    private func sendMessageDirectly(_ message: Message) {
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
                        self?.messages.append(newMessage)
                    }
                default:
                    break
                }
            }
            self?.receiveMessage()
        }
    }
    
    func sendMessage(inputText: String) {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = Message(sender: "You", content: inputText)
        messages.append(newMessage)
        
        let message = URLSessionWebSocketTask.Message.string(inputText)
        webSocketTask?.send(message) { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.errorMessage = IdentifiableAlert(message: "Failed to send message: \(error.localizedDescription)")
                }
            }
        }
        
        if isConnected {
            sendMessageDirectly(newMessage)
        } else {
            // Now actually using OfflineMessageQueueManager
            offlineQueueManager.addMessage(newMessage)
        }
    }
    
}

