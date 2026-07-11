//
//  QuizModel.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import Foundation

struct QuizModel: Codable {
  let results: [Question]
}

struct Question: Codable {
  let question: String
  let correctAnswer: String
  let incorrectAnswers: [String]
  
  enum CodingKeys: String, CodingKey {
    case question
    case correctAnswer = "correct_answer"
    case incorrectAnswers = "incorrect_answers"
  }
  
  var answers: [String] {
    incorrectAnswers + [correctAnswer]
  }
}

enum QuizCategory: Int, CaseIterable {
  case general = 9
  case books = 10
  case film = 11
  case music = 12
  case videoGames = 15
  case science = 17
  case computers = 18
  case math = 19
  case mythology = 20
  case sports = 21
  case geography = 22
  case history = 23
  case animals = 27
  
  var displayName: String {
    switch self {
    case .general: return "General"
    case .books: return "Books"
    case .film: return "Film"
    case .music: return "Music"
    case .videoGames: return "Games"
    case .science: return "Science"
    case .computers: return "Tech"
    case .math: return "Math"
    case .mythology: return "Myth"
    case .sports: return "Sports"
    case .geography: return "Geo"
    case .history: return "History"
    case .animals: return "Animals"
    }
  }
}

enum QuizDifficulty: String, CaseIterable {
  case easy = "easy"
  case medium = "medium"
  case hard = "hard"
  
  var displayName: String {
    rawValue.capitalized
  }
}
