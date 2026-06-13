//
//  MainMenuView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-13.
//

import SwiftUI

struct MainMenuView: View {
    var body: some View {
        VStack {
            Text("Tap Frenzy")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
            
            VStack(spacing: 30) {
                NavigationLink(destination: ContentView()) {
                    MainMenuButton(text: "Play", color: .green)
                }
                MainMenuButton(text: "LeaderBoard", color: .blue)
                MainMenuButton(text: "Quit", color: .red)
            }
            
            Spacer()
            
        }.padding(20)
    }
}

#Preview {
    MainMenuView()
}
