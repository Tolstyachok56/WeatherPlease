//
//  PropertyReflectable.swift
//  WeatherPlease
//
//  Created by Виктория Бадисова on 23.03.2018.
//  Copyright © 2018 Виктория Бадисова. All rights reserved.
//

import Foundation

protocol PropertyReflectable {
    typealias RepresentationType = [String:Any]
    typealias ValueType = [Any]
    typealias NamesType = [String]
    var propertyDictRepresentation: RepresentationType {get}
    var propertyValues: ValueType {get}
    var propertyNames: NamesType {get}
    static var propertyCount: Int {get}
    
    init(_ dict: RepresentationType)
}

extension PropertyReflectable {
    
    var propertyDictRepresentation: RepresentationType {
        var ret: [String:Any] = [:]
        for case let (key, value) in Mirror(reflecting: self).children {
            guard let k = key else { continue }
            ret.updateValue(value, forKey: k)
        }
        return ret
    }
    
    var propertyValues: ValueType {
        return Array(propertyDictRepresentation.values)
    }
    
    var propertyNames: NamesType {
        return Array(propertyDictRepresentation.keys)
    }
    
}
