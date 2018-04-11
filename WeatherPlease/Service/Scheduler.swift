//
//  Scheduler.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 28.03.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation
import UserNotifications

final class Scheduler {
    
    //MARK: - Variables
    
    private var notificationsModel: WeatherNotifications = WeatherNotifications()
    
    //MARK: - Methods

    private func syncNotificationsModel()  {
        notificationsModel = WeatherNotifications()
    }
    
    func registerLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
        }
    }

    func setNotification(withDate date: Date, onWeekdays weekdays: [Int], withSound soundLabel: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "Hello, dear!"
        content.body = "It's time to check the weather"
        content.sound = UNNotificationSound(named:"\(soundLabel).mp3")
        
        if weekdays.isEmpty {
            let dateComponents = getCorrectDateComponents(date: date)
            addRequest(identifier: identifier, content: content, triggerDateComponents: dateComponents)
        } else {
            for weekday in weekdays {
                
                var dateComponents = DateComponents()
                let calendar = Calendar.current
                dateComponents.hour = calendar.component(.hour, from: date)
                dateComponents.minute = calendar.component(.minute, from: date)
                dateComponents.weekday = weekday
                
                addRequest(identifier: UUID().uuidString, content: content, triggerDateComponents: dateComponents)
            }
        }
    }
    
    private func addRequest(identifier: String, content: UNMutableNotificationContent, triggerDateComponents: DateComponents) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    private func getCorrectDateComponents(date: Date) -> DateComponents {
        let calendar = Calendar.current
        
        let dateHour = calendar.component(.hour, from: date)
        let dateMinute = calendar.component(.minute, from: date)
        
        let now = Date()
        let nowHour = calendar.component(.hour, from: now)
        let nowMinute = calendar.component(.minute, from: now)
        
        var dateComponents = DateComponents()
        if (dateHour < nowHour) || (dateHour == nowHour && dateMinute < nowMinute) {
            let nextDay = now.addingTimeInterval(60*60*24)
            dateComponents.year = calendar.component(.year, from: nextDay)
            dateComponents.month = calendar.component(.month, from: nextDay)
            dateComponents.day = calendar.component(.day, from: nextDay)
        } else {
            dateComponents.year = calendar.component(.year, from: now)
            dateComponents.month = calendar.component(.month, from: now)
            dateComponents.day = calendar.component(.day, from: now)
        }
        dateComponents.hour = dateHour
        dateComponents.minute = dateMinute
        
        return dateComponents
    }
    
    func reSchedule() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Removed all pending notifications")
        syncNotificationsModel()
        for notification in notificationsModel.notifications {
            if notification.isOn {
                setNotification(withDate: notification.date, onWeekdays: notification.repeatWeekdays, withSound: notification.soundLabel, identifier: notification.uuid)
                print("Set: \(notification.uuid)")
            }
        }
        print("Setted all enabled notifications")
    }
    
    func deactivate(deliveredNotification: UNNotification) {
        syncNotificationsModel()
        let uuid = deliveredNotification.request.identifier
        for i in 0...notificationsModel.count - 1 {
            let notification = notificationsModel.notifications[i]
            if notification.repeatWeekdays.isEmpty &&  notification.uuid == uuid {
                notificationsModel.notifications[i].isOn = false
            }
        }
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [uuid])
        print("Deactivated")
    }
    
    func deactivateAllDeliveredNotifications() {
        syncNotificationsModel()
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            for notification in notifications {
                print("Deactivate: \(notification.request.identifier)")
                self.deactivate(deliveredNotification: notification)
            }
            self.syncNotificationsModel()
            print(self.notificationsModel.notifications)
            print("Deactivated all delivered notifications")
        }
    }
    
}

