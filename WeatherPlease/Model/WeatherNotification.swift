//
//  WeatherNotification.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 05.02.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//
import Foundation

struct WeatherNotification {
    var time: Date = Date()
    var isEnable: Bool = false
    var repeatWeekdays: [Int] = []
    var vibration: Bool = true
    var soundLabel: String = ""
    
}
