//
//  QuizService.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import Foundation

struct QuizService {
  private let url = URL(string: "https://opentdb.com/api.php?amount=10&type=multiple&category=0")!
  
  func fetchQuestions() async throws -> QuizModel {
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
      throw URLError(.badServerResponse)
    }
    
    return try JSONDecoder().decode(QuizModel.self, from: data)
  }
}
