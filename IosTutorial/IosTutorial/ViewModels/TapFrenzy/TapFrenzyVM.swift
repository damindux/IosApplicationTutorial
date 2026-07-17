//
//  TapFrenzyVM.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-09.
//

import SwiftUI
import Combine

@Observable
class TapFrenzyVM {
  private let sessionService: GameSessionService
  
  var score = 0
  var timeRemaining = 10
  var buttonText = "Click"
  var buttonPosition = CGPoint(x: 200, y: 300)
  var multiplier = 1
  var gameOver = false
  var showGameOver = false
  
  let gameMode = GameMode.TapFrenzy
  
  private var lastClick: Date?
  private var timerCancellable: AnyCancellable?
  private var moveTimerCancellable: AnyCancellable?

  var highScore: Int {
      GameStorage.tapFrenzyHighScore
  }
  
  init(sessionService: GameSessionService = .shared)
  {
    self.sessionService = sessionService
  }
  
  deinit { stopTimers() }
  
  func startGame()
  {
    guard timerCancellable == nil else { return }
    startTimers()
  }
  
  func stopGame()
  {
    stopTimers()
  }
  
  func handleTap()
  {
    guard !gameOver else { return }
    
    if let last = lastClick, Date().timeIntervalSince(last) < 0.5 {
      multiplier += 1
      buttonText = "x\(multiplier)"
    } else {
      lastClick = Date()
      multiplier = 1
      buttonText = "Click"
    }
    
    score += multiplier
  }
  
  func resetGame()
  {
    stopTimers()
    score = 0
    timeRemaining = 10
    multiplier = 1
    buttonText = "Click"
    lastClick = nil
    gameOver = false
    buttonPosition = CGPoint(x: 200, y: 300)
    showGameOver = false
  }
  
  private func startTimers()
  {
    timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.tick()
      }
    
    moveTimerCancellable = Timer.publish(every: 2, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        self?.moveButton()
      }
  }
  
  private func stopTimers()
  {
    timerCancellable?.cancel()
    moveTimerCancellable?.cancel()
    timerCancellable = nil
    moveTimerCancellable = nil
  }
  
  private func tick()
  {
    guard timeRemaining > 0 else {
      endGame()
      return
    }
    
    timeRemaining -= 1
  }
  
  private func moveButton()
  {
    guard !gameOver else { return }
    
    withAnimation(.spring()) {
      buttonPosition = CGPoint(
        x: CGFloat.random(in: 50...250),
        y: CGFloat.random(in: 100...400)
      )
    }
  }
  
  private func endGame()
  {
    gameOver = true
    stopTimers()
    setHighScore()
    saveSession()
    
    DailyChallengeService.shared.markCompleted(score: score, for: .TapFrenzy)
    
    showGameOver = true
  }
  
  private func setHighScore()
  {
    if score > GameStorage.tapFrenzyHighScore {
      GameStorage.tapFrenzyHighScore = score
    }
  }
  
  private func saveSession()
  {
    let session = GameSession(
      id: UUID(),
      mode: gameMode,
      score: score,
      timestamp: Date(),
      latitude: 0,
      longitude: 0
    )
    sessionService.add(session)
  }
}
