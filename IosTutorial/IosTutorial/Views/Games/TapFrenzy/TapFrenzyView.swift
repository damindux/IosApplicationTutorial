//
//  TapFrenzyView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-06.
//

import SwiftUI
import Combine

struct TapFrenzyView: View {
  @State private var score = 0
  @State private var timeRemaining: Int = 10
  @State private var lastClick: Date? = nil
  @State private var buttonText: String = "Click"
  @State private var buttonPosition = CGPoint(x: 200, y: 300)
  @State private var multiplier = 1
  @State private var gameOver: Bool = false
  @State private var showGameOver: Bool = false
  
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
  let moveTimer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
  
  var body: some View {
    gameView
      .fullScreenCover(isPresented: $showGameOver) {
        GameOverView(
          score: score,
          highScore: GameStorage.tapFrenzyHighScore
        ) {
          resetGame()
          showGameOver = false
        }
      }
  }
  
  var gameView: some View {
    VStack(spacing: 30) {
      Text("Tap Frenzy")
        .font(Font.custom("Pixelify Sans", size: 38))
        .foregroundStyle(.text)
        .fontWeight(.bold)
      
      HStack {
        VStack {
          Text("Score")
            .font(Font.custom("Pixelify Sans", size: 28))
            .foregroundStyle(.text2)
          Text("\(score)")
            .font(Font.custom("Pixelify Sans", size: 38))
            .foregroundStyle(.text)
        }
        
        Spacer()
        
        VStack {
          Text("Timer")
            .font(Font.custom("Pixelify Sans", size: 28))
            .foregroundStyle(.text2)
          
          Text("\(timeRemaining)")
            .font(Font.custom("Pixelify Sans", size: 38))
            .foregroundStyle(.text)
            .monospacedDigit()
        }
      }.padding(20)
      
      Spacer()
      
      Button {
        if lastClick != nil, Date().timeIntervalSince(lastClick!) < 0.5 {
          multiplier += 1
          buttonText = "x\(multiplier)"
        } else {
          lastClick = Date()
          multiplier = 1
          buttonText = "Click"
        }
        
        score += multiplier
      } label: {
        Text(buttonText)
          .font(Font.custom("Pixelify Sans", size: 38))
          .foregroundStyle(.text)
          .frame(width: 200, height: 200)
          .background {
            Rectangle()
              .fill(.green)
          }
      }
      .position(buttonPosition)
      
      Spacer()
    }
    .onReceive(timer) { _ in
      if timeRemaining > 0 {
        timeRemaining -= 1
      } else {
        setHighScore()
        gameOver = true
        showGameOver = true
      }
    }
    .onReceive(moveTimer) { _ in
      withAnimation(.spring()) {
        buttonPosition = CGPoint(
          x: CGFloat.random(in: 50...250),
          y: CGFloat.random(in: 100...400)
        )
      }
    }
    .background(.bg)
    .toolbar(.hidden, for: .tabBar)
  }
  
  private func setHighScore() {
    if score > GameStorage.tapFrenzyHighScore {
      GameStorage.tapFrenzyHighScore = score
    }
  }
  
  private func resetGame() {
    score = 0
    timeRemaining = 10
    multiplier = 1
    buttonText = "Click"
    lastClick = nil
    gameOver = false
    buttonPosition = CGPoint(x: 200, y: 300)
  }
}

#Preview {
  TapFrenzyView()
}
