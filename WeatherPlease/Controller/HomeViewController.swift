//
//  ViewController.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 29.01.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import UIKit
import CoreLocation

final class HomeViewController: UIViewController {
    
    //MARK: - Variables
    private let locationManager = CLLocationManager()
    private var weatherService = WeatherService()
    let weatherDataModel = WeatherDataModel()

    // weather ui
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    // refresh button
    @IBOutlet weak var refreshButton: UIButton!
    var rotateTimer = Timer()
    private var rotateDegree = CGFloat.pi/3
    
    //MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherService.delegate = self
        setLocationManager()
        
    }
    
    //MARK: - Update UI
    
    func updateUIWithWeatherData() {
        locationLabel.text = weatherDataModel.locationName
        descriptionLabel.text = weatherDataModel.description
        weatherImage.image = UIImage(named: weatherDataModel.weatherImageName)
        temperatureLabel.text = "\(weatherDataModel.temperature) ºC"
        windLabel.text = "\(weatherDataModel.windSpeed) m/s"
    }
    
    func updateUIDefault() {
        descriptionLabel.text = ""
        temperatureLabel.text = "--ºC"
        windLabel.text = "--m/s"
    }
    
    // MARK: - Refresh
    
    @IBAction func refresh(_ sender: UIButton) {
        rotateTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(rotateRefreshButton), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
    }
    
    @objc func rotateRefreshButton() {
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
            weatherService.getWeather(latitude: String(location.coordinate.latitude),
                                      longitude: String(location.coordinate.longitude))
        }
    }
    
    internal func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationLabel.text = "Location unavailable"
        updateUIDefault()
    }
    
}

