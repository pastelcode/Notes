//
//  RemoveNoteProtocol.swift
//  Notes
//
//  Created by Samuel Marroquín on 1/8/24.
//

import Foundation

protocol RemoveNoteProtocol {
    func removeNoteWith(identifier: UUID) throws
}
