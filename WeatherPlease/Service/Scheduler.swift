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
    
    func registerLocalNotifications() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error != nil {
                print(String(describing: error?.localizedDescription))
            }
//            granted ? print("Notifications allowed") : print("Notifications not allowed")
        }
    }
    
    func setNotification(withDate date: Date, onWeekdays weekdays: [Int], withSound soundLabel: String, identifier: String) {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Hello, dear!"
        content.body = "It's time to check the weather"
        content.sound = UNNotificationSound(named:"\(soundLabel).mp3")
        
        if weekdays.isEmpty {
            let dateComponents = setCorrectDateComponents(date: date)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            center.add(request, withCompletionHandler: nil)
        } else {
            for weekday in weekdays {
                
                var dateComponents = DateComponents()
                let calendar = Calendar.current
                dateComponents.hour = calendar.component(.hour, from: date)
                dateComponents.minute = calendar.component(.minute, from: date)
                dateComponents.weekday = weekday
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
            }
        }
    }
    
    private func setCorrectDateComponents(date: Date) -> DateComponents {
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
            if notificationsModel.notifications[i].uuid == uuid {
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
    
    private func syncNotificationsModel()  {
        notificationsModel = WeatherNotifications()
    }
}

