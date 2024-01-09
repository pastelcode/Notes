//
//  UpdateNoteProtocol.swift
//  Notes
//
//  Created by Samuel Marroquín on 1/8/24.
//

import Foundation

protocol UpdateNoteProtocol {
    func updateNoteWith(identifier: UUID, title: String, content: String, iconName: String) throws
}
