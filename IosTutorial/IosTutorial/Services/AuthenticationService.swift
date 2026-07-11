//
//  AuthenticationService.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-11.
//

import LocalAuthentication

enum AuthenticationError: Error {
  case failed
}

struct AuthenticationService {
  func authenticate() async throws {
    let context = LAContext()
    var error: NSError?
    
    guard context.canEvaluatePolicy(
      .deviceOwnerAuthentication,
      error: &error
    ) else {
      throw error ?? AuthenticationError.failed
    }
    
    let reason = "Authenticate to reset all game data."
    
    let success = try await context.evaluatePolicy(
      .deviceOwnerAuthentication,
      localizedReason: reason
    )
    
    guard success else {
      throw AuthenticationError.failed
    }
  }
}
