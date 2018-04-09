//
//  WeatherService.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 02.04.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherService {
    
    private let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather/"
    private let APP_ID = "6f3162859065dbac6ceb0d7e8ff4fb98"
    
    var delegate: HomeViewController!
    
    func getWeather(latitude: String, longitude: String) {
        let requestParams = ["lat": latitude,
                             "lon": longitude,
                             "appid": APP_ID]
        Alamofire.request(WEATHER_URL, method: .get, parameters: requestParams).responseJSON { (response) in
            if response.result.isSuccess {
                self.delegate.rotateTimer.invalidate()
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error: \(response.result.error!)")
                self.delegate.rotateTimer.invalidate()
                self.delegate.locationLabel.text = "Connection issues"
                self.delegate.temperatureLabel.text = "--ºC"
                self.delegate.windLabel.text = "--m/s"
            }
        }
    }
    
    private func updateWeatherData(json: JSON) {
        if let temperatureResult = json["main"]["temp"].double {
            let weather = self.delegate.weatherDataModel
            weather.temperature = Int(temperatureResult - 273.15)
            weather.locationName = json["name"].stringValue
            weather.condition = json["weather"][0]["id"].intValue
            weather.description = json["weather"][0]["description"].stringValue
            weather.windSpeed = json["wind"]["speed"].intValue
            weather.weatherImageName = weather.getWeatherImage(forConditionID: weather.condition)
            self.delegate.updateUIWithWeatherData()
        } else {
            print("Weather unavailable")
            self.delegate.locationLabel.text = "Weather unavailable"
        }
    }
}
