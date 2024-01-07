//
//  DependencyInjection.swift
//  Notes
//
//  Created by Samuel Marroquín on 1/6/24.
//

import SwiftUI
import Foundation

// MARK: - Environment Keys

private struct HapticsKey: EnvironmentKey {
    static var defaultValue = Haptics()
}

// MARK: - Environment Values

extension EnvironmentValues {
    var haptics: Haptics {
        self[HapticsKey.self]
    }
}

// MARK: - View Models

extension View {
    @MainActor func withViewModels() -> some View {
        environment(NotesViewModel.default)
    }
}
