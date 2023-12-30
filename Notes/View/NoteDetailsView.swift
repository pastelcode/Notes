//
//  CreateNoteView.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/22/23.
//

import SwiftUI
import SFSymbolsPicker

struct NoteDetailsView: View {
    // MARK: - Form state properties
    @State private var title = ""
    @State private var content = ""
    @State private var iconName = ""
    
    // MARK: - View properties
    let note: Note?
    @Environment(\.dismiss) private var dismiss
    @Environment(NotesViewModel.self) private var notesViewModel
    @State private var showEmptyTitleError = false
    @State private var showDeleteAlert = false
    @State private var showIconPicker = false
    
    private var isUpdate: Bool {
        note != nil
    }
    private var isModifiedFromOriginalNote: Bool {
        title != note?.title || content != note?.content || iconName != note?.iconName
    }
    
    // MARK: - Initializers
    init(note: Note? = nil) {
        self.note = note
    }
    
    // MARK: - Methods
    private func generateRandomIconName() -> String {
        ["figure.wave", "power", "sunset", "moon", "display", "camera.aperture", "square.stack"].randomElement()!
    }
    
    // MARK: - View body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Button("Select icon", systemImage: iconName) {
                    showIconPicker = true
                }
                .padding(.leading)
                .padding(.top)
                .font(.system(size: 40))
                .labelStyle(.iconOnly)
                .tint(.primary)
                .sheet(isPresented: $showIconPicker) {
                    SymbolsPicker(selection: $iconName, title: "Select note icon", autoDismiss: true)
                }
                TextField("Untitled", text: $title, axis: .vertical)
                    .font(.title)
                    .bold()
                    .onChange(of: title) { _, newValue in
                        showEmptyTitleError = newValue.containsOnlyWhitespaces
                    }
                    .padding()
                if showEmptyTitleError {
                    HStack {
                        Image(systemName: "exclamationmark.circle")
                            .font(.caption)
                        Text("Title is required")
                            .font(.caption)
                    }
                    .foregroundStyle(.red)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                TextField("Content", text: $content, axis: .vertical)
                    .padding(.horizontal)
                Spacer()
            }
            // MARK: Toolbar
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
                                    identifier: note!.identifier,
                                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                    content: content.trimmingCharacters(in: .whitespacesAndNewlines),
                                    iconName: iconName
                                )
                            } else {
                                notesViewModel.createNoteWith(
                                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                                    content: content.trimmingCharacters(in: .whitespacesAndNewlines),
                                    iconName: iconName
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
            // MARK: Navigation bar
            .navigationTitle(isUpdate ? "Note details" : "New note" )
            .navigationBarTitleDisplayMode(.inline)
            
            // MARK: Alerts
            .alert("Delete note", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    notesViewModel.removeNoteWith(identifier: note!.identifier)
                    dismiss()
                }
            }
        }
        // MARK: Initialization of form state properties with incoming note to update
        .onAppear {
            if let note {
                title = note.title
                content = note.content
            }
            iconName = note?.iconName ?? generateRandomIconName()
        }
    }
}

#Preview("Creation") {
    NoteDetailsView()
        .environment(NotesViewModel())
}

#Preview("Update") {
    let _ = NotesDatabase(inMemory: true)
    let note = Note(
        title: "Old title",
        content: "Old description",
        iconName: "graduationcap",
        createdAt: .now,
        updatedAt: .now
    )
    return NoteDetailsView(note: note)
        .environment(NotesViewModel())
}
