//
//  StatsView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-08.
//

import SwiftUI

struct StatsView: View {
  var body: some View {
    ZStack {
      Color(.systemBackground)
        .ignoresSafeArea()
      
      VStack(spacing: 16) {
        
        Text("High Scores")
          .font(.largeTitle.bold())
          .foregroundStyle(.primary)
          .padding(.top)
        
        ScoreCard(title: "Tap Frenzy", score: GameStorage.tapFrenzyHighScore)
        
        ScoreCard(title: "Light It Up", score: GameStorage.lightItUpHighScore)
        
        ScoreCard(title: "Quiz Rush", score: GameStorage.quizRushHighScore)
        
        Spacer()
      }
      .padding()
    }
  }
}

#Preview {
    StatsView()
}
