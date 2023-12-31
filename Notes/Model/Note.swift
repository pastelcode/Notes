//
//  Note.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import Foundation
import SwiftData

@Model final class Note {
    @Attribute(.unique) var identifier: UUID
    var title: String
    var content: String
    var iconName: String
    var createdAt: Date
    var updatedAt: Date
    
    init(title: String, content: String = "", iconName: String, createdAt: Date, updatedAt: Date) {
        self.identifier = .init()
        self.title = title
        self.content = content
        self.iconName = iconName
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
