//
//  ViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 29.01.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - Variables
    let WEATHER_URL = "api.openweathermap.org/data/2.5/weather"
    let APP_ID = "6f3162859065dbac6ceb0d7e8ff4fb98"
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestAlwaysAuthorization()
    }
    
}

//extension HomeViewController: CLLocationManagerDelegate {
//
//}

