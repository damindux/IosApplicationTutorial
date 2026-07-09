//
//  IosTutorialApp.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-06.
//

import SwiftUI

@main
struct IosTutorialApp: App {
  @State private var selectedTab: Int = 0
  
  var body: some Scene {
    WindowGroup {
      TabView(selection: $selectedTab) {
        MainMenuView()
          .tabItem {
            Label("Home", image: "Home")
          }
          .tag(0)
        
        StatsView()
          .tabItem {
            Label("Stats", systemImage: "chart.bar")
          }
          .tag(1)
        
        MapView()
          .tabItem {
            Label("Map", systemImage: "map")
          }
          .tag(2)
        
        SettingsView()
          .tabItem {
            Label("Settings", systemImage: "gear")
          }
          .tag(3)
      }
      .onAppear {
        LocationService.shared.requestPermission()
      }
    }
  }
}
