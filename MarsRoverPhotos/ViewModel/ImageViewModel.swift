//
//  ImageViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Combine
import SwiftUI
import UIKit

class ImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    var cameraName: CameraName { photo.camera.name }
    var roverType: RoverType { photo.rover.name }
    let showCameraInfo: Bool
    
    private let photo: Photo
    private let imageDataService: ImageDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(photo: Photo, showCameraInfo: Bool){
        self.photo = photo
        self.showCameraInfo = showCameraInfo
        self.imageDataService = ImageDataService(photo: photo)
        addSubscribers()
        self.isLoading = true
    }
    
    private func addSubscribers(){
        imageDataService.$image
            .sink { [weak self] (_) in
                self?.isLoading = false
            } receiveValue: { [weak self] (returnedImage) in
                self?.image = returnedImage
            }
            .store(in: &cancellables)
    }
}
