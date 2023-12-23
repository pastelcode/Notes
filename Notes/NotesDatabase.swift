//
//  NotesDatabase.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/23/23.
//

import Foundation
import SwiftData

enum DatabaseError: Error {
    case insert
    case fetch
    case update
    case remove
}

protocol NotesDatabaseProtocol {
    func insert(note: Note) throws
    func fetchAll(sortBy: KeyPath<Note, Date>) throws -> [Note]
}

final class NotesDatabase: NotesDatabaseProtocol {
    static let shared = NotesDatabase()
    
    @MainActor var container = setupContainer()
    
    private init() { }
    
    @MainActor static func setupContainer(inMemory: Bool = false) -> ModelContainer {
        do {
            let container = try ModelContainer(for: Note.self, configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory))
            container.mainContext.autosaveEnabled = true
            return container
        } catch {
            fatalError("Error creating SwiftData ModelContainer: \(error.localizedDescription)")
        }
    }
    
    @MainActor func insert(note: Note) throws {
        container.mainContext.insert(note)
        
        do {
            try container.mainContext.save()
        } catch {
            print("Error: \(error.localizedDescription)")
            throw DatabaseError.insert
        }
    }
    
    @MainActor func fetchAll(sortBy: KeyPath<Note, Date>) throws -> [Note] {
        let fetchDescriptor = FetchDescriptor<Note>(sortBy: [SortDescriptor<Note>(sortBy)])
        
        do {
            return try container.mainContext.fetch(fetchDescriptor)
        } catch {
            print("Error: \(error.localizedDescription)")
            throw DatabaseError.fetch
        }
    }
}
