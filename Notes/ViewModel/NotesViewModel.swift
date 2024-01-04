//
//  NotesViewModel.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import Foundation
import Observation

@Observable final class NotesViewModel {
  @ObservationIgnored @Service private var createNoteUseCase: CreateNoteUseCase
  @ObservationIgnored @Service private var fetchAllNotesUseCase: FetchAllNotesUseCase
  @ObservationIgnored @Service private var updateNoteUseCase: UpdateNoteUseCase
  @ObservationIgnored @Service private var removeNoteUseCase: RemoveNoteUseCase

  var notes: [Note]
  var sortNotesBy: KeyPath<Note, Date> = \.createdAt

  init(notes: [Note] = []) {
    self.notes = notes
    if notes.isEmpty {
      fetchAllNotes()
    }
  }

  func createNoteWith(title: String, content: String, iconName: String) {
    do {
      try createNoteUseCase.createNoteWith(title: title, content: content, iconName: iconName)
      fetchAllNotes()
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }

  func fetchAllNotes() {
    do {
      notes = try fetchAllNotesUseCase.fetchAll(sortBy: sortNotesBy)
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }

  func updateNoteWith(identifier: UUID, title: String, content: String, iconName: String) {
    do {
      try updateNoteUseCase.updateNoteWith(
        identifier: identifier,
        title: title,
        content: content,
        iconName: iconName
      )
      // It's not necessary to fetch notes again due to SwiftData observation feature.
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }

  func removeNoteWith(identifier: UUID) {
    do {
      try removeNoteUseCase.removeNoteWith(identifier: identifier)
      fetchAllNotes()
    } catch {
      print("Error: \(error.localizedDescription)")
    }
  }
}
