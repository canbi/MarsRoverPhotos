//
//  CoreDataController.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import CoreData
import Foundation

class PersistentContainerForAppGroups : NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        guard let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.MarsRovers") else {
            fatalError("Can not get url forSecurityApplicationGroupIdentifier")
        }
        return url
    }
}



class CoreDataController: ObservableObject {
    let container = PersistentContainerForAppGroups(name: "CoreDataModel")
    
    init() {
        container.loadPersistentStores { [weak self] description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            
            self?.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
