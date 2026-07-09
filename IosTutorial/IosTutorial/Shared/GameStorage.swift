//
//  Globals.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-10.
//

import Foundation
import SwiftUI


final class GameStorage {
  @AppStorage("tapFrenzyHighScore") static var tapFrenzyHighScore: Int = 0
  @AppStorage("lightItUpHighScore") static var lightItUpHighScore: Int = 0
  @AppStorage("quizRushHighScore") static var quizRushHighScore: Int = 0
  
  static func resetAll()
  {
    tapFrenzyHighScore = 0
    lightItUpHighScore = 0
    quizRushHighScore = 0
  }
}
