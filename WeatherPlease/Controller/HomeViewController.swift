//
//  ViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 29.01.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

final class HomeViewController: UIViewController {
    
    //MARK: - Variables
    
    private let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather/"
    private let APP_ID = "6f3162859065dbac6ceb0d7e8ff4fb98"
    
    private let locationManager = CLLocationManager()
    private let weatherDataModel = WeatherDataModel()
    
    // weather ui
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    // refresh button
    @IBOutlet weak var refreshButton: UIButton!
    private var rotateTimer = Timer()
    private var rotateDegree = CGFloat.pi/3
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationManager()
    }
    
    //MARK: - Networking
    
    private func getWeatherData(fromURL url: String, withParameters parameters: [String: String]) {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess {
                print("Success. Got the weather data")
                self.rotateTimer.invalidate()
                let weatherJSON: JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("Error: \(response.result.error!)")
                self.rotateTimer.invalidate()
                self.locationLabel.text = "Connection issues"
                self.temperatureLabel.text = "--ºC"
                self.windLabel.text = "--m/s"
            }
        }
    }
    
    //MARK: - JSON parsing
    
    private func updateWeatherData(json: JSON) {
        if let temperatureResult = json["main"]["temp"].double {
            weatherDataModel.temperature = Int(temperatureResult - 273.15)
            weatherDataModel.locationName = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            weatherDataModel.windSpeed = json["wind"]["speed"].intValue
            weatherDataModel.weatherImageName = weatherDataModel.getWeatherImage(forConditionID: weatherDataModel.condition)
            updateUIWithWeatherData()
        } else {
            locationLabel.text = "Weather unavailable"
        }
    }
    
    //MARK: - Update UI
    
    private func updateUIWithWeatherData() {
        locationLabel.text = weatherDataModel.locationName
        weatherImage.image = UIImage(named: weatherDataModel.weatherImageName)
        temperatureLabel.text = "\(weatherDataModel.temperature) ºC"
        windLabel.text = "\(weatherDataModel.windSpeed) m/s"
    }
    
    // MARK: - Refresh
    
    @IBAction func refresh(_ sender: UIButton) {
        rotateTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(rotateRefreshButton), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
    }
    
    @objc private func rotateRefreshButton() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.refreshButton.transform = CGAffineTransform(rotationAngle: self.rotateDegree)
        }) { (finished) in
            self.rotateDegree += CGFloat.pi/3
        }
    }
    
}


//MARK: - CLLocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate {
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        refresh(refreshButton)
    }
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            let requestParams: [String : String] = ["lat": String(location.coordinate.latitude),
                                                      "lon": String(location.coordinate.longitude),
                                                      "appid": APP_ID]
            getWeatherData(fromURL: WEATHER_URL, withParameters: requestParams)
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationLabel.text = "Location unavailable"
        temperatureLabel.text = "--ºC"
        windLabel.text = "--m/s"
    }
    
}

