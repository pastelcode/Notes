//
//  ContentView.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/21/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NotesView()
    }
}

#Preview {
    ContentView()
        .environment(NotesViewModel.forTests)
}
