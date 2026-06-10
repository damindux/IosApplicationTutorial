//
//  GameOverView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-10.
//

import SwiftUI

struct GameOverView: View {
    @State private var playAgain: Bool = false
    
    var body: some View {
        if playAgain {
            ContentView()
        } else {
            gameOverView
        }
    }
    
    var gameOverView: some View {
        VStack {
            Text("Game Over!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(50)
                
            Text("Final Score: \(Globals.score)")
                .font(.title2)
                
            Text("High Score: \(Globals.highScore)")
                .font(.title2)
                
            Button {
                playAgain = true
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
    GameOverView()
}
