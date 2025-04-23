//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    @Published var isConnected: Bool = false
    @Published var errorMessage: IdentifiableAlert?

    private var webSocketTask: URLSessionWebSocketTask?
    private var cancellables = Set<AnyCancellable>()

    private let webSocketURL = URL(string: "wss://s14506.blr1.piesocket.com/v3/1?api_key=h1N726iAoJmOdESuurZiEiQ0Ydt6VRY9bU44nRE2&notify_self=1")!

    init() {
        connectWebSocket()
    }

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

    func sendMessage() {
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
        inputText = ""
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
}
