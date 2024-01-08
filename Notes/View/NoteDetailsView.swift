//
//  NoteDetailsView.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/22/23.
//

import SwiftUI
import SFSymbolsPicker

struct NoteDetailsView: View {
    private enum FocusedField {
        case title
        case content
    }

    private enum EditingMode {
        case update(originalNote: Note)
        case creation
    }

    // MARK: - View properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.haptics) private var haptics
    @Environment(NotesViewModel.self) private var notesViewModel
    private let editingMode: EditingMode
    @State private var title = ""
    @State private var content = ""
    @State private var iconName = "note"
    @State private var showEmptyTitleError = false
    @State private var showDeleteAlert = false
    @State private var showIconPicker = false
    @FocusState private var focusedField: FocusedField?

    private var isModifiedFromOriginalNote: Bool {
        guard case .update(let originalNote) = editingMode else {
            return true
        }
        return title != originalNote.title || content != originalNote.content || iconName != originalNote.iconName
    }

    private var isTitleEmpty: Bool {
        title.containsOnlyWhitespaces
    }

    private var navigationTitle: String {
        switch editingMode {
        case .update(_):
            "Note details"
        case .creation:
            "New note"
        }
    }

    // MARK: - Initializers
    
    init(note: Note?) {
        func generateRandomIconName() -> String {
            [
                "figure.wave",
                "power",
                "sunset",
                "moon",
                "display",
                "camera.aperture",
                "square.stack"
            ].randomElement()!
        }

        editingMode = if let note {
            .update(originalNote: note)
        } else {
            .creation
        }
        _title = .init(initialValue: note?.title ?? "")
        _content = .init(initialValue: note?.content ?? "")
        _iconName = .init(initialValue: note?.iconName ?? generateRandomIconName())
    }

    // MARK: - Methods

    private func saveNote() {
        guard !title.containsOnlyWhitespaces else {
            showEmptyTitleError = true
            return;
        }
        switch editingMode {
        case .update(let originalNote):
            notesViewModel.updateNoteWith(
                identifier: originalNote.identifier,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                content: content.trimmingCharacters(in: .whitespacesAndNewlines),
                iconName: iconName
            )
        case .creation:
            notesViewModel.createNoteWith(
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                content: content.trimmingCharacters(in: .whitespacesAndNewlines),
                iconName: iconName
            )
        }
    }

    // MARK: - View body

    var body: some View {
        NavigationStack {
            ScrollView {
                Form {
                    Button("Select icon", systemImage: iconName) {
                        haptics.impact(.light)
                        showIconPicker = true
                    }
                    .padding(.leading)
                    .padding(.top)
                    .font(.system(size: 40))
                    .labelStyle(.iconOnly)
                    .tint(.primary)
                    .sheet(isPresented: $showIconPicker) {
                        SymbolsPicker(
                            selection: $iconName,
                            title: "Select note icon",
                            autoDismiss: true
                        )
                    }

                    TextField("Untitled", text: $title)
                        .font(.title)
                        .bold()
                        .padding()
                        .focused($focusedField, equals: .title)
                        .onChange(of: title) { _, newValue in
                            showEmptyTitleError = newValue.containsOnlyWhitespaces
                        }
                        .onSubmit {
                            focusedField = .content
                        }

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
                        .focused($focusedField, equals: .content)
                }
                .formStyle(.columns)
            }
            // MARK: Toolbar
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    if case .creation = editingMode {
                        Button("Cancel", role: .cancel) {
                            dismiss()
                        }
                    }
                }

                if case .update(let originalNote) = editingMode {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("Delete", systemImage: "trash", role: .destructive) {
                            showDeleteAlert = true
                        }
                        .tint(.red)
                        .confirmationDialog(
                            "Delete note",
                            isPresented: $showDeleteAlert
                        ) {
                            Button("Delete", role: .destructive) {
                                notesViewModel.removeNoteWith(identifier: originalNote.identifier)
                                dismiss()
                            }
                        } message: {
                            Text("Want to delete note \"\(originalNote.title)\"?")
                        }
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    let text = switch editingMode {
                    case .update(_):
                        "Update"
                    case .creation:
                        "Create"
                    }
                    Button(text) {
                        saveNote()
                        haptics.vibrate(.success)
                        dismiss()
                    }
                    .disabled(isTitleEmpty || !isModifiedFromOriginalNote)
                }
            }
            // MARK: Navigation bar
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            focusedField = .title
        }
    }
}

#Preview("Creation") {
    NoteDetailsView(note: nil)
        .environment(NotesViewModel.forTests)
}

#Preview("Update") {
    let viewModel = NotesViewModel.forTests
    let note = Note(
        title: "Old title",
        content: "Old description",
        iconName: "graduationcap",
        createdAt: .now,
        updatedAt: .now
    )
    return NoteDetailsView(note: note)
        .environment(viewModel)
}
