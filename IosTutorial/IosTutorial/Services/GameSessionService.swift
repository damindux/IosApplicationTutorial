//
//  GameSessionService.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-08.
//

import Foundation
internal import _LocationEssentials

final class GameSessionService {
  
  static let shared = GameSessionService()
  
  func load() -> [GameSession] {
    guard
      let data = UserDefaults.standard.data(forKey: "gameSessions"),
      let sessions = try? JSONDecoder().decode([GameSession].self, from: data)
    else {
      return []
    }
    
    return sessions.sorted { $0.timestamp > $1.timestamp }
  }
  
  func add(_ session: GameSession) {
    let location = LocationService.shared.location
    
    let gameSession = GameSession(
      id: session.id,
      mode: session.mode,
      score: session.score,
      timestamp: session.timestamp,
      latitude: location?.coordinate.latitude ?? 0,
      longitude: location?.coordinate.longitude ?? 0
    )
    
    var sessions = load()
    
    sessions.append(gameSession)
    save(sessions)
    
    NotificationCenter.default.post(name: .gameSessionAdded, object: nil)
  }
  
  func save(_ sessions: [GameSession]) {
    guard let data = try? JSONEncoder().encode(sessions) else { return }
    UserDefaults.standard.set(data, forKey: "gameSessions")
  }
  
  func deleteAll() {
    UserDefaults.standard.removeObject(forKey: "gameSessions")
  }
}

extension Notification.Name {
  static let gameSessionAdded = Notification.Name("gameSessionAdded")
}
