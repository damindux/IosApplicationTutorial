//
//  StatsView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-08.
//

import SwiftUI

struct StatsView: View {
  @State private var sessions: [GameSession] = []
  private let gameService = GameSessionService.shared
  
  private var chartData: [(game: String, score: Int, color: Color)] {
    [
      ("Tap", GameStorage.tapFrenzyHighScore, .on),
      ("Light", GameStorage.lightItUpHighScore, .secondaryAccent),
      ("Quiz", GameStorage.quizRushHighScore, .title)
    ]
  }
  
  private var maxScore: Int {
    max(1, chartData.map { $0.score }.max() ?? 1)
  }
  
  var body: some View {
    NavigationStack {
      ZStack {
        Color.bg.ignoresSafeArea()
        pixelBackground
        
        ScrollView {
          VStack(spacing: 0) {
            titleSection
              .padding(.top, 60)
              .padding(.bottom, 40)
            
            VStack(spacing: 20) {
              chartCard
              
              statCard(
                title: "Tap Frenzy",
                score: GameStorage.tapFrenzyHighScore,
                icon: "hand.tap.fill",
                color: .on,
                label: "Best Taps"
              )
              
              statCard(
                title: "Light It Up",
                score: GameStorage.lightItUpHighScore,
                icon: "lightbulb.fill",
                color: .secondaryAccent,
                label: "Best Time"
              )
              
              statCard(
                title: "Quiz Rush",
                score: GameStorage.quizRushHighScore,
                icon: "brain.head.profile",
                color: .title,
                label: "Best Score"
              )
              
              recentSessionsSection
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
          }
        }
      }
      .navigationTitle("")
      .toolbar(.hidden, for: .navigationBar)
      .onAppear {
        loadSessions()
      }
      .onReceive(NotificationCenter.default.publisher(for: .gameSessionAdded)) { _ in
        loadSessions()
      }
    }
  }
  
  private func loadSessions()
  {
    sessions = gameService.load()
  }
  
  private var titleSection: some View {
    VStack(spacing: 8) {
      ZStack {
        Text("STATS")
          .font(Font.custom("Pixelify Sans", size: 52))
          .foregroundStyle(.border)
          .offset(x: 3, y: 3)
        
        Text("STATS")
          .font(Font.custom("Pixelify Sans", size: 52))
          .foregroundStyle(.text)
      }
      
      Text("Your best performances")
        .font(Font.custom("Pixelify Sans", size: 18))
        .foregroundStyle(.title.opacity(0.8))
    }
  }
  
  private var chartCard: some View {
    VStack(spacing: 16) {
      HStack {
        Text("SCORE COMPARISON")
          .font(Font.custom("Pixelify Sans", size: 16))
          .foregroundStyle(.title.opacity(0.7))
        
        Spacer()
      }
      
      HStack(alignment: .bottom, spacing: 20) {
        ForEach(chartData, id: \.game) { item in
          chartBar(
            label: item.game,
            score: item.score,
            color: item.color,
            maxScore: maxScore
          )
        }
      }
      .frame(height: 160)
      .padding(.horizontal, 8)
      
      HStack(spacing: 16) {
        ForEach(chartData, id: \.game) { item in
          HStack(spacing: 6) {
            Rectangle()
              .fill(item.color)
              .frame(width: 8, height: 8)
            
            Text(item.game)
              .font(Font.custom("Pixelify Sans", size: 12))
              .foregroundStyle(.title.opacity(0.7))
          }
        }
      }
    }
    .padding(20)
    .background(.sectionBg)
    .overlay(
      Rectangle()
        .stroke(.on.opacity(0.4), lineWidth: 2)
    )
    .background(
      Rectangle()
        .fill(.border.opacity(0.5))
        .offset(x: 4, y: 4)
    )
  }
  
  private func chartBar(label: String, score: Int, color: Color, maxScore: Int) -> some View
  {
    let barHeight = score > 0 ? CGFloat(score) / CGFloat(maxScore) * 120 : 4
    
    return VStack(spacing: 8) {
      Text("\(score)")
        .font(Font.custom("Pixelify Sans", size: 14))
        .foregroundStyle(score > 0 ? color : .title.opacity(0.3))
        .monospacedDigit()
      
      ZStack(alignment: .bottom) {
        Rectangle()
          .fill(.bg.opacity(0.5))
          .frame(width: 40, height: 120)
          .overlay(
            Rectangle()
              .stroke(.border.opacity(0.3), lineWidth: 1)
          )
        
        Rectangle()
          .fill(color.opacity(0.8))
          .frame(width: 40, height: barHeight)
          .overlay(
            Rectangle()
              .stroke(color, lineWidth: 2)
          )
      }
      
      Text(label)
        .font(Font.custom("Pixelify Sans", size: 12))
        .foregroundStyle(.title.opacity(0.7))
    }
    .frame(maxWidth: .infinity)
  }
  
  private func statCard(
    title: String,
    score: Int,
    icon: String,
    color: Color,
    label: String
  ) -> some View
  {
    VStack(spacing: 0) {
      HStack(spacing: 16) {
        ZStack {
          Rectangle()
            .fill(color.opacity(0.3))
            .frame(width: 56, height: 56)
            .overlay(
              Rectangle()
                .stroke(color, lineWidth: 2)
            )
          
          Image(systemName: icon)
            .font(.system(size: 24, weight: .bold))
            .foregroundStyle(color)
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(Font.custom("Pixelify Sans", size: 24))
            .foregroundStyle(.text)
          
          Text(label)
            .font(Font.custom("Pixelify Sans", size: 14))
            .foregroundStyle(.title.opacity(0.7))
        }
        
        Spacer()
      }
      .padding(20)
      
      Divider()
        .background(.border.opacity(0.5))
        .padding(.horizontal)
      
      HStack {
        VStack(alignment: .leading, spacing: 4) {
          Text("HIGH SCORE")
            .font(Font.custom("Pixelify Sans", size: 12))
            .foregroundStyle(.title.opacity(0.6))
          
          Text("\(score)")
            .font(Font.custom("Pixelify Sans", size: 42))
            .foregroundStyle(color)
            .monospacedDigit()
        }
        
        Spacer()
        
        ZStack {
          Rectangle()
            .fill(color.opacity(0.15))
            .frame(width: 48, height: 48)
            .overlay(
              Rectangle()
                .stroke(color.opacity(0.4), lineWidth: 2)
            )
          
          Image(systemName: score > 0 ? "crown.fill" : "minus")
            .font(.system(size: 20))
            .foregroundStyle(score > 0 ? color : .title.opacity(0.3))
        }
      }
      .padding(20)
    }
    .background(.sectionBg)
    .overlay(
      Rectangle()
        .stroke(color.opacity(0.5), lineWidth: 2)
    )
    .background(
      Rectangle()
        .fill(.border.opacity(0.5))
        .offset(x: 4, y: 4)
    )
  }
  
  private var recentSessionsSection: some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack {
        Text("RECENT")
          .font(Font.custom("Pixelify Sans", size: 16))
          .foregroundStyle(.title.opacity(0.7))
        
        Spacer()
        
        Text("\(sessions.count) games")
          .font(Font.custom("Pixelify Sans", size: 12))
          .foregroundStyle(.title.opacity(0.5))
      }
      
      if sessions.isEmpty {
        HStack {
          Spacer()
          VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
              .font(.system(size: 32))
              .foregroundStyle(.title.opacity(0.3))
            
            Text("No games yet")
              .font(Font.custom("Pixelify Sans", size: 16))
              .foregroundStyle(.title.opacity(0.5))
          }
          .padding(.vertical, 40)
          Spacer()
        }
        .background(.sectionBg.opacity(0.5))
        .overlay(
          Rectangle()
            .stroke(.border.opacity(0.3), lineWidth: 2)
        )
      }
      else {
        VStack(spacing: 8) {
          ForEach(sessions.prefix(10)) { session in
            sessionRow(session)
          }
        }
      }
    }
  }
  
  private func sessionRow(_ session: GameSession) -> some View
  {
    HStack(spacing: 12) {
      ZStack {
        Rectangle()
          .fill(sessionColor(session.mode).opacity(0.2))
          .frame(width: 40, height: 40)
          .overlay(
            Rectangle()
              .stroke(sessionColor(session.mode).opacity(0.5), lineWidth: 2)
          )
        
        Image(systemName: sessionIcon(session.mode))
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(sessionColor(session.mode))
      }
      
      VStack(alignment: .leading, spacing: 2) {
        Text(session.mode.rawValue)
          .font(Font.custom("Pixelify Sans", size: 16))
          .foregroundStyle(.text)
        
        Text(formattedDate(session.timestamp))
          .font(Font.custom("Pixelify Sans", size: 11))
          .foregroundStyle(.title.opacity(0.5))
      }
      
      Spacer()
      
      Text("\(session.score)")
        .font(Font.custom("Pixelify Sans", size: 24))
        .foregroundStyle(sessionColor(session.mode))
        .monospacedDigit()
    }
    .padding(12)
    .background(.sectionBg.opacity(0.5))
    .overlay(
      Rectangle()
        .stroke(.border.opacity(0.3), lineWidth: 1)
    )
  }
  
  private func sessionColor(_ mode: GameMode) -> Color
  {
    switch mode {
    case .TapFrenzy: return .on
    case .LightItUp: return .secondaryAccent
    case .QuizRush: return .title
    }
  }
  
  private func sessionIcon(_ mode: GameMode) -> String
  {
    switch mode {
    case .TapFrenzy: return "hand.tap.fill"
    case .LightItUp: return "lightbulb.fill"
    case .QuizRush: return "brain.head.profile"
    }
  }
  
  private func formattedDate(_ date: Date) -> String
  {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short
    return formatter.localizedString(for: date, relativeTo: Date())
  }
  
  private func summaryBox(value: Int, label: String, color: Color) -> some View
  {
    VStack(spacing: 4) {
      Text("\(value)")
        .font(Font.custom("Pixelify Sans", size: 32))
        .foregroundStyle(color)
        .monospacedDigit()
      
      Text(label)
        .font(Font.custom("Pixelify Sans", size: 12))
        .foregroundStyle(.title.opacity(0.6))
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 16)
    .background(.bg.opacity(0.5))
    .overlay(
      Rectangle()
        .stroke(color.opacity(0.3), lineWidth: 2)
    )
  }
  
  private var pixelBackground: some View {
    GeometryReader { geo in
      let spacing: CGFloat = 60
      let height = geo.size.height
      let width = geo.size.width
      
      let rows = Int(height / spacing) + 1
      let cols = Int(width / spacing) + 1
      
      PixelGridView(rows: rows, cols: cols, spacing: spacing)
    }
    .ignoresSafeArea()
  }
}

private struct PixelGridView: View {
  let rows: Int
  let cols: Int
  let spacing: CGFloat
  
  var body: some View {
    VStack(spacing: spacing) {
      ForEach(0..<rows, id: \.self) { row in
        PixelRowView(row: row, cols: cols, spacing: spacing, accentColor: .on)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

private struct PixelRowView: View {
  let row: Int
  let cols: Int
  let spacing: CGFloat
  let accentColor: Color
  
  var body: some View {
    HStack(spacing: spacing) {
      ForEach(0..<cols, id: \.self) { col in
        PixelDotView(row: row, col: col, accentColor: accentColor)
      }
    }
  }
}

private struct PixelDotView: View {
  let row: Int
  let col: Int
  let accentColor: Color
  
  private var isVisible: Bool {
    (row + col) % 3 == 0
  }
  
  var body: some View {
    Rectangle()
      .fill(accentColor.opacity(isVisible ? 0.08 : 0))
      .frame(width: 4, height: 4)
  }
}

#Preview {
  StatsView()
}
