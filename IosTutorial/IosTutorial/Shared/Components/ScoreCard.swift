//
//  ScoreCard.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-03.
//

import SwiftUI

struct ScoreCard: View {
  let title: String
  let score: Int
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(.headline)
          .foregroundStyle(.primary)
        
        Text("High Score")
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      
      Spacer()
      
      Text("\(score)")
        .font(.title.bold())
        .foregroundStyle(.primary)
    }
    .padding()
    .background(.ultraThinMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: 18)
        .stroke(.white.opacity(0.08), lineWidth: 1)
    )
    .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 5)
  }
}
