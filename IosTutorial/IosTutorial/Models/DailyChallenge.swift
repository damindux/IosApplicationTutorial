//
//  DailyChallenge.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-17.
//

import Foundation

struct DailyChallenge: Codable {
  let id: UUID
  let date: Date
  let gameMode: GameMode
  let targetScore: Int
  let isCompleted: Bool
  let completedAt: Date?
  
  let quizCategory: QuizCategory?
  let quizDifficulty: QuizDifficulty?
  
  var description: String {
    switch gameMode {
    case .TapFrenzy:
      return "Score \(targetScore) points in Tap Frenzy"
    case .LightItUp:
      return "Score \(targetScore) points in Light It Up"
    case .QuizRush:
      let cat = quizCategory?.displayName ?? "Any"
      let diff = quizDifficulty?.displayName ?? "Any"
      return "Score \(targetScore) in \(cat) (\(diff))"
    }
  }
  
  var isForToday: Bool {
    Calendar.current.isDateInToday(date)
  }
}

enum ChallengeStatus {
  case available(DailyChallenge)
  case completed
  case disabled
  case notGenerated
}
