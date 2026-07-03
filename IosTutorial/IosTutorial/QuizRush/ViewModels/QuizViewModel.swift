//
//  QuizViewModel.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import Foundation
import Combine

enum ViewState: Equatable {
  case loading
  case loaded
  case failed(String)
  
  static func == (lhs: ViewState, rhs: ViewState) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading),
      (.loaded, .loaded):
      return true
    case (.failed, .failed):
      // Consider all failed states equal regardless of the associated message
      return true
    default:
      return false
    }
  }
}

@MainActor
final class QuizViewModel: ObservableObject {
  @Published var questions: [Question] = []
  @Published var index = 0
  @Published var score = 0
  @Published var streak = 0
  @Published var viewState: ViewState = .loading
  @Published var isGameOverPresented = false
  
  var highScore: Int {
    GameStorage.quizRushHighScore
  }
  
  private let quizService: QuizService
  
  init(service: QuizService) {
    self.quizService = service
  }
  
  func load() async {
    viewState = .loading
    index = 0
    score = 0
    streak = 0
    
    do {
      let quiz = try await quizService.fetchQuestions()
      questions = quiz.results
      viewState = .loaded
    } catch {
      viewState = .failed(error.localizedDescription)
    }
  }
  
  func checkAnswer(_ answer: String) {
    guard index < questions.count else { return }
    
    let currentQuestion = questions[index]
    
    if answer == currentQuestion.correctAnswer {
      score += 10 + (streak * 2)
      streak += 1
    } else {
      score = max(0, score - 5)
      streak = 0
    }
    
    if index == questions.count - 1 {
      finishedGame()
    }
    else {
      index += 1
    }
  }
  
  private func finishedGame() {
    isGameOverPresented = true
    
    if score > GameStorage.quizRushHighScore {
      GameStorage.quizRushHighScore = score
    }
  }
}
