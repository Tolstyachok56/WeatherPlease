//
//  WeatherNotificationModel.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//
import Foundation

struct WeatherNotification: PropertyReflectable {

    var isOn: Bool = true
    var date: Date = Date()
    var repeatWeekdays: [Int] = []
    var soundLabel: String = "deskBell"
    var vibration: Bool = true
    
    static var propertyCount: Int = 5

    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self.date)
    }
    
    init(){}
    
    init(date: Date, isOn: Bool, repeatWeekdays: [Int], vibration: Bool, soundLabel: String) {
        self.isOn = isOn
        self.date = date
        self.repeatWeekdays = repeatWeekdays
        self.soundLabel = soundLabel
        self.vibration = vibration
    }
    
    init(_ dict: RepresentationType) {
        self.isOn = dict["isOn"] as! Bool
        self.date = dict["date"] as! Date
        self.repeatWeekdays = dict["repeatWeekdays"] as! [Int]
        self.soundLabel = dict["soundLabel"] as! String
        self.vibration = dict["vibration"] as! Bool
    }
    
}

class WeatherNotifications: Persistent {
    var ud: UserDefaults = UserDefaults.standard
    var persistentKey: String = "WeatherPleaseNotifications"
    var notifications: [WeatherNotification] = [] {
        didSet {
            persist()
        }
    }
    
    var count: Int {
        return notifications.count
    }
    
    init() {
        notifications = getNotifications()
    }
    
    func getNotifications() -> [WeatherNotification] {
        let array = ud.array(forKey: persistentKey)
        guard let notificationArray = array else {
            return [WeatherNotification]()
        }
        if let dicts = notificationArray as? [PropertyReflectable.RepresentationType] {
            if dicts.first?.count == WeatherNotification.propertyCount {
                return dicts.map{WeatherNotification($0)}
            }
        }
        unpersist()
        return [WeatherNotification]()
    }
    
    func getNotificationsDictRepresentation() -> [PropertyReflectable.RepresentationType] {
        return notifications.map{$0.propertyDictRepresentation}
    }
    
    func persist() {
        ud.set(getNotificationsDictRepresentation(), forKey: persistentKey)
        ud.synchronize()
    }
    
    func unpersist() {
        for key in ud.dictionaryRepresentation().keys {
            ud.removeObject(forKey: key.description)
        }
    }
    
    
}
