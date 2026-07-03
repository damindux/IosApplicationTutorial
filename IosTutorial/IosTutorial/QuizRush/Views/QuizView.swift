//
//  QuizView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-02.
//

import SwiftUI

struct QuizView: View {
  @StateObject var viewModel = QuizViewModel(service: QuizService())
  
  var body: some View {
    Group {
      switch viewModel.viewState {
        
      case .loading:
        ProgressView("Loading questions...")
          .progressViewStyle(CircularProgressViewStyle())
          .tint(.primary)
          .foregroundStyle(.primary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color(.systemBackground))

      case .failed(let message):
        VStack(spacing: 16) {
          Text("Error")
            .font(.headline)
          
          Text(message)
            .foregroundColor(.red)
          
          Button("Retry") {
            Task {
              await viewModel.load()
            }
          }
        }

      case .loaded:
        VStack(spacing: 20) {
          Text("Quiz Rush")
            .font(.largeTitle)
            .fontWeight(.bold)
          
          HStack {
            VStack {
              Text("Score")
                .font(.title)
                .fontWeight(.bold)
              
              Text("\(viewModel.score)")
                .font(.title)
            }
            
            Spacer()
            
            VStack {
              Text("Streak")
                .font(.title)
                .fontWeight(.bold)
              
              Text("\(viewModel.streak)")
                .font(.title)
            }
          }
          
          Spacer()
          
          Text(viewModel.questions[viewModel.index].question.htmlDecoded)
            .font(.title2)
            .multilineTextAlignment(.center)
          
          ForEach(viewModel.questions[viewModel.index].answers, id: \.self) { answer in
            Button {
              viewModel.checkAnswer(answer)
            } label: {
              Text(answer.description.htmlDecoded)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .frame(width: 300, height: 80)
                .background(.primary)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            }
          }
          
          Spacer()
          
          Text("Questions: \(viewModel.index + 1)/\(viewModel.questions.count)")
            .foregroundColor(.gray)
        }
        .padding(20)
      }
    }
    .fullScreenCover(isPresented: $viewModel.isGameOverPresented) {
      GameOverView(
        score: viewModel.score,
        highScore: viewModel.highScore,
        onPlayAgain: {
          Task {
            viewModel.isGameOverPresented = false
            await viewModel.load()
          }
        })
    }
    .task {
      await viewModel.load()
    }
  }
}

#Preview {
  QuizView(viewModel: QuizViewModel(service: QuizService()))
}
