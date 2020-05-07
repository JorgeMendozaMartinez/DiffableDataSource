//
//  Forecast.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import Foundation

public struct Forecast: Decodable, Hashable {
    let date: String
    let wind: Wind
    let main: WeatherDetails
    let weather: Set<Weather>
    
    enum CodingKeys: String, CodingKey {
        case date = "dt_txt"
        case wind
        case main
        case weather
    }
}

public struct DailyForcast: Decodable, Hashable {
    let count: Int
    let forcastList: [Forecast]
    
    enum CodingKeys: String, CodingKey {
      case count = "cnt"
      case forcastList = "list"
    }
}

extension Forecast {
    
    func kelvinToCelsius(_ kelvin: Double) -> Double {
        return Double(kelvin - 273.15).rounded()
    }
    
    func kelvinToCelsiusDegreeString(_ kelvin: Double) -> String {
        let celsius = Double(kelvin - 273.15).rounded()
        return String (format: "%.0fº", celsius)
    }
    
    func kelvinToCelsiusString(_ kelvin: Double) -> String {
        let celsius = Double(kelvin - 273.15).rounded()
        return String (format: "%.0f", celsius)
    }
    
    func hectoPascaltoATMString(_ hpa: Double) -> String {
        let atm = Double(hpa * 0.00098692326671601)
        return String(format: "%1.f", atm)
    }
}
