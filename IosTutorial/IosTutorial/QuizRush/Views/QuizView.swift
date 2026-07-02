//
//  QuizView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import SwiftUI

struct QuizView: View {
  @StateObject var viewModel: QuizViewModel
  
  @State private var currentIndex = 0
  @State private var score = 0
  @State private var selectedAnswer: String?
  @State private var showFeedback = false
  @State private var isCorrect = false
  @State private var showGameOver = false
  
  var body: some View {
    
  }
  
}

#Preview {
  QuizView(viewModel: QuizViewModel(service: QuizService()))
}
