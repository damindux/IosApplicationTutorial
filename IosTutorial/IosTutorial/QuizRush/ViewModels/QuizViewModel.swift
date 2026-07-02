//
//  QuizViewModel.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import Foundation
import Combine

@MainActor
final class QuizViewModel: ObservableObject {
  @Published var questions: [Question] = []
  @Published var isLoading = false
  @Published var errorMessage: String?
  
  private let quizService: QuizService
  
  init(service: QuizService) {
    self.quizService = service
  }
  
  func fetchQuestions() async {
    isLoading = true
    errorMessage = nil
    
    defer { isLoading = false }
    
    do {
      let quiz = try await quizService.fetchQuestions()
      questions = quiz.results
    } catch {
      errorMessage = error.localizedDescription
    }
  }
}
