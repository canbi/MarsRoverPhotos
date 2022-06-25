//
//  ImageOfflineViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

class ImageOfflineViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    var cameraName: CameraName { photo.wrappedCameraType }
    var roverType: RoverType { photo.wrappedRoverType }
    let showCameraInfo: Bool
    
    private let photo: CDPhotos
    private let fileManagerForFavorites: LocalFileManagerImage = LocalFileManagerImage(folderName: "favorites",
                                                                                       appFolder: .documentDirectory)
    
    init(photo: CDPhotos, showCameraInfo: Bool){
        self.photo = photo
        self.showCameraInfo = showCameraInfo
        self.isLoading = true
        self.loadImage()
    }
    
    private func loadImage(){
        self.image = fileManagerForFavorites.getImage(name: String(photo.wrappedId))
        self.isLoading = false
    }
}
