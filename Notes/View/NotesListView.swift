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
    @State private var dateToSortBy = \Note.createdAt

    private var sortedNotes: [Note] {
        notesViewModel.notes.sorted { previousNote, nextNote in
            previousNote[keyPath: dateToSortBy] > nextNote[keyPath: dateToSortBy]
        }
    }

    // MARK: - View body
    var body: some View {
        List {
            Section {
                Picker("Sort by", selection: $dateToSortBy) {
                    Text("Creation")
                        .tag(\Note.createdAt)
                    Text("Updated")
                        .tag(\Note.updatedAt)
                }
            }
            ForEach(sortedNotes) { note in
                NavigationLink {
                    NoteDetailsView(note: note)
                } label: {
                    NoteRow(note: note, dateToShow: dateToSortBy)
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
        .environment(NotesViewModel.populated)
}
