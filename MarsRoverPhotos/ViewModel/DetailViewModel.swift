//
//  DetailViewModel.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import Combine
import Foundation
import UIKit

class DetailViewModel: ObservableObject {
    let photo: Photo
    let roverType: RoverType
    private let fileManager: LocalFileManagerImage = .instance
    
    @Published var clickedImage: UIImage? = nil
    @Published var showingZoomImageView: Bool = false
    
    init(photo: Photo){
        self.photo = photo
        self.roverType = RoverType(rawValue: photo.rover.name.rawValue) ?? .curiosity
    }
    
    func getImage(){
        clickedImage = fileManager.getImage(name: String(photo.id))
        showingZoomImageView.toggle()
    }
}
