//
//  QuizModel.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import Foundation

struct QuizModel: Decodable {
  let responseCode: Int
  let results: [Question]
  
  enum CodingKeys: String, CodingKey {
    case responseCode = "response_code"
    case results
  }
}
