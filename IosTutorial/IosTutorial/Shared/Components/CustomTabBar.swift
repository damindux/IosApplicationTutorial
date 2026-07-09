//
//  CustomTabBar.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-09.
//

import SwiftUI

enum TabItem: Int, CaseIterable {
  case home = 0
  case stats = 1
  case map = 2
  case settings = 3
  
  var title: String {
    switch self {
    case .home: return "Home"
    case .stats: return "Stats"
    case .map: return "Map"
    case .settings: return "Settings"
    }
  }
  
  var icon: String {
    switch self {
    case .home: return "house.fill"
    case .stats: return "chart.bar.fill"
    case .map: return "map.fill"
    case .settings: return "gearshape.fill"
    }
  }
}

struct CustomTabBar: View {
  @Binding var selectedTab: TabItem
  
  var body: some View {
    HStack(spacing: 0) {
      ForEach(TabItem.allCases, id: \.self) { tab in
        tabButton(for: tab)
      }
    }
    .frame(height: 84)
    .background(.bg)
    .overlay(
      Rectangle()
        .stroke(.sectionBg, lineWidth: 3)
        .frame(height: 3)
        .frame(maxHeight: .infinity, alignment: .top)
    )
  }
  
  private func tabButton(for tab: TabItem) -> some View {
    let isSelected = selectedTab == tab
    
    return Button {
      withAnimation(.easeInOut(duration: 0.15)) {
        selectedTab = tab
      }
    } label: {
      VStack(spacing: 4) {
        ZStack {
          if isSelected {
            Rectangle()
              .fill(.on.opacity(0.2))
              .frame(width: 48, height: 40)
              .overlay(
                Rectangle()
                  .stroke(.text, lineWidth: 2)
              )
          }
          
          Image(systemName: tab.icon)
            .font(.system(size: isSelected ? 22 : 20, weight: .bold))
            .foregroundStyle(isSelected ? .text : .inactive)
        }
        
        Text(tab.title)
          .font(Font.custom("Pixelify Sans", size: isSelected ? 14 : 12))
          .foregroundStyle(isSelected ? .text : .inactive)
      }
      .frame(maxWidth: .infinity)
    }
  }
}
