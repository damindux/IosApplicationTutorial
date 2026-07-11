//
//  QuizView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import SwiftUI

struct QuizView: View {
  @State var viewModel = QuizVM(service: QuizService())
  
  var body: some View {
    ZStack {
      Color.bg.ignoresSafeArea()
      pixelBackground
      
      Group {
        switch viewModel.viewState {
        case .loading:
          loadingView
        case .failed(let message):
          errorView(message: message)
        case .loaded:
          gameView
        }
      }
    }
    .onAppear {
      NavigationRouter.shared.enterGame()
    }
    .onDisappear {
      NavigationRouter.shared.exitGame()
    }
    .fullScreenCover(isPresented: $viewModel.isGameOverPresented) {
      GameOverView(
        score: viewModel.score,
        highScore: viewModel.highScore,
        gameMode: .QuizRush,
        onPlayAgain: {
          Task {
            viewModel.isGameOverPresented = false
            await viewModel.load()
          }
        }
      )
    }
    .task {
      await viewModel.load()
    }
  }
  
  private var loadingView: some View {
    VStack(spacing: 24) {
      ZStack {
        Rectangle()
          .fill(.sectionBg)
          .frame(width: 80, height: 80)
          .overlay(
            Rectangle()
              .stroke(.on, lineWidth: 2)
          )
        
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .on))
          .scaleEffect(1.5)
      }
      
      Text("Loading Question...")
        .font(Font.custom("Pixelify Sans", size: 22))
        .foregroundStyle(.text)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  private func errorView(message: String) -> some View
  {
    VStack(spacing: 24) {
      ZStack {
        Rectangle()
          .fill(.sectionBg)
          .frame(width: 80, height: 80)
          .overlay(
            Rectangle()
              .stroke(.text)
          )
        
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.system(size: 36))
          .foregroundStyle(.text)
      }
      
      Text("Error")
        .font(Font.custom("Pixelify Sans", size: 16))
        .foregroundStyle(.secondaryAccent.opacity(0.8))
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
      
      Button {
        Task {
          await viewModel.load()
        }
      } label: {
        Text("Retry")
          .font(Font.custom("Pixelify Sans", size: 18))
          .foregroundStyle(.bg)
          .padding(.horizontal, 32)
          .padding(.vertical, 12)
          .background(.on)
          .overlay(
            Rectangle()
              .stroke(.text, lineWidth: 2)
          )
      }
      .buttonStyle(PixeledButtonStyle())
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  private var gameView: some View {
    VStack(spacing: 0) {
      titleSection
        .padding(.top, 20)
        .padding(.bottom, 16)
      
      statsBar
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
      
      Spacer()
      
      questionCard
        .padding(.horizontal, 24)
        .padding(.bottom, 24)
      
      answerSection
        .padding(.horizontal, 24)
      
      Spacer()
      
      progressBar
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
    }
  }
  
  private var titleSection: some View {
    ZStack {
      Text("QUIZ RUSH")
        .font(Font.custom("Pixelify Sans", size: 38))
        .foregroundStyle(.border)
        .offset(x: 2, y: 2)
      
      Text("QUIZ RUSH")
        .font(Font.custom("Pixelify Sans", size: 38))
        .foregroundStyle(.text)
    }
  }
  
  private var statsBar: some View {
    HStack(spacing: 16) {
      statBox(title: "Score", value: viewModel.score, color: .on)
      statBox(title: "Streak", value: viewModel.streak, color: .secondaryAccent)
    }
  }
  
  private func statBox(title: String, value: Int, color: Color) -> some View
  {
    VStack(spacing: 4) {
      Text(title)
        .font(Font.custom("Pixelify Sans", size: 14))
        .foregroundStyle(.title.opacity(0.7))
      
      Text("\(value)")
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(color)
        .monospacedDigit()
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 12)
    .background(.sectionBg)
    .overlay(
      Rectangle()
        .stroke(color.opacity(0.4), lineWidth: 2)
    )
  }
  
  private var questionCard: some View {
    VStack(spacing: 16) {
      HStack {
        Text("QUESTION \(viewModel.index + 1)")
          .font(Font.custom("Pixelify Sans", size: 12))
          .foregroundStyle(.title.opacity(0.6))
        
        Spacer()
      }
      
      Text(viewModel.questions[viewModel.index].question.htmlDecoded)
        .font(Font.custom("Pixelify Sans", size: 22))
        .foregroundStyle(.text)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.8)
    }
    .padding(24)
    .background(.sectionBg)
    .overlay(
      Rectangle()
        .stroke(.on.opacity(0.5), lineWidth: 2)
    )
    .background(
      Rectangle()
        .fill(.border.opacity(0.5))
        .offset(x: 3, y: 3)
    )
  }
  
  private var answerSection: some View {
    VStack(spacing: 12) {
      ForEach(viewModel.shuffledAnswers, id: \.self) { answer in
          AnswerButton(
            title: answer.description.htmlDecoded,
            isSelected: viewModel.selectedAnswer == answer,
            isCorrectAnswer: answer == viewModel.questions[viewModel.index].correctAnswer,
            hasAnswered: viewModel.selectedAnswer != nil
          ) {
            viewModel.checkAnswer(answer)
          }
      }
    }
  }
  
  private var progressBar: some View {
    VStack(spacing: 8) {
      GeometryReader { geo in
        let progress = CGFloat(viewModel.index + 1) / CGFloat(viewModel.questions.count)
        
        ZStack(alignment: .leading) {
          Rectangle()
            .fill(.sectionBg)
            .frame(height: 12)
            .overlay(
              Rectangle()
                .stroke(.on.opacity(0.5), lineWidth: 1)
            )
          
          Rectangle()
            .fill(.on)
            .frame(width: geo.size.width * progress, height: 12)
            .overlay(
              Rectangle()
                .stroke(.on.opacity(0.5), lineWidth: 1)
            )
        }
      }
      .frame(height: 12)
      
      HStack {
        Text("\(viewModel.index + 1)/\(viewModel.questions.count)")
          .font(Font.custom("Pixelify Sans", size: 12))
          .foregroundStyle(.title.opacity(0.6))
        
        Spacer()
      }
    }
  }
  
  private var pixelBackground: some View {
    GeometryReader { geo in
      let spacing: CGFloat = 60
      let height = geo.size.height
      let width = geo.size.width
      
      let rows = Int(height / spacing) + 1
      let cols = Int(width / spacing) + 1
      
      VStack(spacing: spacing) {
        ForEach(0..<rows, id: \.self) { row in
          HStack(spacing: spacing) {
            ForEach(0..<cols, id: \.self) { col in
              let isVisible = (row + col) % 3 == 0
              Rectangle()
                .fill(.on.opacity(isVisible ? 0.06 : 0))
                .frame(width: 4, height: 4)
            }
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .ignoresSafeArea()
  }
}

#Preview {
  QuizView(viewModel: QuizVM(service: QuizService()))
}
