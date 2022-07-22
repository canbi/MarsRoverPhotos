//
//  MarsWidgetView.swift
//  MarsWidgetExtension
//
//  Created by Can Bi on 22.07.2022.
//

import SwiftUI
import WidgetKit

struct MarsWidgetEntryView : View {
    private let fileManagerForFavorites: LocalFileManagerImage = LocalFileManagerImage(folderName: "favorites")
    
    var entry: Provider.Entry
    
    var body: some View {
        Group {
            if let id = entry.photoId {
                GeometryReader { geo in
                    imageView(uiImage: fileManagerForFavorites.getImage(name: String(id)))
                        .frame(width: geo.size.width, height: geo.size.height)
                        .overlay(
                            CustomGroupBoxSuperMini(iconName: "camera",
                                               subtitle: entry.photoCameraName!,
                                               iconColor: .secondary)
                            .opacity(0.8)
                            .padding([.bottom, .trailing], 6), alignment: .bottomTrailing
                        )
                        .overlay(
                            CustomGroupBoxSuperMini(iconName: "sun.max.fill",
                                               subtitle: entry.photoRoverName!,
                                               iconColor: .secondary)
                            .opacity(0.8)
                            .padding([.top, .leading], 6), alignment: .topLeading
                        )
                }
            } else {
                VStack(alignment: .center) {
                    Image(systemName: "heart")
                        .imageScale(.large)
                    
                    Text("You don't have any favorites in this selection")
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
        }
    }
}

extension MarsWidgetEntryView {
    private func imageView(uiImage: UIImage?) -> some View {
        Group {
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height:200, alignment: .center)
            }
        }
    }
}
