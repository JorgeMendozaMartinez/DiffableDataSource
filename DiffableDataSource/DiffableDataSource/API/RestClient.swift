//
//  RestClient.swift
//  DiffableDataSource
//
//  Created by Jorge Mendoza Martínez on 5/6/20.
//  Copyright © 2020 jammsoft. All rights reserved.
//

import Foundation
import Alamofire

public typealias ResponseClosure<T: Decodable> = (T?, Error?) -> Void

class RestClient: NSObject {
    
    public init(server: URL) {
        self.server = server
        super.init()
    }
    /// The server's URL
    public let server: URL
    
    /// The server's host.
    public var host: String! { server.host }
    
    /// The sever's port.
    public var port: Int? { server.port }
    
    /// Returns true if requests/responses are encrypted over SSL.
    public var isSecure: Bool { server.scheme == "https" }
    
    public func url(path: String, query: [URLQueryItem]? = nil) -> URL {
        var components = URLComponents()
        
        components.scheme = isSecure ? "https" : "http"
        components.host = host
        components.port = port
        components.path = "/\(path.trimmingCharacters(in: CharacterSet(charactersIn: "/")))"
        components.queryItems = query
        
        return components.url!
    }
    
}

extension RestClient {
    public static let `default`: RestClient = {
        RestClient(server: URL(string: Constants.baseURLString)!)
    }()
}
