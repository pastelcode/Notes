//
//  NotesDatabase.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/23/23.
//

import Foundation
import SwiftData

enum NotesDatabaseError: Error {
    case insert
    case fetch
    case update
    case remove
}

protocol NotesDatabaseProtocol {
    func insert(note: Note) throws
    func fetchAll(sortBy: KeyPath<Note, Date>) throws -> [Note]
    func updateWith(identifier: UUID, title: String, content: String, iconName: String) throws
    func removeWith(identifier: UUID) throws
}

extension NotesDatabaseProtocol where Self == NotesDatabase {
    @MainActor static var `default`: NotesDatabase {
        .init(inMemory: false)
    }

    @MainActor static var inMemory: NotesDatabase {
        .init(inMemory: true)
    }
}

final class NotesDatabase: NotesDatabaseProtocol {
    @MainActor private let container: ModelContainer

    @MainActor init(inMemory: Bool = false) {
        func setupContainer(inMemory: Bool) -> ModelContainer {
            do {
                let container = try ModelContainer(
                    for: Note.self,
                    configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory)
                )
                container.mainContext.autosaveEnabled = true
                return container
            } catch {
                fatalError("Failed to create model container: \(error.localizedDescription)")
            }
        }

        container = setupContainer(inMemory: inMemory)
    }

    @MainActor func insert(note: Note) throws {
        container.mainContext.insert(note)
        do {
            try container.mainContext.save()
        } catch {
            print("Failed to insert note: \(error.localizedDescription)")
            throw NotesDatabaseError.insert
        }
    }

    @MainActor func fetchAll(sortBy: KeyPath<Note, Date>) throws -> [Note] {
        let fetchDescriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor<Note>(sortBy)])
        do {
            return try container.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch all notes: \(error.localizedDescription)")
            throw NotesDatabaseError.fetch
        }
    }

    @MainActor func updateWith(
        identifier: UUID,
        title: String,
        content: String,
        iconName: String
    ) throws {
        let fetchDescriptor = FetchDescriptor<Note>(predicate: #Predicate { note in
            note.identifier == identifier
        })
        do {
            if let note = try container.mainContext.fetch(fetchDescriptor).first {
                note.title = title
                note.content = content
                note.iconName = iconName
                note.updatedAt = .now
            }
            try container.mainContext.save()
        } catch {
            print("Failed to update note: \(error.localizedDescription)")
            throw NotesDatabaseError.update
        }
    }

    @MainActor func removeWith(identifier: UUID) throws {
        do {
            try container.mainContext.delete(model: Note.self, where: #Predicate { note in
                note.identifier == identifier
            })
            try container.mainContext.save()
        } catch {
            print("Failed to remove note: \(error.localizedDescription)")
            throw NotesDatabaseError.remove
        }
    }
}
