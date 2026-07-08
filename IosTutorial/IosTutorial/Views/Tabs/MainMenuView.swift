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
  @State private var isShowingHighScores: Bool = false

  var body: some View {
    
    NavigationStack {
      ZStack {
        Color.bg.ignoresSafeArea()
        
        VStack(spacing: 20) {
          Spacer()
          
          Text("Play Hub")
            .font(Font.custom("Pixelify Sans", size: 48))
            .foregroundStyle(.text)
          
          Button("Tap Frenzy") {
            isShowingTapFrenzy = true
          }
          .font(Font.custom("Pixelify Sans", size: 28))
          .foregroundStyle(.text)
          .frame(width: 250, height: 80)
          .background(.blue)
          .clipShape(Rectangle())
          .navigationDestination(isPresented: $isShowingTapFrenzy) {
            TapFrenzyView()
          }
          
          Button("Light It Up") {
            isShowingLightItUp = true
          }
          .font(Font.custom("Pixelify Sans", size: 28))
          .foregroundStyle(.text)
          .frame(width: 250, height: 80)
          .background(.blue)
          .clipShape(Rectangle())
          .navigationDestination(isPresented: $isShowingLightItUp) {
            LightItUpView()
          }
          
          Button("Quiz Rush") {
            isShowingQuizRush = true
          }
          .font(Font.custom("Pixelify Sans", size: 28))
          .foregroundStyle(.text)
          .frame(width: 250, height: 80)
          .background(.blue)
          .clipShape(Rectangle())
          .navigationDestination(isPresented: $isShowingQuizRush) {
            QuizView()
          }

          Spacer()
        }
      }
    }
  }
}

#Preview {
  MainMenuView()
}
