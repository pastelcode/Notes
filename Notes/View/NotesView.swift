//
//  NotesView.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/22/23.
//

import SwiftUI

struct NotesView: View {
    // MARK: - View properties
    @Environment(NotesViewModel.self) private var notesViewModel
    @State private var showCreateNoteView = false
    
    // MARK: - View body
    var body: some View {
        NavigationStack {
            ZStack {
                if notesViewModel.notes.isEmpty {
                    EmptyNotesListView(showCreateNoteView: $showCreateNoteView)
                } else {
                    NotesListView()
                }
            }
            // MARK: Toolbar
            .toolbar {
                if !notesViewModel.notes.isEmpty {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Create note", systemImage: "plus") {
                            showCreateNoteView = true
                        }
                    }
                }
            }
            .navigationTitle("Notes")
            .sheet(isPresented: $showCreateNoteView) {
                NoteDetailsView(note: nil)
                    .interactiveDismissDisabled()
            }
        }
    }
}

// MARK: - Previews
#Preview("Empty") {
    NotesView()
        .environment(NotesViewModel.forTests)
}

#Preview("Populated") {
    NotesView()
        .environment(NotesViewModel.populated)
}
