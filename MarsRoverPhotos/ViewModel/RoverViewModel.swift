//
//  RoverViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Combine
import Foundation

class RoverViewModel: ObservableObject {
    let rover: RoverType
    
    // Data
    private let dataService = JSONDataService()
    @Published var roverImages: [Photo] = []
    private var cancellables = Set<AnyCancellable>()
    
    // Detail View
    @Published var selectedImage: Photo? = nil
    @Published var showDetailView: Bool = false
    
    init(rover: RoverType){
        self.rover = rover
        addSubscribers()
        dataService.getPhotosBySol(rover: rover, sol: 100)
    }
    
    func addSubscribers() {
        dataService.$allPhotos
            .sink { [weak self] (returnedPhotos) in
                self?.roverImages = returnedPhotos
            }
            .store(in: &cancellables)
    }
}
