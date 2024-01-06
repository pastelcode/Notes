//
//  NoteRow.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/22/23.
//

import SwiftUI
import SwiftData

struct NoteRow: View {
  // MARK: - View properties
  let note: Note
  let dateToShow: KeyPath<Note, Date>
  
  // MARK: - View body
  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Image(systemName: note.iconName)
        .frame(width: 25)
        .padding(.trailing)
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
          .foregroundStyle(.secondary)
          .font(.caption)
      }
    }
  }
}

@MainActor private func setupPreview() -> Note {
  // The container initialized by the notes database must be created before any @Model to avoid the preview to crash
  let _ = NotesDatabase(inMemory: true)
  let note = Note(
    title: "Título",
    content: NSLocalizedString("Esta es una nota creada por mí para visualizar en la preview de Xcode y así diseñarla de la mejor manera posible. Esta nota tiene como fin ser presentada en el Canvas.", comment: ""),
    iconName: "text.quote",
    createdAt: Calendar.current.date(
      byAdding: .day,
      value: -1,
      to: .now
    )!,
    updatedAt: .now
  )
  return note
}

#Preview("Raw") {
  let note = setupPreview()
  return NoteRow(note: note, dateToShow: \.createdAt)
}

#Preview("As Navigation Link") {
  let note = setupPreview()
  return NavigationStack {
    List {
      NavigationLink(value: note) {
        NoteRow(note: note, dateToShow: \.updatedAt)
      }
    }
  }
}
