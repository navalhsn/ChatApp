//
//  OfflineMessageQueueManager.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//

import Foundation

class OfflineMessageQueueManager {
    private var queuedMessages: [Message] = []
    
    func addMessage(_ message: Message) {
        queuedMessages.append(message)
    }
    
    func retryMessagesIfConnected(isConnected: Bool, sendMessage: (Message) -> Void) {
        guard isConnected else { return }
        
        for message in queuedMessages {
            sendMessage(message)
        }
        
        queuedMessages.removeAll()
    }
}
