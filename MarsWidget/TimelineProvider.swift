//
//  TimelineProvider.swift
//  MarsWidgetExtension
//
//  Created by Can Bi on 22.07.2022.
//

import WidgetKit
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), photoId: nil,photoRoverName: nil, photoEarthDate: nil,photoMartianSol: nil,photoCameraName: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent,
                     in context: Context,
                     completion: @escaping (SimpleEntry) -> ()) {
        createTimelineEntry(date: Date(), configuration: configuration, completion: completion)
    }

    func getTimeline(for configuration: ConfigurationIntent,
                     in context: Context,
                     completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        
        createTimeline(date: Date(), configuration: configuration, completion: completion)
    }
    
    func createTimelineEntry(date: Date,
                             configuration: ConfigurationIntent,
                             completion: @escaping (SimpleEntry) -> ()) {
        let coreDataService = CoreDataWidgetService(moc: CoreDataController().container.viewContext)
        let allData: [CDPhotos] = coreDataService.favorites.shuffled()
        print("entry toplam data sayısı1 \(allData.count)")
        let photoData: CDPhotos? = allData.first
        
        let entry = SimpleEntry(date: date,
                                configuration: configuration,
                                photoId: photoData?.id,
                                photoRoverName: photoData?.roverName,
                                photoEarthDate: photoData?.earthDate,
                                photoMartianSol: photoData?.sol,
                                photoCameraName: photoData?.cameraName)
        completion(entry)
    }
    
    func createTimeline(date: Date,
                        configuration: ConfigurationIntent,
                        completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        //Get core data
        let coreDataService = CoreDataWidgetService(moc: CoreDataController().container.viewContext)
        let allData: [CDPhotos]  = coreDataService.favorites.shuffled()
        
        //Timeline hours
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        for hourOffset in 0 ..< min(5, allData.count) {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let photoData: CDPhotos? = allData[hourOffset]

            let entry = SimpleEntry(date: entryDate,
                                    configuration: configuration,
                                    photoId: photoData?.id,
                                    photoRoverName: photoData?.roverName,
                                    photoEarthDate: photoData?.earthDate,
                                    photoMartianSol: photoData?.sol,
                                    photoCameraName: photoData?.cameraName)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
