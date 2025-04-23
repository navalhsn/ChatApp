//
//  Colors+Extension.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//
import SwiftUICore

extension Color {
    // example
    // .foregroundColor(Color(hex: "A54B47"))
    
    init(hex: String) {
        // Sanitize the hex string
        let sanitizedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: sanitizedHex).scanHexInt64(&int)
        
        let red, green, blue, alpha: Double
        switch sanitizedHex.count {
        case 6: // RGB (e.g., #RRGGBB)
            red = Double((int >> 16) & 0xFF) / 255.0
            green = Double((int >> 8) & 0xFF) / 255.0
            blue = Double(int & 0xFF) / 255.0
            alpha = 1.0
        case 8: // RGBA (e.g., #RRGGBBAA)
            red = Double((int >> 24) & 0xFF) / 255.0
            green = Double((int >> 16) & 0xFF) / 255.0
            blue = Double((int >> 8) & 0xFF) / 255.0
            alpha = Double(int & 0xFF) / 255.0
        default:
            // Default color (white) for invalid hex codes
            red = 1.0
            green = 1.0
            blue = 1.0
            alpha = 1.0
        }
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
}

