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
    let onPlayAgain: () -> Void
    
  var body: some View {
    VStack {
      titleSection
      scoreSection
      button
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
}

#Preview {
    GameOverView(score: 10, highScore: 100, onPlayAgain: {})
}
