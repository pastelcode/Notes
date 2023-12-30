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
                    VStack {
                        Image(systemName: "tray")
                            .font(.largeTitle)
                        Text("No notes to show")
                            .padding(.top)
                            .font(.headline)
                        Text("You haven't created any note yet. Try creating one with the button below.")
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Button("Create note", systemImage: "square.and.pencil") {
                            showCreateNoteView = true
                        }
                        .padding(.top)
                    }
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
                NoteDetailsView()
                    .interactiveDismissDisabled()
            }
        }
    }
}

// MARK: - Previews
#Preview("Empty") {
    NotesView()
        .environment(NotesViewModel())
}

#Preview("Populated") {
    let _ = NotesDatabase(inMemory: true)
    let notes = [
        Note(
            title: "Note 1",
            content: "This is the first note",
            iconName: "rectangle.fill.badge.plus",
            createdAt: .now,
            updatedAt: .now
        ),
        Note(
            title: "Note 2",
            content: "This is the second note",
            iconName: "figure.walk",
            createdAt: .now,
            updatedAt: .now
        ),
        Note(
            title: "Note 3",
            content: "This is the third note",
            iconName: "arrowshape.left.arrowshape.right",
            createdAt: .now,
            updatedAt: .now
        ),
    ]
    return NotesView()
        .environment(NotesViewModel(notes: notes))
}
