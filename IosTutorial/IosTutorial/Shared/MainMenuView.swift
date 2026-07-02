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

  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        Spacer()
        
        Text("Games")
          .font(.largeTitle)
          .fontWeight(.bold)
        
        Button("Tap Frenzy") {
          isShowingTapFrenzy = true
        }
        .font(.title)
        .fontWeight(.bold)
        .foregroundStyle(.white)
        .frame(width: 220, height: 80)
        .background(.blue)
        .clipShape(Capsule())
        .navigationDestination(isPresented: $isShowingTapFrenzy) {
          TapFrenzyView()
        }
        
        Button("Light It Up") {
          isShowingLightItUp = true
        }
        .font(.title)
        .fontWeight(.bold)
        .foregroundStyle(.white)
        .frame(width: 220, height: 80)
        .background(.blue)
        .clipShape(Capsule())
        .navigationDestination(isPresented: $isShowingLightItUp) {
          LightItUpView()
        }
        
        Button("Quiz Rush") {
          isShowingQuizRush = true
        }
        .font(.title)
        .fontWeight(.bold)
        .foregroundStyle(.white)
        .frame(width: 220, height: 80)
        .background(.blue)
        .clipShape(Capsule())
        .navigationDestination(isPresented: $isShowingQuizRush) {
          QuizView()
        }

        Spacer()
      }
    }
  }
}

#Preview {
  MainMenuView()
}
