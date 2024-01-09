//
//  NotesList.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import SwiftUI

struct NotesListView: View {
    // MARK: - View properties
    @Environment(NotesViewModel.self) private var notesViewModel
    @State private var showCreateNoteView = false

    // MARK: - View body
    var body: some View {
        @Bindable var notesViewModel = notesViewModel

        List {
            Section {
                Picker("Sort by", selection: $notesViewModel.sortNotesBy) {
                    Text("Creation")
                        .tag(\Note.createdAt)
                    Text("Updated")
                        .tag(\Note.updatedAt)
                }
            }
            ForEach(notesViewModel.sortedNotes) { note in
                NavigationLink {
                    NoteDetailsView(note: note)
                } label: {
                    NoteRow(note: note, dateToShow: notesViewModel.sortNotesBy)
                }
                .swipeActions {
                    Button("Remove", systemImage: "trash") {
                        withAnimation(.spring) {
                            notesViewModel.removeNoteWith(identifier: note.identifier)
                        }
                    }
                    .tint(.red)
                }
            }
        }
    }
}

#Preview {
    NotesListView()
        .environment(NotesViewModel.forPreviews.populate())
}
