//
//  NotificationService.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-09.
//

import Foundation
import UserNotifications

protocol NotificationServiceProtocol {
  func requestAuthorization() async throws -> Bool
  func scheduleDailyReminder(at time: Date) async throws
  func cancelDailyReminder()
  func isReminderScheduled() async -> Bool
  func checkAuthorizationStatus() async -> UNAuthorizationStatus
}

final class NotificationService: NotificationServiceProtocol {
  static let shared = NotificationService()
  
  private let center = UNUserNotificationCenter.current()
  private let reminderIdentifier = "com.playhub.dailyReminder"
  
  private init() {}
  
  func requestAuthorization() async throws -> Bool
  {
    let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    return try await center.requestAuthorization(options: options)
  }
  
  func scheduleDailyReminder(at time: Date) async throws
  {
    cancelDailyReminder()
    
    let content = UNMutableNotificationContent()
    content.title = "Daily Reminder"
    content.body = "Time to play! Beat your high score!"
    content.sound = .default
    
    let calender = Calendar.current
    let components = calender.dateComponents([.hour, .minute], from: time)
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
    
    let request = UNNotificationRequest(identifier: reminderIdentifier, content: content, trigger: trigger)
    try await center.add(request)
  }
  
  func cancelDailyReminder()
  {
    center.removePendingNotificationRequests(withIdentifiers: [reminderIdentifier])
  }
  
  func isReminderScheduled() async -> Bool
  {
    let requests = await center.pendingNotificationRequests()
    return requests.contains { $0.identifier == reminderIdentifier }
  }
  
  func checkAuthorizationStatus() async -> UNAuthorizationStatus
  {
    let settings = await center.notificationSettings()
    return settings.authorizationStatus
  }
}
