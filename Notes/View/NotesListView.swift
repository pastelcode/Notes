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
    let _ = NotesDatabase(inMemory: true)
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    let notes = [
        Note(title: "Hacer mi cama", content: "Componer mi cama", iconName: "backpack", createdAt: yesterday, updatedAt: yesterday),
        Note(title: "Hacer cita en Visualiza", iconName: "ruler", createdAt: yesterday, updatedAt: .now),
        Note(title: "Tomar agua", content: "2 litros como mínimo", iconName: "paperclip", createdAt: yesterday, updatedAt: .now)
    ]
    
    return NotesListView()
        .environment(NotesViewModel(notes: notes + notes + notes + notes + notes))
}
