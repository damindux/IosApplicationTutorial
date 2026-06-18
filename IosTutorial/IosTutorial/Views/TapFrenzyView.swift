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
          highScore: Globals.tapFrenzyHighScore
        ) {
          resetGame()
          showGameOver = false
        }
      }
  }
  
  var gameView: some View {
    VStack(spacing: 30) {
      Text("Tap Frenzy")
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
          .font(.largeTitle)
          .foregroundColor(.white)
          .padding(80)
          .background(.green)
          .clipShape(Circle())
      }
      .position(buttonPosition)
      .shadow(radius: 20)
      
      Spacer()
    }
    .onReceive(timer) { _ in
      if timeRemaining > 0 {
        timeRemaining -= 1
      } else {
        Globals.tapFrenzyScore = score
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
    .background(Gradient(colors: [.white, .white, .cyan]))
  }
  
  private func setHighScore() {
    if score > Globals.tapFrenzyHighScore {
      Globals.tapFrenzyHighScore = score
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
