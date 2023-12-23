//
//  Note.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import Foundation

struct Note: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let createdAt: Date
    let updatedAt: Date
    
    init(title: String, description: String = "", createdAt: Date, updatedAt: Date) {
        self.id = .init()
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
