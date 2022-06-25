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
    let manifest: PhotoManifest
    let roverType: RoverType
    var roverVM: RoverViewModel
    private let fileManager: LocalFileManagerImage = .instance
    private let fileManagerForFavorites: LocalFileManagerImage = LocalFileManagerImage(folderName: "favorites",
                                                                                       appFolder: .documentDirectory)
    //CoreData
    var settingManager: SettingManager!
    var coreDataService: CoreDataDataService!
    var coreDataObject: CDPhotos?
    
    var imageShareName: String {
        "\(photo.rover.name.rawValue) \(photo.camera.name.rawValue) \(photo.earthDate.formatted(.dateTime.year().month().day()))"
    }
    
    @Published var clickedImage: UIImage? = nil
    @Published var showingZoomImageView: Bool = false
    @Published var showShareSheet = false
    @Published var isFavorited = false
    
    init(photo: Photo, manifest: PhotoManifest, roverVM: RoverViewModel){
        self.photo = photo
        self.manifest = manifest
        self.roverType = RoverType(rawValue: photo.rover.name.rawValue) ?? .curiosity
        self.roverVM = roverVM
    }
    
    func setup(settingManager: SettingManager, coreDataService: CoreDataDataService){
        self.settingManager = settingManager
        self.coreDataService = coreDataService
        self.coreDataObject = coreDataService.getPhoto(in: roverVM.favoritePhotos, id: photo.id)
        self.isFavorited = self.coreDataObject != nil
        
    }
    
    func zoomImage(){
        clickedImage = getImage()
        showingZoomImageView.toggle()
    }
    
    func getImage() -> UIImage? {
        fileManager.getImage(name: String(photo.id))
    }
    
    func favoriteButton(){
        if isFavorited {
            removeFavorite()
        } else {
            setFavorite()
        }
        roverVM.updateFavorites()
    }
    
    func setFavorite(){
        self.coreDataObject =  coreDataService.savePhoto(for: roverType, photo: photo)
        isFavorited.toggle()
        
        if settingManager.favoritesAlsoSaveToPhotos {
            saveToPhotos(photo: photo)
        }
        
        if settingManager.favoritesAlsoSaveForOffline {
            saveForOffline(photo: photo)
        }
    }
    
    func removeFavorite(){
        if let coreDataObject = coreDataObject {
            coreDataService.deletePhoto(photo: coreDataObject)
            isFavorited.toggle()
        }
        
        let result = fileManagerForFavorites.deleteItem(name: String(photo.id), type: fileManagerForFavorites.type)
        print("\(result) + photo deleting from directory")
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
