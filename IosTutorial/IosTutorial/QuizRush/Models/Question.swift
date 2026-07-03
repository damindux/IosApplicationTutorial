//
//  Question.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import Foundation

struct Question: Decodable {
  let type: String
  let difficulty: String
  let category: String
  let question: String
  let correctAnswer: String
  let incorrectAnswers: [String]
  
  var answers: [String] {
    return ([correctAnswer] + incorrectAnswers).shuffled()
  }
  
  enum CodingKeys: String, CodingKey {
    case type
    case difficulty
    case category
    case question
    case correctAnswer = "correct_answer"
    case incorrectAnswers = "incorrect_answers"
  }
}
