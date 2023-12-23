//
//  NotesList.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import SwiftUI

struct NotesListView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    @State private var showCreateNoteView = false
    @State private var dateToSortBy = \Note.createdAt
    
    private var filteredNotes: [Note] {
        notesViewModel.notes.sorted { previousNote, nextNote in
            previousNote[keyPath: dateToSortBy] > nextNote[keyPath: dateToSortBy]
        }
    }
    
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
            ForEach(filteredNotes) { note in
                NavigationLink {
                    NoteDetailsView(note: note)
                } label: {
                    NoteRow(note: note, dateToShow: dateToSortBy)
                }
            }
        }
    }
}

#Preview {
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now)!
    let notes = [
        Note(title: "Hacer mi cama", content: "Componer mi cama", createdAt: yesterday, updatedAt: yesterday),
        Note(title: "Hacer cita en Visualiza", createdAt: yesterday, updatedAt: .now),
        Note(title: "Tomar agua", content: "2 litros como mínimo", createdAt: yesterday, updatedAt: .now)
    ]
    
    return NotesListView()
        .environment(NotesViewModel(notes: notes + notes + notes + notes + notes))
}
