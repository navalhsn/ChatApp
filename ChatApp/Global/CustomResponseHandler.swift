//
//  CustomResponseHandler.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import Foundation

class CustomResponseHandler {
    static func getResponse(for userMessage: String) -> String {
        let lowercasedMessage = userMessage.lowercased()
        
        switch lowercasedMessage {
        case "hello", "hi":
            return "Hey there! How can I assist you today?"
        case "how are you":
            return "I'm just a bot, but I'm here to help!"
        case "what can you do":
            return "I can chat with you, answer questions, and even help debug your code!"
        case "bye":
            return "Goodbye! Have a great day!"
        default:
            return "Interesting! Could you tell me more?"
        }
    }
}
