//
//  SettingsVM.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-09.
//

import SwiftUI
import UserNotifications

@Observable
class SettingsVM {
  private let notificationService: NotificationServiceProtocol
  private let defaults = UserDefaults.standard
  
  var dailyReminderEnabled = false
  var dailyReminderTime = Date()
  var dailyChallengeEnabled = false
  var notificationPermissionStatus: UNAuthorizationStatus = .notDetermined
  
  private enum Keys {
    static let dailyReminderEnabled = "dailyReminderEnabled"
    static let dailyReminderTime = "dailyReminderTime"
    static let dailyChallengeEnabled = "dailyChallengeEnabled"
  }
  
  init(notificationService: NotificationServiceProtocol = NotificationService.shared)
  {
    self.notificationService = notificationService
    loadSettings()
    checkPermissionStatus()
  }
  
  private func checkPermissionStatus()
  {
    Task {
      notificationPermissionStatus = await notificationService.checkAuthorizationStatus()
    }
  }
  
  private func loadSettings()
  {
    dailyReminderEnabled = defaults.bool(forKey: Keys.dailyReminderEnabled)
    dailyChallengeEnabled = defaults.bool(forKey: Keys.dailyChallengeEnabled)
    
    if let timeData = defaults.object(forKey: Keys.dailyReminderTime) as? Date {
      dailyReminderTime = timeData
    }
  }
  
  private func saveSettings()
  {
    defaults.set(dailyReminderEnabled, forKey: Keys.dailyReminderEnabled)
    defaults.set(dailyChallengeEnabled, forKey: Keys.dailyChallengeEnabled)
    defaults.set(dailyReminderTime, forKey: Keys.dailyReminderTime)
  }
  
  func toggleDailyReminder(isOn: Bool)
  {
    guard isOn else {
      dailyReminderEnabled = false
      notificationService.cancelDailyReminder()
      saveSettings()
      return
    }
    
    Task {
      do {
        let granted = try await notificationService.requestAuthorization()
        
        await MainActor.run {
          if granted {
            dailyReminderEnabled = true
            scheduleReminder()
          }
          else {
            dailyReminderEnabled = false
          }
          
          saveSettings()
        }
      }
      catch {
        await MainActor.run {
          dailyReminderEnabled = false
          saveSettings()
        }
      }
    }
  }
  
  func updateReminderTime(_ date: Date)
  {
    dailyReminderTime = date
    saveSettings()
    
    if dailyReminderEnabled {
      scheduleReminder()
    }
  }
  
  private func scheduleReminder()
  {
    Task {
      do {
        try await notificationService.scheduleDailyReminder(at: dailyReminderTime)
      }
      catch {
        print("Failed to schedule timer: \(error)")
      }
    }
  }
  
  func toggleDailyChallenge(isOn: Bool)
  {
    dailyChallengeEnabled = isOn
    saveSettings()
  }
  
  func resetGameData()
  {
    GameStorage.resetAll()
    dailyReminderEnabled = false
    dailyChallengeEnabled = false
    
    notificationService.cancelDailyReminder()
    saveSettings()
  }
}
