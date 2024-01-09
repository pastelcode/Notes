//
//  CreateNoteProtocol.swift
//  Notes
//
//  Created by Samuel Marroquín on 1/8/24.
//

import Foundation

protocol CreateNoteProtocol {
    func createNoteWith(title: String, content: String, iconName: String) throws
}
