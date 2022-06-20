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
    @Published var roverImages: [Photo] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let dataService = JSONDataService()
    
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
