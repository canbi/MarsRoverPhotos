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
    let photo: Photo?
    let cdPhoto: CDPhotos?
    let manifest: PhotoManifest?
    let roverType: RoverType
    var roverVM: RoverViewModel
    var imageShareName: String { getImageShareName() }
    
    // Utility
    private let fileManager: LocalFileManagerImage = .instance
    private let fileManagerForFavorites: LocalFileManagerImage = LocalFileManagerImage(folderName: "favorites",
                                                                                       appFolder: .documentDirectory)
    //CoreData
    var settingManager: SettingManager!
    var coreDataService: CoreDataDataService!
    var coreDataObject: CDPhotos?

    // Control
    @Published var clickedImage: UIImage? = nil
    @Published var showingZoomImageView: Bool = false
    @Published var showShareSheet = false
    @Published var isFavorited = false
    
    init(photo: Photo?, cdPhoto: CDPhotos?, manifest: PhotoManifest?, roverVM: RoverViewModel){
        self.photo = photo
        self.cdPhoto = cdPhoto
        self.manifest = manifest
        
        if let photo = photo {
            self.roverType = RoverType(rawValue: photo.rover.name.rawValue) ?? .curiosity
        } else {
            self.roverType = cdPhoto?.wrappedRoverType ?? .curiosity
        }
        
        self.roverVM = roverVM
    }
}

// MARK: - Setup Functions
extension DetailViewModel {
    func setup(settingManager: SettingManager, coreDataService: CoreDataDataService){
        self.settingManager = settingManager
        self.coreDataService = coreDataService
        
        if let photo = photo {
            self.coreDataObject = coreDataService.getPhoto(in: roverVM.favoritePhotos, id: photo.id)
        } else {
            self.coreDataObject = cdPhoto
        }
        
        self.isFavorited = self.coreDataObject != nil
        
    }
    
    private func getImageShareName() -> String {
        if let photo = photo {
            return "\(photo.rover.name.rawValue) \(photo.camera.name.rawValue) \(photo.earthDate.formatted(.dateTime.year().month().day()))"
        } else {
            return "\(cdPhoto!.wrappedRoverType.rawValue) \(cdPhoto!.wrappedCameraType.rawValue)"
        }
    }
}

// MARK: - Photo Functions
extension DetailViewModel {
    func zoomImage(){
        clickedImage = getImage()
        showingZoomImageView.toggle()
    }
    
    func getImage() -> UIImage? {
        if let photo = photo {
            return fileManager.getImage(name: String(photo.id))
        } else {
            return fileManagerForFavorites.getImage(name: String(cdPhoto!.wrappedId))
        }
    }
    
    func favoriteButton(dismissAction: @escaping () -> Void){
        if isFavorited {
            removeFavorite(dismissAction: dismissAction)
        } else {
            setFavorite()
        }
        roverVM.updateFavorites()
    }
    
    func setFavorite(){
        if let photo = photo {
            self.coreDataObject =  coreDataService.savePhoto(for: roverType, photo: photo)
            isFavorited.toggle()
            
            saveForOffline(photo: photo)
            
            if settingManager.favoritesAlsoSaveToPhotos {
                saveToPhotos(photo: photo)
            }
        }
    }
    
    func removeFavorite(dismissAction: @escaping () -> Void){
        if let photo = photo {
            if let coreDataObject = coreDataObject {
                coreDataService.deletePhoto(photo: coreDataObject)
                isFavorited.toggle()
            }
            
            let result = fileManagerForFavorites.deleteItem(name: String(photo.id), type: fileManagerForFavorites.type)
            print("\(result) + photo deleting from directory")
        } else {
            coreDataService.deletePhoto(photo: coreDataObject!)
            isFavorited.toggle()
            dismissAction()
        }
    }
    
    func saveToPhotos(photo: Photo){
        let uiimage = getImage()
        if let uiimage = uiimage {
            ImageSaver().writeToPhotoAlbum(image: uiimage)
            print("saved to Photos")
        }
    }
    
    func saveForOffline(photo: Photo){
        let uiimage = getImage()
        if let uiimage = uiimage {
            let result = fileManagerForFavorites.saveImage(image: uiimage, name: String(photo.id), compressionQuality: 0.8)
            print("\(result) + manual photo saving")
        }
    }
}
