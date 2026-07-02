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
  @AppStorage("lighItUpHighScore") static var lightItUpHighScore: Int = 0
  @AppStorage("quizRushHighScore") static var quizRushHighScore: Int = 0
}
