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
  var score = 0
  var timeRemaining = 10
  var buttonText = "Click"
  var buttonPosition = CGPoint(x: 200, y: 300)
  var multiplier = 1
  var gameOver = false
  var showGameOver = false
  
  let gameMode = GameMode.TapFrenzy
  
  private var lastClick: Date?
  
  var highScore: Int {
      GameStorage.tapFrenzyHighScore
  }
  
  private var timerCancellable: AnyCancellable?
  private var moveTimerCancellable: AnyCancellable?
  
  var isActive: Bool {
    timeRemaining > 0 && !gameOver
  }
  
  init() { startTimers() }
  deinit { stopTimers() }
  
  func handleTap() {
    guard isActive else { return }
    
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
    score = 0
    timeRemaining = 10
    multiplier = 1
    buttonText = "Click"
    lastClick = nil
    gameOver = false
    buttonPosition = CGPoint(x: 200, y: 300)
    showGameOver = false
    startTimers()
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
  }
  
  private func tick()
  {
    guard isActive else { return }
    
    timeRemaining -= 1
    if timeRemaining <= 0 {
      endGame()
    }
  }
  
  private func moveButton()
  {
    guard isActive else { return }
    
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
    showGameOver = true
  }
  
  private func setHighScore()
  {
    if score > GameStorage.tapFrenzyHighScore {
      GameStorage.tapFrenzyHighScore = score
    }
  }
}
