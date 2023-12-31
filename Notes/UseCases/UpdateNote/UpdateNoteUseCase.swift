//
//  UpdateNoteUseCase.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/29/23.
//

import Foundation

struct UpdateNoteUseCase: UpdateNoteProtocol {
    let database: NotesDatabaseProtocol

    func updateNoteWith(identifier: UUID, title: String, content: String, iconName: String) throws {
        try database.updateWith(
            identifier: identifier,
            title: title,
            content: content,
            iconName: iconName
        )
    }
}
