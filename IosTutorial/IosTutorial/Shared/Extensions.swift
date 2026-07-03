//
//  Extensions.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-03.
//

import Foundation

extension String {
  var htmlDecoded: String {
    self
      .replacingOccurrences(of: "&quot;", with: "\"")
      .replacingOccurrences(of: "&#039;", with: "'")
      .replacingOccurrences(of: "&amp;", with: "&")
      .replacingOccurrences(of: "&lt;", with: "<")
      .replacingOccurrences(of: "&gt;", with: ">")
  }
}
