//
//  AppLauncher.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/25/23.
//

import SwiftUI

@main
struct AppLauncher {
    static func main() throws {
        if ProcessInfo.processInfo.arguments.contains("isTesting") {
            TestApp.main()
        } else {
            NotesApp.main()
        }
    }
}

struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .withViewModels()
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                Image(systemName: "testtube.2")
                    .font(.largeTitle)
                Text("Running tests")
                    .padding(.top)
                    .font(.headline)
            }
        }
    }
}
