//
//  HapticsViewModel.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/30/23.
//

import Foundation
import Observation
import UIKit

@Observable final class HapticsViewModel {
    func vibrate(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(type)
    }
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: style)
        feedbackGenerator.impactOccurred()
    }
}
