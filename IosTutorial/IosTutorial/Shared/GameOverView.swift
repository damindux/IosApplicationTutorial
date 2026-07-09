//
//  GameOverView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-10.
//

import SwiftUI

struct GameOverView: View {
  let score: Int
  let highScore: Int
  let gameMode: GameMode
  let onPlayAgain: () -> Void
  
  var body: some View {
    VStack {
      titleSection
      scoreSection
      button
      shareLink
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.bg)
  }
  
  private var titleSection: some View {
    Text("Game Over!")
      .font(Font.custom("Pixelify Sans", size: 40))
      .foregroundStyle(.text)
      .fontWeight(.bold)
      .padding(50)
  }
  
  private var scoreSection: some View {
    VStack(spacing: 8) {
      Text("Final Score: \(score)")
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(.text)
      
      Text("High Score: \(highScore)")
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(.text)
    }
  }
  
  private var button: some View {
    Button {
      onPlayAgain()
    } label: {
      Text("Play Again")
        .font(Font.custom("Pixelify Sans", size: 24))
        .foregroundStyle(.text)
        .padding(20)
        .background(.green)
        .clipShape(Rectangle())
    }
    .padding(50)
  }
  
  private var shareLink: some View {
    ShareLink(
      item: "I scored \(score) points in \(gameMode.rawValue) on PlayHub! Can you beat my score? 😊"
    ) {
      Label("Share", systemImage: "square.and.arrow.up")
        .font(Font.custom("Pixelify Sans", size: 24))
        .foregroundStyle(.text2)
        .clipShape(Rectangle())
    }
  }
}

#Preview {
  GameOverView(score: 10, highScore: 100, gameMode: .TapFrenzy, onPlayAgain: {})
}
