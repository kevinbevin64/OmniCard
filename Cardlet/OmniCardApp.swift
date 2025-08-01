//
//  OmniCardApp.swift
//  OmniCard
//
//  Created by Kevin Chen on 7/27/25.
//

import SwiftUI
import SwiftData

@main
struct OmniCardApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Card.self)
    }
}
