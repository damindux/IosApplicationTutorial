//
//  LightItUpVM.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-10.
//

import SwiftUI
import Combine

@Observable
final class LightItUpVM {
  private let sessionService: GameSessionService
  
  var score = 0
  var timeRemaining = 60
  var level = Level.L1
  var lives = 3
  var cards: [Card] = []
  var showGameOver = false
  
  let gameMode = GameMode.LightItUp
  
  var isGameOver: Bool {
    lives <= 0 || timeRemaining <= 0
  }
  
  private var lightTask: Task<Void, Never>?
  private var timerCancellable: AnyCancellable?
  private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  init(sessionService: GameSessionService = .shared)
  {
    self.sessionService = sessionService
  }
  
  deinit { stopGame() }
  
  func startGame()
  {
    resetGame()
    setupTimer()
  }
  
  func stopGame()
  {
    lightTask?.cancel()
    timerCancellable?.cancel()
    timerCancellable = nil
  }
  
  func cardTapped(_ card: Card)
  {
    guard !isGameOver, let index = cards.firstIndex(where: { $0.id == card.id }) else { return }
    
    if cards[index].isLit {
      score += 1
      cards[index].isLit = false
    }
    else {
      lives -= 1
      if lives <= 0 {
        endGame()
      }
    }
  }
  
  func resetGame()
  {
    lightTask?.cancel()
    
    score = 0
    timeRemaining = 60
    lives = 3
    level = .L1
    showGameOver = false
    
    rebuildCards()
    startLightingCards()
  }
  
  private func setupTimer()
  {
    timerCancellable = timer.sink { [weak self] _ in
      guard let self = self else { return }
      Task { @MainActor [weak self] in
        await self?.tick()
      }
    }
  }
  
  private func tick() async
  {
    guard timeRemaining > 0, !isGameOver else {
      if timeRemaining <= 0 {
        endGame()
      }
      return
    }
    
    timeRemaining -= 1
    
    let newLevel = Level.level(for: timeRemaining)
    if newLevel != level {
      level = newLevel
      rebuildCards()
      startLightingCards()
    }
  }
  
  private func endGame()
  {
    setHighScore()
    saveSession()
    showGameOver = true
    lightTask?.cancel()
  }
  
  private func setHighScore()
  {
    if score > GameStorage.lightItUpHighScore {
      GameStorage.lightItUpHighScore = score
    }
  }
  
  private func rebuildCards()
  {
    cards = (0..<level.cardCount).map { Card(id: $0) }
  }
  
  private func startLightingCards()
  {
    lightTask?.cancel()
    let litTime = Double(level.litTime)
    
    lightTask = Task { [weak self] in
      while let self = self, !Task.isCancelled && !self.isGameOver {
        let availableIndices = self.cards.indices.filter { !self.cards[$0].isLit }
        guard let randomIndex = availableIndices.randomElement() else {
          try? await Task.sleep(for: .milliseconds(100))
          continue
        }
        
        self.cards[randomIndex].isLit = true
        
        Task { [weak self] in
          try? await Task.sleep(for: .milliseconds(800))
          guard let self = self, randomIndex < self.cards.count else { return }
          self.cards[randomIndex].isLit = false
        }
        
        try? await Task.sleep(for: .seconds(litTime))
      }
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

struct Card: Identifiable {
  let id: Int
  var isLit: Bool = false
}

enum Level: Float, CaseIterable {
  case L1, L2, L3, L4
  
  var cardCount: Int {
    switch self {
    case .L1: return 3
    case .L2: return 4
    case .L3: return 6
    case .L4: return 9
    }
  }
  
  var litTime: Float {
    switch self {
    case .L1: return 1.5
    case .L2: return 1.2
    case .L3: return 1.0
    case .L4: return 0.8
    }
  }
  
  var columnCount: Int {
    switch self {
    case .L1: return 3
    case .L2: return 4
    case .L3: return 3
    case .L4: return 3
    }
  }
  
  var glowColor: Color {
    switch self {
    case .L1: return .on
    case .L2: return .text
    case .L3: return .secondaryAccent
    case .L4: return .title
    }
  }
  
  static func level(for timeRemaining: Int) -> Level
  {
    switch timeRemaining {
    case 46...59: return .L1
    case 31...45: return .L2
    case 16...30: return .L3
    default: return .L4
    }
  }
}
