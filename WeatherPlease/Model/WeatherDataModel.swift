//
//  WeatherDataModel.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 29.01.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

final class WeatherDataModel {
    
    internal var temperature: Int = 0
    internal var windSpeed: Int = 0
    internal var condition: Int = 0
    internal var locationName: String = ""
    internal var weatherImageName: String = "unknown"
    
    internal func getWeatherImage(forConditionID id: Int) -> String {
        switch id {
        case 200...232:
            return "storm"
        case 300...321:
            return "drop"
        case 500...504:
            return "rain1"
        case 512...531:
            return "rain"
        case 511, 600...622:
            return "snow"
        case 701...781:
            return "fog"
        case 800:
            return "sun"
        case 801, 951:
            return "cloudy4"
        case 802...804:
            return "clouds"
        case 900...902, 957...962:
            return "tornado"
        case 903:
            return "temperature"
        case 904:
            return "temperature1"
        case 905:
            return "windy1"
        case 906:
            return "snow1"
        case 952...956:
            return "wind"
        default:
            return "unknown"
        }
    }
    
}
