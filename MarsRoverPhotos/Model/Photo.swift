//
//  Api.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation

struct MarsPhotos: Codable {
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let sol: Int
    let camera: Camera
    let imgSrc: String
    let earthDate: String
    let rover: Rover

    enum CodingKeys: String, CodingKey {
        case id, sol, camera
        case imgSrc = "img_src"
        case earthDate = "earth_date"
        case rover
    }
    
    static var previewData: Photo {
        return .init(id: 1,
                     sol: 10,
                     camera: .previewData,
                     imgSrc: "https://mars.jpl.nasa.gov/msl-raw-images/proj/msl/redops/ods/surface/sol/00125/opgs/edr/fcam/FRA_408594407EDR_F0051398FHAZ00304M_.JPG",
                     earthDate: "11-11-2011",
                     rover: .previewData)
    }
}
