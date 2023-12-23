//
//  NotesView.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/22/23.
//

import SwiftUI

struct NotesView: View {
    @Environment(NotesViewModel.self) private var notesViewModel
    
    @State private var showCreateNoteView = false
    
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

#Preview {
    NotesView()
        .environment(NotesViewModel())
}
