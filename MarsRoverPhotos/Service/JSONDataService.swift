//
//  PhotoDataService.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation
import Combine

class JSONDataService {
    @Published var allPhotos: [Photo] = []
    
    var photoSubscription: AnyCancellable?
    let apiKey = "uQPlVSrS0oUIfSchWEDkY05YMg4ipTEau5YpXw0k"
    
    func getPhotosBySol(rover: RoverType, sol: Int) {
        //TODO: CREATE URL WITH CUSTOM BODY
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover.rawValue.lowercased())/photos?sol=\(sol)&api_key=\(apiKey)") else { return }

        photoSubscription = NetworkingManager.download(url: url)
            .decode(type: MarsPhotos.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedPhotos) in
                self?.allPhotos = returnedPhotos.photos
                self?.photoSubscription?.cancel()
            })
    }
}
