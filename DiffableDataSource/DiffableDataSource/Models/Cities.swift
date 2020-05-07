//
//  Cities.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 Jammsoft. All rights reserved.
//

import Foundation
import Alamofire
import CoreLocation

public struct Cities: Decodable, Hashable {
    let count: Int
    let list: [City]
    
    enum CodingKeys: String, CodingKey {
      case count
      case list
    }
}

extension RestClient {
    
    func requestCities(location: CLLocationCoordinate2D, limit: Int = 25, completion: @escaping ResponseClosure<Cities>) {
        
        AF.request(url(path: "/data/2.5/find",
                       query: [URLQueryItem(name: "lat", value: "\(location.latitude)"),
                               URLQueryItem(name: "lon", value: "\(location.longitude)"),
                               URLQueryItem(name: "cnt", value: "\(limit)"),
                               URLQueryItem(name: "appid", value: Constants.openWeatherAPIKey)]),
                   method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default, headers: nil)
            .validate().responseDecodable(of: Cities.self) { (response) in
                guard let cities = response.value else {
                    completion(nil, response.error)
                    return
                }
                completion(cities,  nil)
        }
    }
    
}

