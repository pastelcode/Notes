//
//  FetchAllNotesProtocol.swift
//  Notes
//
//  Created by Samuel Marroquín on 1/8/24.
//

import Foundation

protocol FetchAllNotesProtocol {
    func fetchAll(sortBy: KeyPath<Note, Date>) throws -> [Note]
}
