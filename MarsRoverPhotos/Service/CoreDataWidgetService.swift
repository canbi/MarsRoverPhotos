//
//  CoreDataWidgetService.swift
//  MarsWidgetExtension
//
//  Created by Can Bi on 22.07.2022.
//

import SwiftUI
import CoreData

class CoreDataWidgetService: ObservableObject {
    var moc: NSManagedObjectContext
    var favorites: [CDPhotos]
    
    init(moc: NSManagedObjectContext) {
        self.moc = moc
        
        let fetchRequest: NSFetchRequest<CDPhotos> = CDPhotos.fetchRequest()

        do {
            self.favorites = try self.moc.fetch(fetchRequest) as [CDPhotos]
        } catch let error {
            print("error FetchRequest widget \(error)")
            self.favorites = []
        }
    }
}
