//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by Naval Hasan on 23/04/25.
//

import SwiftUI

@main
struct ChatAppApp: App {
    @State private var path = NavigationPath()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path.animation(.linear(duration: 0))) {
                ChatListView()
            }
        }
    }
}
