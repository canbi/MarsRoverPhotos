//
//  PhotoDataService.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation
import Combine

class JSONDataService: ObservableObject {
    static var previewInstance = JSONDataService()
    
    @Published var allPhotos: [Photo] = []
    @Published var manifest: PhotoManifest!
    
    var photoSubscription: AnyCancellable?
    var manifestSubscription: AnyCancellable?
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
    
    func getInformation(of rover: RoverType){
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/manifests/\(rover.rawValue.lowercased())?&api_key=\(apiKey)") else { return }
        
        manifestSubscription = NetworkingManager.download(url: url)
            .decode(type: Manifest.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedManifest) in
                self?.manifest = returnedManifest.photoManifest
                self?.manifestSubscription?.cancel()
            })
    }
}
