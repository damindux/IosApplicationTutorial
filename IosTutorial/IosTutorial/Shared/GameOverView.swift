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
            Text("Game Over!")
              .font(Font.custom("Pixelify Sans", size: 40))
              .foregroundStyle(.text)
              .fontWeight(.bold)
              .padding(50)
                
            Text("Final Score: \(score)")
              .font(Font.custom("Pixelify Sans", size: 28))
              .foregroundStyle(.text)
                
            Text("High Score: \(highScore)")
              .font(Font.custom("Pixelify Sans", size: 28))
              .foregroundStyle(.text)
                
            Button {
                onPlayAgain()
            } label: {
                Text("Play Again")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding(20)
                    .background(.green)
                    .clipShape(Capsule())
            }
            .padding(50)
            .shadow(radius: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.bg)
    }
}

#Preview {
    GameOverView(score: 10, highScore: 100, onPlayAgain: {})
}
