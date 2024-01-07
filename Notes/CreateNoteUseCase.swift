//
//  CreateNoteUseCase.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/23/23.
//

import Foundation

struct CreateNoteUseCase {
    let database: NotesDatabaseProtocol

    func createNoteWith(title: String, content: String, iconName: String) throws {
        let note = Note(
            title: title,
            content: content,
            iconName: iconName,
            createdAt: .now,
            updatedAt: .now
        )
        try database.insert(note: note)
    }
}
