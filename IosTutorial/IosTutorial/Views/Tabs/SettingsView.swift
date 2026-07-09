//
//  SettingsView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-08.
//

import SwiftUI

struct SettingsView: View {
  @State private var viewModel = SettingsVM()
  @State private var showResetConfirmation = false
  
  var body: some View {
    NavigationStack {
      Form {
        reminderSection
        challengeSection
        dangerZoneSection
      }
      .navigationTitle("Settings")
      .navigationBarTitleDisplayMode(.large)
      .background(.bg)
      .alert("Are you sure?", isPresented: $showResetConfirmation) {
        Button("Cancel", role: .cancel) { }
        Button("Reset", role: .destructive) {
          viewModel.resetGameData()
        }
      } message: {
        Text("This will erase all your scores and progress. This cannot be undone.")
      }
    }
  }
  
  private var reminderSection: some View {
    Section {
      DatePicker(
        "Daily Reminder",
        selection: Binding(
          get: { viewModel.dailyReminderTime },
          set: { viewModel.updateRemainderTime($0) }
        ),
        displayedComponents: .hourAndMinute
      )
      .disabled(!viewModel.dailyReminderEnabled)
      
      Toggle(
        "Enable Remainder",
        isOn: Binding(
          get: { viewModel.dailyReminderEnabled },
          set: { viewModel.toggleDailyReminder(isOn: $0) }
        )
      )
    } header: {
      Text("Notifications")
        .font(Font.custom("Pixelify Sans", size: 20))
    }
  }
  
  private var challengeSection: some View {
    Section {
      Toggle(
        "Daily Challenge",
        isOn: Binding(
          get: { viewModel.dailyChallengeEnabled },
          set: { viewModel.toggleDailyChallenge(isOn: $0) }
        )
      )
    } header: {
      Text("Gameplay")
        .font(Font.custom("Pixelify Sans", size: 20))
    }
  }
  
  private var dangerZoneSection: some View {
    Section {
      Button("Reset Game Data") {
        showResetConfirmation.toggle()
      }
      .foregroundStyle(.red)
      .font(Font.custom("Pixelify Sans", size: 20))
    } header: {
      Text("Danger Zone")
        .font(Font.custom("Pixelify Sans", size: 20))
        .foregroundStyle(.red)
    }
  }
}

#Preview {
  SettingsView()
}
