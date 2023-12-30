//
//  NotesApp.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import SwiftUI

struct NotesApp: App {
    init() {
        setupServiceContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .environment(NotesViewModel())
    }
    
    @MainActor func setupServiceContainer() {
        ServiceContainer.register(type: NotesDatabaseProtocol.self, using: NotesDatabase())
        ServiceContainer.register(type: CreateNoteUseCase.self, using: CreateNoteUseCase())
        ServiceContainer.register(type: FetchAllNotesUseCase.self, using: FetchAllNotesUseCase())
        ServiceContainer.register(type: UpdateNoteUseCase.self, using: UpdateNoteUseCase())
    }
}
