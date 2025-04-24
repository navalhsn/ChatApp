//
//  ChatListViewExtension.swift
//  ChatApp
//
//  Created by Naval Hasan on 24/04/25.
//

import SwiftUI

extension ChatListView {
    struct ListCellView: View {
        let botName: String
        let message: String
        
        var body: some View {
            VStack {
                HStack {
                    VStack {
                        Text(botName)
                            .customFont(size: 15, weight: .bold, color: Color("TextSecondary"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        Text(message)
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Image(systemName: "arrow.right")
                        .font(.system(size: 24))
                        .foregroundColor(Color("PrimaryIcon"))
                }
                
                Divider()
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .background(Color("Divider"))
            }
        }
    }
    
}
