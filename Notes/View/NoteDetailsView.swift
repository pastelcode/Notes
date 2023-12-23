//
//  CreateNoteView.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/22/23.
//

import SwiftUI

struct NoteDetailsView: View {
    init(note: Note? = nil) {
        self.note = note
        _title = State(initialValue: note?.title ?? "")
        _description = State(initialValue: note?.description ?? "")
    }
    
    private enum FocusedField {
        case title
        case description
    }
    
    @Environment(NotesViewModel.self) private var notesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var showEmptyTitleError = false
    @State private var showDeleteAlert = false
    
    private let note: Note?
    
    private var isUpdate: Bool {
        note != nil
    }
    private var isModifiedFromOriginalNote: Bool {
        title != note?.title || description != note?.description
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title (required)", text: $title, axis: .vertical)
                        .onChange(of: title) { _, newValue in
                            showEmptyTitleError = newValue.containsOnlyWhitespaces
                        }
                    TextField("Description", text: $description, axis: .vertical)
                } footer: {
                    if showEmptyTitleError {
                        HStack {
                            Spacer()
                            Image(systemName: "exclamationmark.circle")
                                .font(.system(size: 20))
                            VStack(alignment: .leading) {
                                Text("Title is required")
                                    .font(.callout)
                                Text("Enter a value for the title")
                            }
                            Spacer()
                        }
                        .padding()
                        .background(.red.opacity(0.15))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.top)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if !isUpdate {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    if isModifiedFromOriginalNote {
                        Button(isUpdate ? "Update" : "Create") {
                            guard !title.containsOnlyWhitespaces else {
                                showEmptyTitleError = true
                                return;
                            }
                            if (isUpdate) {
                                notesViewModel.updateNoteWith(
                                    id: note!.id,
                                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                    description: description.trimmingCharacters(in: .whitespacesAndNewlines)
                                )
                            } else {
                                notesViewModel.createNoteWith(
                                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                    description: description.trimmingCharacters(in: .whitespacesAndNewlines)
                                )
                            }
                            dismiss()
                        }
                    }
                }
                if isUpdate {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            showDeleteAlert = true
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle(isUpdate ? "Note details" : "New note" )
            .navigationBarTitleDisplayMode(.large)
            .alert("Delete note", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    notesViewModel.removeNoteWith(id: note!.id)
                    dismiss()
                }
            }
        }
    }
}

#Preview("Creation") {
    NoteDetailsView()
        .environment(NotesViewModel())
}

#Preview("Update") {
    NoteDetailsView(
        note: .init(title: "Old title", description: "Old description", createdAt: .now, updatedAt: .now)
    )
    .environment(NotesViewModel())
}
