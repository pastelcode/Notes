//
//  Utils.swift
//  Notes
//
//  Created by Samuel Marroquín on 12/22/23.
//

import Foundation

extension String {
  var containsOnlyWhitespaces: Bool {
    trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
