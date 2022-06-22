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
    
    func getPhotosBySol(rover: RoverType, sol: Int, cameraType: CameraName, sortingType: SortingTypes) {
        let endpoint = Endpoint.getPhotos(rover: rover, sol: sol, cameraType: cameraType)

        guard let url = endpoint.url else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        photoSubscription = NetworkingManager.download(url: url)
            .decode(type: MarsPhotos.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedPhotos) in
                guard let self = self else { return }
                self.allPhotos = self.sortAccordingToType(returnedPhotos.photos, sortType: sortingType)
                self.photoSubscription?.cancel()
            })
    }
    
    func getPhotosByEarthDate(rover: RoverType, earthDate: Date, cameraType: CameraName, sortingType: SortingTypes) {
        let endpoint = Endpoint.getPhotos(rover: rover, earthDate: earthDate, cameraType: cameraType)
        
        guard let url = endpoint.url else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        photoSubscription = NetworkingManager.download(url: url)
            .decode(type: MarsPhotos.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedPhotos) in
                guard let self = self else { return }
                self.allPhotos = self.sortAccordingToType(returnedPhotos.photos, sortType: sortingType)
                self.photoSubscription?.cancel()
            })
    }
    
    func getInformation(of rover: RoverType){
        let endpoint = Endpoint.getInformation(rover: rover)
        
        guard let url = endpoint.url else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        
        manifestSubscription = NetworkingManager.download(url: url)
            .decode(type: Manifest.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedManifest) in
                self?.manifest = returnedManifest.photoManifest
                self?.manifestSubscription?.cancel()
            })
    }
    
    func sortAccordingToType(_ willSort: [Photo], sortType: SortingTypes) -> [Photo] {
        switch sortType {
        case .ascending:
            return willSort
        case .descending:
            return willSort.sorted{ $0 > $1}
        case .random:
            return willSort.shuffled()
        }
    }
}
