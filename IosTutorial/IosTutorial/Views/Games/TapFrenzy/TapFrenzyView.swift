//
//  TapFrenzyView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-06.
//

import SwiftUI
import Combine

struct TapFrenzyView: View {
  @State private var viewModel = TapFrenzyVM()
  
  var body: some View {
    gameView
      .fullScreenCover(isPresented: $viewModel.showGameOver) {
        GameOverView(
          score: viewModel.score,
          highScore: viewModel.highScore,
          gameMode: viewModel.gameMode
        ) {
          viewModel.resetGame()
        }
      }
  }
  
  var gameView: some View {
    VStack(spacing: 30) {
      titleSection
      statsSection
      Spacer()
      tapButton
      Spacer()
    }
    .background(.bg)
    .toolbar(.hidden, for: .tabBar)
  }
  
  private var titleSection: some View {
    Text("Tap Frenzy")
      .font(Font.custom("Pixelify Sans", size: 38))
      .foregroundStyle(.text)
      .fontWeight(.bold)
  }
  
  private var statsSection: some View {
    HStack {
      statColumn(title: "Score", value: viewModel.score)
      Spacer()
      statColumn(title: "Timer", value: viewModel.timeRemaining, monospaced: true)
    }
    .padding(20)
  }
  
  private var tapButton: some View {
    Button(action: viewModel.handleTap) {
      Text(viewModel.buttonText)
        .font(Font.custom("Pixelify Sans", size: 38))
        .foregroundStyle(.text)
        .frame(width: 200, height: 200)
        .background(Rectangle().fill(.green))
    }
    .position(viewModel.buttonPosition)
  }
  
  private func statColumn(title: String, value: Int, monospaced: Bool = false) -> some View {
    VStack {
      Text(title)
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(.title)
      Text("\(value)")
        .font(Font.custom("Pixelify Sans", size: 38))
        .foregroundStyle(.text)
        .monospacedDigit(if: monospaced)
    }
  }
}

private extension View {
  @ViewBuilder
  func monospacedDigit(if condition: Bool) -> some View
  {
    if condition {
      self.monospacedDigit()
    }
    else {
      self
    }
  }
}

#Preview {
  TapFrenzyView()
}
