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
  var dailyReminderEnabled = false
  var dailyReminderTime = Date()
  var dailyChallengeEnabled = false
  
  private let notificationCenter = UNUserNotificationCenter.current()
  private let reminderIndentifier = "dailyReminder"
  private let defaults = UserDefaults.standard
  
  private enum Keys {
    static let dailyReminderEnabled = "dailyReminderEnabled"
    static let dailyReminderTime = "dailyReminderTime"
    static let dailyChallengeEnabled = "dailyChallengeEnabled"
  }
  
  init()
  {
    loadSettings()
    requestNotificationPermission()
  }
  
  private func requestNotificationPermission()
  {
    notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
      if !granted {
        // TODO: forward to settings for notification permission
      }
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
    dailyReminderEnabled = isOn
    saveSettings()
    
    if isOn {
      scheduleDailyReminder()
    }
    else {
      cancelDailyReminder()
    }
  }
  
  func updateRemainderTime(_ date: Date)
  {
    dailyReminderTime = date
    saveSettings()
    
    if dailyReminderEnabled {
      scheduleDailyReminder()
    }
  }
  
  private func scheduleDailyReminder()
  {
    cancelDailyReminder()
    
    let content = UNMutableNotificationContent()
    content.title = "Daily Reminder"
    content.body = "Don't forget to log your progress!"
    content.sound = .default
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: dailyReminderTime)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    let request = UNNotificationRequest(identifier: reminderIndentifier, content: content, trigger: trigger)
    
    notificationCenter.add(request) { error in
      if let error = error {
        // TODO: Handle error
      }
    }
  }
  
  private func cancelDailyReminder()
  {
    notificationCenter.removePendingNotificationRequests(withIdentifiers: [reminderIndentifier])
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
    cancelDailyReminder()
    saveSettings()
  }
}
