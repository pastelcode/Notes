//
//  NotesViewModel.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import Foundation
import Observation

@Observable final class NotesViewModel {
    let createNoteUseCase: CreateNoteUseCase
    let fetchAllNotesUseCase: FetchAllNotesUseCase
    let updateNoteUseCase: UpdateNoteUseCase
    let removeNoteUseCase: RemoveNoteUseCase

    var notes: [Note]
    var sortNotesBy: KeyPath<Note, Date>

    @MainActor static var `default`: NotesViewModel {
        let database: NotesDatabaseProtocol = .default
        return .init(
            createNoteUseCase: CreateNoteUseCase(database: database),
            fetchAllNotesUseCase: FetchAllNotesUseCase(database: database),
            updateNoteUseCase: UpdateNoteUseCase(database: database),
            removeNoteUseCase: RemoveNoteUseCase(database: database)
        )
    }

    @MainActor static var forTests: NotesViewModel {
        .init(populated: false)
    }

    @MainActor static var populated: NotesViewModel {
        .init(populated: true)
    }

    private init(
        createNoteUseCase: CreateNoteUseCase,
        fetchAllNotesUseCase: FetchAllNotesUseCase,
        updateNoteUseCase: UpdateNoteUseCase,
        removeNoteUseCase: RemoveNoteUseCase,
        notes: [Note] = []
    ) {
        self.createNoteUseCase = createNoteUseCase
        self.fetchAllNotesUseCase = fetchAllNotesUseCase
        self.updateNoteUseCase = updateNoteUseCase
        self.removeNoteUseCase = removeNoteUseCase
        self.notes = notes
        self.sortNotesBy = \.createdAt
        if notes.isEmpty {
            fetchAllNotes()
        }
    }

    @MainActor private convenience init(populated: Bool) {
        let database: NotesDatabaseProtocol = .inMemory
        let notes: [Note] = if populated {
            [.init(
                title: "Note 1",
                content: "Content test for Note 1",
                iconName: "tray",
                createdAt: .now,
                updatedAt: .now
            ),
             .init(
                title: "Note 2 without content",
                iconName: "clipboard",
                createdAt: .now,
                updatedAt: .now
             ),
             .init(
                title: "Note 3 created yesterday",
                content: "This note was created yesterday and updated today",
                iconName: "person.text.rectangle.fill",
                createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
                updatedAt: .now
             )]
        } else { [] }
        self.init(
            createNoteUseCase: CreateNoteUseCase(database: database),
            fetchAllNotesUseCase: FetchAllNotesUseCase(database: database),
            updateNoteUseCase: UpdateNoteUseCase(database: database),
            removeNoteUseCase: RemoveNoteUseCase(database: database),
            notes: notes
        )
    }

    func createNoteWith(title: String, content: String, iconName: String) {
        do {
            try createNoteUseCase.createNoteWith(title: title, content: content, iconName: iconName)
            fetchAllNotes()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func fetchAllNotes() {
        do {
            notes = try fetchAllNotesUseCase.fetchAll(sortBy: sortNotesBy)
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func updateNoteWith(identifier: UUID, title: String, content: String, iconName: String) {
        do {
            try updateNoteUseCase.updateNoteWith(
                identifier: identifier,
                title: title,
                content: content,
                iconName: iconName
            )
            // It's not necessary to fetch notes again due to SwiftData observation feature.
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func removeNoteWith(identifier: UUID) {
        do {
            try removeNoteUseCase.removeNoteWith(identifier: identifier)
            fetchAllNotes()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
