//
//  ImageDataService.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import Foundation
import SwiftUI
import Combine

class ImageDataService {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    
    private let photo: Photo
    private let fileManager: LocalFileManagerImage = .instance
    private let imageName: String
    
    init(photo: Photo) {
        self.photo = photo
        self.imageName = String(photo.id)
        getImage()
    }
    
    private func getImage() {
        if let savedImage = fileManager.getImage(name: imageName) {
            image = savedImage
        } else {
            downloadImage()
        }
    }
    
    private func downloadImage() {
        guard let url = URL(string: photo.imgSrc) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = downloadedImage
                self.imageSubscription?.cancel()
                let result = self.fileManager.saveImage(image: downloadedImage, name: self.imageName)
                print(result)
            })
    }
}


