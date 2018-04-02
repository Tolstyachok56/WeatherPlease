//
//  Persistent.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 23.03.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

protocol Persistent {
    var ud: UserDefaults {get}
    var persistentKey: String {get}
    func persist()
    func unpersist()
}
