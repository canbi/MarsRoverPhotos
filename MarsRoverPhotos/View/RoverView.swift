//
//  RoverView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct RoverView: View {
    @StateObject var vm: RoverViewModel
    let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
    
    
    init(rover: RoverType, dataService: JSONDataService){
        self._vm = StateObject(wrappedValue: RoverViewModel(rover: rover,
                                                            dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 6) {
                TitleView(title: vm.rover.rawValue)
                    .padding(.top, 44)
                
                RoverImage
                
                RoverInformation
                
                Spacer().frame(height:10)
                
                TitleView(title: "Photographs")
                    .padding(.bottom)
                
                ForEach(vm.roverImages, id: \.id) { photo in
                    ImageView(photo: photo)
                        .frame(maxWidth: .infinity, minHeight: 300)
                        .onTapGesture { vm.selectedImage = photo }
                        .cornerRadius(16)
                }
            }
        }
        .navigationDestination(for: $vm.selectedImage) { photo in
            DetailView(photo: photo)
        }
    }
}

extension RoverView {
    private func TitleView(title: String) -> some View {
        HStack {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.leading)
            Spacer()
        }
    }
    
    var RoverImage: some View {
        Image(vm.rover.rawValue.lowercased())
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 300)
            .padding(.leading)
    }
    
    var RoverInformation: some View {
        Group {
            if let roverManifest = vm.roverManifest {
                LazyVGrid(columns: columns) {
                    GroupBox(label: Label("Max Sol", systemImage: "sun.max.fill")) {
                        Text("\(roverManifest.maxSol)")
                    }
                    
                    GroupBox(label: Label("Max Date", systemImage: "calendar")) {
                        Text(roverManifest.maxDate)
                    }
                    
                    GroupBox(label: Label("Total Photos", systemImage: "photo.on.rectangle.angled")) {
                        Text("\(roverManifest.totalPhotos)")
                    }
                    
                    GroupBox(label: Label("Status", systemImage: "heart.fill")) {
                        Text(roverManifest.status.capitalized)
                    }
                    
                    GroupBox(label: Label("Launch Date", systemImage: "airplane.departure")) {
                        Text(roverManifest.launchDate)
                    }
                    
                    GroupBox(label: Label("Landing Date", systemImage: "airplane.arrival")) {
                        Text(roverManifest.landingDate)
                    }
                }
                .groupBoxStyle(CardGroupBoxStyle())
                .padding(.horizontal)
            }
            else {
                ProgressView()
                    .frame(height:100)
            }
        }
    }
}

struct RoverView_Previews: PreviewProvider {
    static var previews: some View {
        RoverView(rover: .curiosity, dataService: .previewInstance)
    }
}
