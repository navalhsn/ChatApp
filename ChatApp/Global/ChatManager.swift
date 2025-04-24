//
//  ChatManager.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//

import Foundation

class ChatManager {
    static let shared = ChatManager()
    private init() {
        let dummyChats = [
            Chat(botName: "SupportBot", messages: [
                Message(sender: "You", content: "Hi, I need help with my order."),
                Message(sender: "Bot", content: "Sure! What seems to be the issue?")
            ]),
            Chat(botName: "SalesBot", messages: [
                Message(sender: "You", content: "I'd like to know more about your products."),
                Message(sender: "Bot", content: "We offer a range of products. What are you looking for?")
            ]),
            Chat(botName: "FAQBot", messages: [
                Message(sender: "You", content: "How can I reset my password?"),
                Message(sender: "Bot", content: "You can reset your password through the settings page.")
            ])
        ]
        chats = dummyChats
    }
    
    var chats = [Chat]()
    var currentChat: Chat?
}
