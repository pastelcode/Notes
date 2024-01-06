//
//  EmptyNotesListView.swift
//  Notes
//
//  Created by Samuel Marroquín on 1/5/24.
//

import SwiftUI

struct EmptyNotesListView: View {
    @Binding var showCreateNoteView: Bool
    @State private var isCreateNoteIconAnimated = false
    @State private var isTrayIconShown = false
    
    var body: some View {
        ContentUnavailableView {
            if isTrayIconShown {
                Label("No notes", systemImage: "tray")
                    .transition(.symbolEffect(.appear.up.byLayer))
            }
        } description: {
            Text("New notes you create will appear here.")
        } actions: {
            Button("Create note", systemImage: "square.and.pencil") {
                showCreateNoteView = true
            }
            .symbolEffect(
                .bounce.up.byLayer,
                options: .repeating.speed(0.1),
                value: isCreateNoteIconAnimated
            )
        }
        .onAppear {
            isCreateNoteIconAnimated = true
            isTrayIconShown = true
        }
    }
}

#Preview {
    EmptyNotesListView(showCreateNoteView: .constant(false))
}
