//
//  ImageViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Combine
import Foundation
import UIKit

class ImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let photo: Photo
    private let dataService: ImageDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo){
        self.photo = photo
        self.dataService = ImageDataService(photo: photo)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers(){
        dataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)

    }
}
