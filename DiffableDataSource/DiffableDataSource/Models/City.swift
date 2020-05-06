//
//  City.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 jammsoft. All rights reserved.
//

import Foundation
import CoreLocation

public struct Weather: Decodable, Hashable {
    let id: Int
    let main: String
    let description: String
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

public struct Coordinates: Decodable, Hashable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}

public struct City: Decodable, Hashable {
    
    let id: Double
    let name: String
    let coordinates: Coordinates
    let wind: Wind
    let main: WeatherDetails
    let description: Set<Weather>


    enum CodingKeys: String, CodingKey {
        case id
        case name
        case main
        case coordinates = "coord"
        case wind
        case description = "weather"
        
    }
}
