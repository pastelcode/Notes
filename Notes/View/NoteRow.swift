//
//  NoteRow.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/22/23.
//

import SwiftUI

struct NoteRow: View {
    let note: Note
    let dateToShow: KeyPath<Note, Date>
    
    init(note: Note, dateToShow: KeyPath<Note, Date> = \.createdAt) {
        self.note = note
        self.dateToShow = dateToShow
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(note.title)
                .lineLimit(1)
                .foregroundStyle(.primary)
            if !note.content.isEmpty {
                Text(note.content)
                    .lineLimit(3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
            }
            Text(note[keyPath: dateToShow], style: .date)
                .font(.caption)
        }
    }
}

#Preview {
    let note = Note(
        title: "Título",
        content: "Esta es una nota creada por mí para visualizar en la preview de Xcode y así diseñarla de la mejor manera posible. Esta nota tiene como fin ser presentada en el Canvas.",
        createdAt: Calendar.current.date(byAdding: .day, value: -1, to: .now)!,
        updatedAt: .now
    )
    
    return List {
        NavigationLink(value: note) {
            NoteRow(note: note)
        }
    }
}
