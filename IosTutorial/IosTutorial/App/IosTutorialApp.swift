//
//  IosTutorialApp.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-06.
//

import SwiftUI

@main
struct IosTutorialApp: App {
  @State private var selectedTab: TabItem = .home
  
  var body: some Scene {
    WindowGroup {
      ZStack {
        Group {
          switch selectedTab {
          case .home:
            MainMenuView()
          case .stats:
            StatsView()
          case .map:
            MapView()
          case .settings:
            SettingsView()
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        VStack {
          Spacer()
          CustomTabBar(selectedTab: $selectedTab)
        }
        .opacity(NavigationRouter.shared.isInGame ? 0 : 1)
        .offset(y: NavigationRouter.shared.isInGame ? 100 : 0)
        .animation(.easeInOut(duration: 0.2), value: NavigationRouter.shared.isInGame)
      }
      .ignoresSafeArea(.keyboard)
      .onAppear {
        LocationService.shared.requestPermission()
      }
      .preferredColorScheme(.light)
    }
  }
}
