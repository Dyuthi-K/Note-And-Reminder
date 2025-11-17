//
//  Note_And_ReminderApp.swift
//  Note And Reminder
//
//  Created by dyuthi ajit kuchu on 16/11/25.
//

import SwiftUI
import SwiftData
@main
struct Notes_and_Reminder___1App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TodoItem.self)
    }
}
