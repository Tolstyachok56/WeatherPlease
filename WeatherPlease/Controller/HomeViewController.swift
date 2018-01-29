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
    private let WEATHER_URL = "api.openweathermap.org/data/2.5/weather"
    private let APP_ID = "6f3162859065dbac6ceb0d7e8ff4fb98"
    
    private let locationManager = CLLocationManager()

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
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
                
            } else {
                print("Error: \(response.result.error)")
                self.locationLabel.text = "Connection issues"
            }
        }
    }
    
}

//MARK: - CLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    
    fileprivate func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationLabel.text = "Location unavailable"
    }
    
}

