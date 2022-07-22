//
//  TimelineEntry.swift
//  MarsWidgetExtension
//
//  Created by Can Bi on 22.07.2022.
//

import CoreData
import WidgetKit

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let photoId: Int32?
    let photoRoverName: String?
    let photoEarthDate: Date?
    let photoMartianSol: Int32?
    let photoCameraName: String?
}
