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
      ScrollView {
        VStack(spacing: 24) {
          // Custom nav title
          Text("Settings")
            .font(Font.custom("Pixelify Sans", size: 38))
            .foregroundStyle(.text)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 8)
          
          pixelSection(title: "Notifications", color: .title) {
            VStack(spacing: 0) {
              PixelDatePicker(
                title: "Daily Reminder",
                time: Binding(
                  get: { viewModel.dailyReminderTime },
                  set: { viewModel.updateReminderTime($0) }
                )
              )
              .padding()
              .disabled(!viewModel.dailyReminderEnabled)
              .opacity(viewModel.dailyReminderEnabled ? 1 : 0.5)
              
              Divider()
                .background(.border.opacity(0.5))
                .padding(.horizontal)
              
              PixelToggle(
                title: "Enable Reminder",
                isOn: Binding(
                  get: { viewModel.dailyReminderEnabled },
                  set: { viewModel.toggleDailyReminder(isOn: $0) }
                )
              )
              .padding()
            }
          }
          
          pixelSection(title: "Gameplay", color: .title) {
            PixelToggle(
              title: "Daily Challenge",
              isOn: Binding(
                get: { viewModel.dailyChallengeEnabled },
                set: { viewModel.toggleDailyChallenge(isOn: $0) }
              )
            )
            .padding()
          }
          
          pixelSection(title: "Danger Zone", color: .red) {
            Button {
              showResetConfirmation = true
            } label: {
              HStack {
                Text("Reset Game Data")
                  .font(Font.custom("Pixelify Sans", size: 18))
                Spacer()
                Image(systemName: "trash")
                  .font(.system(size: 16))
              }
              .foregroundStyle(.text)
              .padding()
            }
          }
        }
        .padding()
      }
      .background(.bg)
      .toolbar(.hidden, for: .navigationBar)
      .alert("Are you sure?", isPresented: $showResetConfirmation) {
        Button("Cancel", role: .cancel) { }
        Button("Reset", role: .destructive) {
          viewModel.resetGameData()
        }
      } message: {
        Text("This will erase all your scores and progress. This cannot be undone.")
          .font(Font.custom("Pixelify Sans", size: 16))
      }
    }
  }
  
  private func pixelSection<Content: View>(
    title: String,
    color: Color,
    @ViewBuilder content: () -> Content
  ) -> some View {
    VStack(alignment: .leading, spacing: 8) {
      Text(title)
        .font(Font.custom("Pixelify Sans", size: 20))
        .foregroundStyle(color)
        .padding(.horizontal, 4)
      
      VStack(spacing: 0) {
        content()
      }
      .background(.sectionBg)
      .overlay(
        Rectangle()
          .stroke(.border, lineWidth: 3)
      )
    }
  }
}

#Preview {
  SettingsView()
}
