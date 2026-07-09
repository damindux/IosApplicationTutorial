//
//  Extensions.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-03.
//

import Foundation
import SwiftUI

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

extension Button {
  func pixelButtonStyle(color: Color) -> some View {
    self.buttonStyle(PixelButtonStyle(color: color))
  }
}

private struct TabBarHiddenKey: EnvironmentKey {
    static let defaultValue: Binding<Bool> = .constant(false)
}

extension EnvironmentValues {
    var tabBarHidden: Binding<Bool> {
        get { self[TabBarHiddenKey.self] }
        set { self[TabBarHiddenKey.self] = newValue }
    }
}
