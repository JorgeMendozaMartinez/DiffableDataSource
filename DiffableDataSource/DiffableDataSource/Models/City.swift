//
//  City.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 jammsoft. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

public struct City: Decodable, Hashable {
    
    let id: Int
    let name: String
    let coordinates: Coordinates
    let wind: Wind
    let main: WeatherDetails
    let weather: Set<Weather>


    enum CodingKeys: String, CodingKey {
        case id
        case name
        case main
        case coordinates = "coord"
        case wind
        case weather
    }
}

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



extension RestClient {
    
    func requestCityForecasts(_ city: City, completion: @escaping ResponseClosure<DailyForcast>) {
        AF.request(url(path: "/data/2.5/forecast",
                       query: [URLQueryItem(name: "id", value: "\(city.id)"),
                               URLQueryItem(name: "appid", value: Constants.openWeatherAPIKey)]),
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default, headers: nil)
            .validate().responseDecodable(of: DailyForcast.self) { (response) in
                guard let dailyForcast = response.value else {
                    completion(nil, response.error)
                    return
                }
                completion(dailyForcast,  nil)
        }
    }
    
}
