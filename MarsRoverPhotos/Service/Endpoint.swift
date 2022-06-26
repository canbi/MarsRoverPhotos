//
//  Endpoint.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 22.06.2022.
//

import Foundation

struct Endpoint {
    let path: String
    var queryItems: [URLQueryItem]
    
    static let apiKey = "uQPlVSrS0oUIfSchWEDkY05YMg4ipTEau5YpXw0k"

    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.nasa.gov"
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}

// MARK: - Functions
extension Endpoint {
    static func getPhotos(rover: RoverType, sol: Int, cameraType: CameraName) -> Endpoint {
        Endpoint(
            path: "/mars-photos/api/v1/rovers/\(rover.rawValue.lowercased())/photos",
            queryItems: [
                URLQueryItem(name: "sol", value: String(sol)),
                URLQueryItem(name: "camera", value: cameraType == .all ? nil : cameraType.rawValue.lowercased()),
                URLQueryItem(name: "api_key", value: apiKey)
            ]
        )
    }
    
    static func getPhotos(rover: RoverType, earthDate: Date, cameraType: CameraName) -> Endpoint {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = formatter.string(from: earthDate)
        
        return Endpoint(
            path: "/mars-photos/api/v1/rovers/\(rover.rawValue.lowercased())/photos",
            queryItems: [
                URLQueryItem(name: "earth_date", value: formattedDate),
                URLQueryItem(name: "camera", value: cameraType == .all ? nil : cameraType.rawValue.lowercased()),
                URLQueryItem(name: "api_key", value: apiKey)
            ]
        )
    }
    
    static func getInformation(rover: RoverType) -> Endpoint {
        Endpoint(
            path: "/mars-photos/api/v1/manifests/\(rover.rawValue.lowercased())",
            queryItems: [URLQueryItem(name: "api_key", value: apiKey)]
        )
    }
}
