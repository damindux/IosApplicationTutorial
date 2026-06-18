//
//  LightItUpView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-18.
//

import SwiftUI
import Combine

struct LightItUpView: View {
  @State private var score: Int = 0
  @State private var showGameOver: Bool = false
  @State private var timeRemaining: Int = 60
  @State private var gameOver: Bool = false
  @State private var columns: Int = 3
  @State private var rows: Int = 2
  
  @State private var cards: [Card] = []
  
  private struct Card: Identifiable {
    let id: Int
    var isLit: Bool = false
  }
  
  private enum Levels: Float {
    case L1 = 1.5
    case L2 = 1.2
    case L3 = 1.0
    case L4 = 0.8
  }

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  var gridItems: [GridItem] {
    Array(repeating: GridItem(.flexible(), spacing: 8), count: columns)
  }
  
  var body: some View {
    gameView
      .fullScreenCover(isPresented: $showGameOver) {
        GameOverView(
          score: score,
          highScore: Globals.lightItUpHighScore,
        ) {
          resetGame()
          showGameOver = false
        }
      }
  }
  
  var gameView: some View {
    VStack(spacing: 20) {
      Text("Light It Up")
        .font(.largeTitle)
        .fontWeight(.bold)
      
      HStack {
        VStack {
          Text("Score")
            .font(.title)
            .fontWeight(.bold)
          
          Text("\(score)")
            .font(.title)
        }
        
        Spacer()
        
        VStack {
          Text("Timer")
            .font(.title)
            .fontWeight(.bold)
          
          Text("\(timeRemaining)")
            .font(.title)
        }
      }
      .padding(20)
      
      Spacer()
      
      LazyVGrid(columns: gridItems) {
        ForEach(cards) { card in
            Button {
              if let index = cards.firstIndex(where: { $0.id == card.id }) {
                cards[index].isLit.toggle()
              }
            } label: {
              Image(systemName: card.isLit ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .background(card.isLit ? .yellow : .gray.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .scaleEffect(card.isLit ? 1.15 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: card.isLit)
            }
        }
      }
      .padding(20)
      
      Spacer()
    }
    .onAppear {
      rebuildCards()
    }
    .onReceive(timer) { _ in
      if timeRemaining > 0 {
        timeRemaining -= 1
      } else {
        Globals.lightItUpScore = score
        setHighScore()
        gameOver = true
        showGameOver = true
      }
      
      if timeRemaining < 15 {
        rows = 3
        columns = 3
      } else if timeRemaining < 30 {
        rows = 2
        columns = 3
      } else if timeRemaining < 45 {
        rows = 2
        columns = 2
      } else {
        rows = 1
        columns = 3
      }
    }
    .background(Gradient(colors: [.white, .white, .cyan]))
  }
  
  private func setHighScore() {
    if score > Globals.lightItUpHighScore {
      Globals.lightItUpHighScore = score
    }
  }
  
  private func resetGame() {
    score = 0
  }
  
  private func rebuildCards() {
    cards = (0..<(rows * columns)).map { Card(id: $0) }
  }
}

#Preview {
  LightItUpView()
}
