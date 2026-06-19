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
  @State private var level: Levels = .L1
  
  @State private var cards: [Card] = []
  @State private var lightTask: Task<Void, Never>? = nil
  
  private struct Card: Identifiable {
    let id: Int
    var isLit: Bool = false
  }
  
  private enum Levels: Float {
    case L1
    case L2
    case L3
    case L4
    
    var cardCount: Int {
      switch self {
      case .L1: return 3
      case .L2: return 4
      case .L3: return 6
      case .L4: return 9
      }
    }
    
    var litTime: Float {
      switch self {
      case .L1: return 1.5
      case .L2: return 1.2
      case .L3: return 1.0
      case .L4: return 0.8
      }
    }
    
    var columnCount: Int {
      switch self {
      case .L1: return 3
      case .L2: return 2
      case .L3: return 3
      case .L4: return 3
      }
    }
    
    var glowColor: Color {
      switch self {
      case .L1: return .green
      case .L2: return .blue
      case .L3: return .yellow
      case .L4: return .red
      }
    }
  }

  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  
  var gridItems: [GridItem] {
    Array(repeating: GridItem(.flexible(), spacing: 8), count: level.columnCount)
  }
  
  var body: some View {
    gameView
      .fullScreenCover(isPresented: $showGameOver) {
        GameOverView(
          score: score,
          highScore: GameStorage.lightItUpHighScore,
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
              guard let index = cards.firstIndex(where: { $0.id == card.id }) else {
                return
              }
              
              if cards[index].isLit {
                score += 1
                cards[index].isLit = false
              }
              else {
                score = max(0, score - 1)
              }
              
            } label: {
              Image(systemName: card.isLit ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .padding(20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .background(card.isLit ? level.glowColor : .gray.opacity(0.5))
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
      startLightingCards()
    }
    .onReceive(timer) { _ in
      if timeRemaining > 0 {
        timeRemaining -= 1
        
        let newLevel: Levels
        
        switch timeRemaining {
        case 46...59: newLevel = .L1
        case 31...45: newLevel = .L2
        case 16...30: newLevel = .L3
        default: newLevel = .L4
        }
        
        if newLevel != level {
          level = newLevel
          rebuildCards()
          startLightingCards()
        }
        
      } else {
        setHighScore()
        gameOver = true
        showGameOver = true
      }
    }
    .background(Gradient(colors: [.white, .white, .cyan]))
  }
  
  private func setHighScore() {
    if score > GameStorage.lightItUpHighScore {
      GameStorage.lightItUpHighScore = score
    }
  }
  
  private func resetGame() {
    lightTask?.cancel()
    
    score = 0
    timeRemaining = 60
    gameOver = false
    level = .L1
    
    rebuildCards()
    startLightingCards()
  }
  
  private func rebuildCards() {
    cards = (0..<level.cardCount).map { Card(id: $0) }
  }
  
  private func startLightingCards() {
    lightTask?.cancel()
    
    lightTask = Task {
      while !Task.isCancelled && !gameOver {
        let availableIndices = cards.indices.filter {
          !cards[$0].isLit
        }
        
        guard let randomIndex = availableIndices.randomElement() else {
          try? await Task.sleep(for: .milliseconds(100))
          continue
        }
        
        await MainActor.run {
          cards[randomIndex].isLit = true
        }
        
        Task {
          try? await Task.sleep(for: .milliseconds(800))
          
          await MainActor.run {
            guard randomIndex < cards.count else { return }
            cards[randomIndex].isLit = false
          }
        }
        
        try? await Task.sleep(for: .seconds(Double(level.litTime)))
      }
    }
  }
}

#Preview {
  LightItUpView()
}
