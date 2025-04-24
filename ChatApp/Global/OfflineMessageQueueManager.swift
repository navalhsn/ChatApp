//
//  OfflineMessageQueueManager.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//

import Foundation

class OfflineMessageQueueManager {
    static let shared = OfflineMessageQueueManager()
    private init() {}
    
    private var queuedMessages: [Message] = []
    private let queue = DispatchQueue(label: "OfflineMessageQueue")

    func addMessage(_ message: Message) {
        queue.async {
            self.queuedMessages.append(message)
        }
    }

    func retryMessagesIfConnected(isConnected: Bool, sendMessage: @escaping (Message) -> Void) {
        queue.async {
            guard isConnected else { return }

            let messagesToSend = self.queuedMessages
            self.queuedMessages.removeAll()

            DispatchQueue.main.async {
                for message in messagesToSend {
                    sendMessage(message)
                }
            }
        }
    }
}
