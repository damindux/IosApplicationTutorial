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
  let onMainMenu: () -> Void
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer()
      
      titleSection
        .padding(.bottom, 32)
      
      scoreSection
        .padding(.bottom, 40)
      
      VStack(spacing: 16) {
        playAgainButton
        mainMenuButton
        shareLink
      }
      
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.bg)
  }
  
  private var titleSection: some View {
    ZStack {
      Text("GAME OVER")
        .font(Font.custom("Pixelify Sans", size: 48))
        .foregroundStyle(.border)
        .offset(x: 3, y: 3)
      
      Text("GAME OVER")
        .font(Font.custom("Pixelify Sans", size: 48))
        .foregroundStyle(.text)
    }
  }
  
  private var scoreSection: some View {
    VStack(spacing: 16) {
      HStack {
        Spacer()
        VStack(spacing: 4) {
          Text("FINAL SCORE")
            .font(Font.custom("Pixelify Sans", size: 14))
            .foregroundStyle(.title.opacity(0.6))
          Text("\(score)")
            .font(Font.custom("Pixelify Sans", size: 42))
            .foregroundStyle(.on)
            .monospacedDigit()
        }
        Spacer()
      }
      .padding(20)
      .background(.sectionBg)
      .overlay(Rectangle().stroke(.on.opacity(0.4), lineWidth: 2))
      
      HStack {
        Spacer()
        VStack(spacing: 4) {
          Text("HIGH SCORE")
            .font(Font.custom("Pixelify Sans", size: 14))
            .foregroundStyle(.title.opacity(0.6))
          Text("\(highScore)")
            .font(Font.custom("Pixelify Sans", size: 42))
            .foregroundStyle(.text)
            .monospacedDigit()
        }
        Spacer()
      }
      .padding(20)
      .background(.sectionBg.opacity(0.5))
      .overlay(Rectangle().stroke(.border.opacity(0.4), lineWidth: 2))
    }
    .padding(.horizontal, 24)
  }
  
  private var playAgainButton: some View {
    Button(action: onPlayAgain) {
      HStack(spacing: 8) {
        Image(systemName: "arrow.clockwise")
          .font(.system(size: 18, weight: .bold))
        Text("Play Again")
          .font(Font.custom("Pixelify Sans", size: 20))
      }
      .foregroundStyle(.bg)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
      .background(.on)
      .overlay(Rectangle().stroke(.text, lineWidth: 2))
      .background(
        Rectangle()
          .fill(.border.opacity(0.5))
          .offset(x: 3, y: 3)
      )
    }
    .buttonStyle(PixeledButtonStyle())
    .padding(.horizontal, 24)
  }
  
  private var mainMenuButton: some View {
    Button(action: onMainMenu) {
      HStack(spacing: 8) {
        Image(systemName: "house.fill")
          .font(.system(size: 18, weight: .bold))
        Text("Main Menu")
          .font(Font.custom("Pixelify Sans", size: 20))
      }
      .foregroundStyle(.text)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 14)
      .background(.sectionBg)
      .overlay(Rectangle().stroke(.border, lineWidth: 2))
      .background(
        Rectangle()
          .fill(.border.opacity(0.5))
          .offset(x: 3, y: 3)
      )
    }
    .buttonStyle(PixeledButtonStyle())
    .padding(.horizontal, 24)
  }
  
  private var shareLink: some View {
    ShareLink(
      item: "I scored \(score) points in \(gameMode.rawValue) on PlayHub! Can you beat my score? 😊"
    ) {
      Label("Share Score", systemImage: "square.and.arrow.up")
        .font(Font.custom("Pixelify Sans", size: 18))
        .foregroundStyle(.title)
    }
    .padding(.top, 8)
  }
}

#Preview {
  GameOverView(score: 10, highScore: 100, gameMode: .TapFrenzy, onPlayAgain: {}, onMainMenu: {})
}
