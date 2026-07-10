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
}

@Observable
final class QuizVM {
  private var sessionService: GameSessionService
  
  var questions: [Question] = []
  var index = 0
  var score = 0
  var streak = 0
  var viewState: ViewState = .loading
  var isGameOverPresented = false
  
  var shuffledAnswers: [String] = []
  
  var selectedAnswer: String? = nil
  var isCorrectAnswer: Bool? = nil
  
  let gameMode = GameMode.QuizRush
  
  var highScore: Int {
    GameStorage.quizRushHighScore
  }
  
  private let quizService: QuizService
  
  init(sessionService: GameSessionService = .shared, service: QuizService)
  {
    self.sessionService = sessionService
    self.quizService = service
  }
  
  func load() async
  {
    viewState = .loading
    index = 0
    score = 0
    streak = 0
    
    do {
      let quiz = try await quizService.fetchQuestions()
      questions = quiz.results
      
      shuffledAnswers = questions.first?.answers.shuffled() ?? []
      
      viewState = .loaded
    } catch {
      viewState = .failed(error.localizedDescription)
    }
  }
  
  func checkAnswer(_ answer: String)
  {
    guard index < questions.count else { return }
    
    let currentQuestion = questions[index]
    selectedAnswer = answer
    
    let correct = answer == currentQuestion.correctAnswer
    isCorrectAnswer = correct
    
    if correct {
      score += 10 + (streak * 2)
      streak += 1
    } else {
      score = max(0, score - 5)
      streak = 0
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      Task { @MainActor in
        self.moveToNext()
      }
    }
  }
  
  private func loadAnswers()
  {
    shuffledAnswers = questions[index].answers.shuffled()
  }
  
  private func moveToNext()
  {
    selectedAnswer = nil
    isCorrectAnswer = nil
    
    if index == questions.count - 1 {
      finishedGame()
    } else {
      index += 1
      loadAnswers()
    }
  }
  
  private func finishedGame()
  {
    isGameOverPresented = true
    saveSession()
    
    if score > GameStorage.quizRushHighScore {
      GameStorage.quizRushHighScore = score
    }
  }
  
  private func saveSession()
  {
    let session = GameSession(
      id: UUID(),
      mode: gameMode,
      score: score,
      timestamp: Date(),
      latitude: 0,
      longitude: 0
    )
    sessionService.add(session)
  }
}
