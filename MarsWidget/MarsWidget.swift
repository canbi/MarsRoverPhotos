//
//  MarsWidget.swift
//  MarsWidget
//
//  Created by Can Bi on 22.07.2022.
//

import WidgetKit
import SwiftUI
import Intents

@main
struct MarsWidget: Widget {
    let kind: String = "MarsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
            MarsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Mars Rovers")
        .description("Your favorite Mars photos.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct MarsWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MarsWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), photoId: nil, photoRoverName: nil, photoEarthDate: nil, photoMartianSol: nil, photoCameraName: nil))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            MarsWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), photoId: nil, photoRoverName: nil, photoEarthDate: nil, photoMartianSol: nil, photoCameraName: nil))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MarsWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), photoId: nil, photoRoverName: nil, photoEarthDate: nil, photoMartianSol: nil, photoCameraName: nil))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
