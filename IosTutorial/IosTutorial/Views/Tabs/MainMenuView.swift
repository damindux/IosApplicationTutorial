//
//  MainMenuView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-13.
//

import SwiftUI

struct MainMenuView: View {
  @State private var isShowingTapFrenzy: Bool = false
  @State private var isShowingLightItUp: Bool = false
  @State private var isShowingQuizRush: Bool = false
  
  private let tapFrenzyColor = Color(hex: "#38d88e")
  private let lightItUpColor = Color(hex: "#00be91")
  private let quizRushColor = Color(hex: "#9af089")
  
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
              gameCard(
                title: "Tap Frenzy",
                subtitle: "Tap fast, score high",
                icon: "hand.tap.fill",
                color: tapFrenzyColor,
                isPresented: $isShowingTapFrenzy,
                destination: TapFrenzyView()
              )
              
              gameCard(
                title: "Light It Up",
                subtitle: "Speed & precision",
                icon: "lightbulb.fill",
                color: lightItUpColor,
                isPresented: $isShowingLightItUp,
                destination: LightItUpView()
              )
              
              gameCard(
                title: "Quiz Rush",
                subtitle: "Test your knowledge",
                icon: "brain.head.profile",
                color: quizRushColor,
                isPresented: $isShowingQuizRush,
                destination: QuizSetupView()
              )
            }
            .padding(.horizontal, 24)
          }
        }
      }
      .navigationDestination(isPresented: $isShowingTapFrenzy) {
        TapFrenzyView()
      }
      .navigationDestination(isPresented: $isShowingLightItUp) {
        LightItUpView()
      }
      .navigationDestination(isPresented: $isShowingQuizRush) {
        QuizSetupView()
      }
    }
  }
  
  private var titleSection: some View {
    VStack(spacing: 8) {
      ZStack {
        Text("PLAY HUB")
          .font(Font.custom("Pixelify Sans", size: 52))
          .foregroundStyle(.border)
          .offset(x: 3, y: 3)
        
        Text("PLAY HUB")
          .font(Font.custom("Pixelify Sans", size: 52))
          .foregroundStyle(.text)
      }
      
      Text("Choose your challenge")
        .font(Font.custom("Pixelify Sans", size: 18))
        .foregroundStyle(.title.opacity(0.8))
    }
  }
  
  private var pixelBackground: some View {
    GeometryReader { geo in
      let spacing: CGFloat = 60
      let rows = Int(geo.size.height / spacing) + 1
      let cols = Int(geo.size.width / spacing) + 1
      
      makePixelGrid(rows: rows, cols: cols, spacing: spacing)
    }
    .ignoresSafeArea()
  }
  
  @ViewBuilder
  private func makePixelGrid(rows: Int, cols: Int, spacing: CGFloat) -> some View
  {
    let accentColor = Color(hex: "#38d88e")
    
    VStack(spacing: spacing) {
      ForEach(0..<rows, id: \.self) { row in
        makePixelRow(row: row, cols: cols, spacing: spacing, accentColor: accentColor)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  private func makePixelRow(row: Int, cols: Int, spacing: CGFloat, accentColor: Color) -> some View
  {
    HStack(spacing: spacing) {
      ForEach(0..<cols, id: \.self) { col in
        let isVisible = (row + col) % 3 == 0
        Rectangle()
          .fill(accentColor.opacity(isVisible ? 0.08 : 0))
          .frame(width: 4, height: 4)
      }
    }
  }
  
  private func gameCard<Destination: View>(
    title: String,
    subtitle: String,
    icon: String,
    color: Color,
    isPresented: Binding<Bool>,
    destination: Destination
  ) -> some View
  {
    Button {
      isPresented.wrappedValue = true
    } label: {
      HStack(spacing: 20) {
        ZStack {
          Rectangle()
            .fill(color.opacity(0.3))
            .frame(width: 64, height: 64)
            .overlay(
              Rectangle()
                .stroke(color, lineWidth: 2)
            )
          
          Image(systemName: icon)
            .font(.system(size: 28, weight: .bold))
            .foregroundStyle(color)
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(Font.custom("Pixelify Sans", size: 26))
            .foregroundStyle(.text)
          
          Text(subtitle)
            .font(Font.custom("Pixelify Sans", size: 14))
            .foregroundStyle(.title.opacity(0.7))
        }
        
        Spacer()
        
        Image(systemName: "chevron.right")
          .font(.system(size: 20, weight: .bold))
          .foregroundStyle(color)
      }
      .padding(20)
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
    .buttonStyle(PixelCardButtonStyle())
  }
}

struct PixelCardButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View
  {
    configuration.label
      .offset(x: configuration.isPressed ? 2 : 0, y: configuration.isPressed ? 2 : 0)
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}

private extension Color {
  init(hex: String)
  {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let a, r, g, b: UInt64
    switch hex.count {
    case 3: // RGB (12-bit)
      (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
    case 6: // RGB (24-bit)
      (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8: // ARGB (32-bit)
      (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
      (a, r, g, b) = (1, 1, 1, 0)
    }
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: Double(a) / 255
    )
  }
}

#Preview {
  MainMenuView()
}
