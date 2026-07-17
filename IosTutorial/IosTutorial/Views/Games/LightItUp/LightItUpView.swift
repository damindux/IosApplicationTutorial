//
//  LightItUpView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-18.
//

import SwiftUI

struct LightItUpView: View {
  @State private var viewModel = LightItUpVM()
  @Environment(\.dismiss) private var dismiss
  
  private var gridItems: [GridItem] {
    Array(repeating: GridItem(.flexible(), spacing: 8), count: viewModel.level.columnCount)
  }
  
  var body: some View {
    gameView
      .ignoresSafeArea(.container, edges: .bottom)
      .onAppear {
        NavigationRouter.shared.enterGame()
        viewModel.startGame()
      }
      .onDisappear {
        NavigationRouter.shared.exitGame()
        viewModel.stopGame()
      }
      .fullScreenCover(isPresented: $viewModel.showGameOver) {
        GameOverView(
          score: viewModel.score,
          highScore: GameStorage.lightItUpHighScore,
          gameMode: .LightItUp,
          onPlayAgain: {
            viewModel.resetGame()
            viewModel.startGame()
          },
          onMainMenu: {
            dismiss()
          }
        )
      }
  }
  
  private var gameView: some View {
    ZStack {
      Color.bg.ignoresSafeArea()
      
      VStack(spacing: 20) {
        headerView
        Spacer()
        cardGridView
        Spacer()
      }
    }
  }
  
  private var headerView: some View {
    HStack {
      scoreView
      Spacer()
      livesView
      Spacer()
      timerView
    }
    .padding(20)
  }
  
  private var scoreView: some View {
    VStack {
      Text("Score")
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(.title)
        .fontWeight(.bold)
      Text("\(viewModel.score)")
        .font(Font.custom("Pixelify Sans", size: 38))
        .foregroundStyle(.text)
    }
  }
  
  private var livesView: some View {
    HStack {
      ForEach(0..<3, id: \.self) { index in
        Image(index < viewModel.lives ? "HeartFill" : "Heart")
          .renderingMode(.template)
          .foregroundColor(.text)
      }
    }
  }
  
  private var timerView: some View {
    VStack {
      Text("Timer")
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(.title)
        .fontWeight(.bold)
      Text("\(viewModel.timeRemaining)")
        .font(Font.custom("Pixelify Sans", size: 38))
        .foregroundStyle(.text)
    }
  }
  
  private var cardGridView: some View {
    LazyVGrid(columns: gridItems) {
      ForEach(viewModel.cards) { card in
        CardButton(
          card: card,
          glowColor: viewModel.level.glowColor,
          action: { viewModel.cardTapped(card) }
        )
      }
    }
    .padding(20)
  }
}

private struct CardButton: View {
  let card: Card
  let glowColor: Color
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Image(card.isLit ? "HeartFill" : "Heart")
        .resizable()
        .scaledToFit()
        .foregroundColor(.border)
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(card.isLit ? glowColor: .sectionBg.opacity(0.5))
        .clipShape(Rectangle())
        .scaleEffect(card.isLit ? 1.15 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: card.isLit)
    }
  }
}

#Preview {
  LightItUpView()
}
