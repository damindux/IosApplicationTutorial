//
//  QuizService.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import Foundation

struct QuizService {
  private let baseURL = "https://opentdb.com/api.php"
  
  private func makeURL(
    category: QuizCategory,
    difficulty: QuizDifficulty,
    amount: Int
  ) throws -> URL
  {
    var components = URLComponents(string: baseURL)
    
    components?.queryItems = [
      URLQueryItem(name: "amount", value: "\(amount)"),
      URLQueryItem(name: "category", value: "\(category.rawValue)"),
      URLQueryItem(name: "difficulty", value: difficulty.rawValue),
      URLQueryItem(name: "type", value: "multiple")
    ]
    
    guard let url = components?.url else {
      throw URLError(.badURL)
    }
    
    return url
  }
  
  private func fetchData(from url: URL) async throws -> Data
  {
    let (data, response) = try await URLSession.shared.data(from: url)
    try validate(response)
    return data
  }
  
  private func validate(_ response: URLResponse) throws
  {
    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
      throw URLError(.badServerResponse)
    }
  }
  
  private func decodeQuiz(from data: Data) throws -> QuizModel
  {
    try JSONDecoder().decode(QuizModel.self, from: data)
  }
  
  func fetchQuestions(
    category: QuizCategory,
    difficulty: QuizDifficulty,
    amount: Int
  ) async throws -> QuizModel
  {
    
    let url = try makeURL(
      category: category,
      difficulty: difficulty,
      amount: amount
    )
    
    let data = try await fetchData(from: url)
    
    return try decodeQuiz(from: data)
  }
}
