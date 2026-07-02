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
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(50)
                
            Text("Final Score: \(score)")
                .font(.title2)
                
            Text("High Score: \(highScore)")
                .font(.title2)
                
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
        .background(Gradient(colors: [.white, .white, .cyan]))
    }
}

#Preview {
    GameOverView(score: 10, highScore: 100, onPlayAgain: {})
}
