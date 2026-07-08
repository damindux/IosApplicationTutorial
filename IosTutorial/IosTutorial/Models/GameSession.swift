//
//  GameSession.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-08.
//

import Foundation

enum GameMode: Codable {
  case TapFrenzy
  case LightItUp
  case QuizRush
}

struct GameSession: Identifiable, Codable {
  let id: UUID
  let mode: GameMode
  let score: Int
  let timestamp: Date
  let latitude: Double
  let longitude: Double
  
  init(id: UUID = UUID(), mode: GameMode, score: Int, timestamp: Date = Date(), latitude: Double = 0, longitude: Double = 0) {
    self.id = id
    self.mode = mode
    self.score = score
    self.timestamp = timestamp
    self.latitude = latitude
    self.longitude = longitude
  }
}
