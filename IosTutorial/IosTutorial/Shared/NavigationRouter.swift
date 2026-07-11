//
//  NavigationRouter.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-11.
//

import SwiftUI

@Observable
final class NavigationRouter {
  static let shared = NavigationRouter()
  
  private var gameViewCount = 0
  
  var isInGame: Bool {
    gameViewCount > 0
  }
  
  private init() {}
  
  func enterGame()
  {
    gameViewCount += 1
  }
  
  func exitGame()
  {
    gameViewCount = max(0, gameViewCount - 1)
  }
}
