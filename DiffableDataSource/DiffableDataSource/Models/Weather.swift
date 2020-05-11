//
//  Weather.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/11/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import Foundation

public struct Weather: Decodable, Hashable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

public struct WeatherDetails: Decodable, Hashable {
    let temp: Double
    let feelsLike: Double
    let tempMax: Double
    let tempMin: Double
    let pressure: Double
    let humidity: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
}

public struct Wind: Decodable, Hashable {
    let speed: Double
    let degree: Int
    
     enum CodingKeys: String, CodingKey {
        case speed
        case degree = "deg"
    }
}
