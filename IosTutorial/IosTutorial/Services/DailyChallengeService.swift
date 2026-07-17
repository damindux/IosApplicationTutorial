//
//  DailyChallengeService.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-17.
//

import Foundation

final class DailyChallengeService {
  static let shared = DailyChallengeService()
  
  private let defaults = UserDefaults.standard
  private let challengeKey = "dailyChallenge"
  private let lastGeneratedKey = "dailyChallengeLastDate"
  
  private init() {}
  
  var isEnabled: Bool {
    UserDefaults.standard.bool(forKey: "dailyChallengeEnabled")
  }
  
  func todaysChallenge() -> ChallengeStatus {
    guard isEnabled else { return .disabled }
    
    if let data = defaults.data(forKey: challengeKey),
       let challenge = try? JSONDecoder().decode(DailyChallenge.self, from: data) {
      
      if challenge.isForToday {
        return challenge.isCompleted ? .completed : .available(challenge)
      }
    }
    
    let newChallenge = generateChallenge()
    saveChallenge(newChallenge)
    return .available(newChallenge)
  }
  
  func markCompleted(score: Int, for mode: GameMode) -> Bool {
    guard isEnabled else { return false }
    
    if let data = defaults.data(forKey: challengeKey),
       var challenge = try? JSONDecoder().decode(DailyChallenge.self, from: data),
       challenge.isForToday,
       !challenge.isCompleted,
       challenge.gameMode == mode,
       score >= challenge.targetScore {
      
      challenge = DailyChallenge(
        id: challenge.id,
        date: challenge.date,
        gameMode: challenge.gameMode,
        targetScore: challenge.targetScore,
        isCompleted: true,
        completedAt: Date(),
        quizCategory: challenge.quizCategory,
        quizDifficulty: challenge.quizDifficulty
      )
      
      saveChallenge(challenge)
      
      NotificationCenter.default.post(name: .dailyChallengeCompleted, object: nil)
      return true
    }
    
    return false
  }
  
  func isTodaysChallenge(_ mode: GameMode) -> Bool {
    guard isEnabled else { return false }
    if case .available(let challenge) = todaysChallenge() {
      return challenge.gameMode == mode
    }
    return false
  }
  
  func todaysTarget(for mode: GameMode) -> Int? {
    if case .available(let challenge) = todaysChallenge(), challenge.gameMode == mode {
      return challenge.targetScore
    }
    return nil
  }
  
  func quizConfig() -> (category: QuizCategory, difficulty: QuizDifficulty, target: Int)? {
    guard case .available(let challenge) = todaysChallenge(),
          challenge.gameMode == .QuizRush,
          let cat = challenge.quizCategory,
          let diff = challenge.quizDifficulty else {
      return nil
    }
    return (cat, diff, challenge.targetScore)
  }
  
  private func generateChallenge() -> DailyChallenge {
    let mode = GameMode.allCases.randomElement()!
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date())
    
    switch mode {
    case .TapFrenzy:
      return DailyChallenge(
        id: UUID(),
        date: today,
        gameMode: .TapFrenzy,
        targetScore: Int.random(in: 100...200),
        isCompleted: false,
        completedAt: nil,
        quizCategory: nil,
        quizDifficulty: nil
      )
      
    case .LightItUp:
      return DailyChallenge(
        id: UUID(),
        date: today,
        gameMode: .LightItUp,
        targetScore: Int.random(in: 20...50),
        isCompleted: false,
        completedAt: nil,
        quizCategory: nil,
        quizDifficulty: nil
      )
      
    case .QuizRush:
      return DailyChallenge(
        id: UUID(),
        date: today,
        gameMode: .QuizRush,
        targetScore: Int.random(in: 30...80),
        isCompleted: false,
        completedAt: nil,
        quizCategory: QuizCategory.allCases.randomElement()!,
        quizDifficulty: QuizDifficulty.allCases.randomElement()!
      )
    }
  }
  
  private func saveChallenge(_ challenge: DailyChallenge) {
    if let data = try? JSONEncoder().encode(challenge) {
      defaults.set(data, forKey: challengeKey)
    }
  }
}

extension Notification.Name {
  static let dailyChallengeCompleted = Notification.Name("dailyChallengeCompleted")
}
