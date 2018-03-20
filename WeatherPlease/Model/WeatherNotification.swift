//
//  WeatherNotification.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//
import Foundation
//import CoreData

class WeatherNotification {
    
    var date: Date = Date()
    var isOn: Bool = true
    var repeatWeekdays: [Int] = []
    var vibration: Bool = true
    var soundLabel: String = "deskBell"
    
    init() {}
    
    init(date: Date, isOn: Bool, repeatWeekdays: [Int], vibration: Bool, soundLabel: String) {
        self.date = date
        self.isOn = isOn
        self.repeatWeekdays = repeatWeekdays
        self.vibration = vibration
        self.soundLabel = soundLabel
    }
}

extension WeatherNotification {
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.string(from: self.date)
    }
    
    var formattedWeekdays: String {
        var repeatWeekdays = ""
        for item in self.repeatWeekdays {
            repeatWeekdays += "\(item) "
        }
        return repeatWeekdays
    }
    
}
