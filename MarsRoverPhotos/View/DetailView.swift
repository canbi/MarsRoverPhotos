//
//  DetailView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var settingManager: SettingManager
    @EnvironmentObject var coreDataService: CoreDataDataService
    @StateObject var vm: DetailViewModel
    @Environment(\.dismiss) var dismiss
    
    var tintColor: Color { settingManager.getTintColor(roverType: vm.roverType) }
    
    init(photo: Photo, manifest: PhotoManifest, roverVM: RoverViewModel){
        self._vm = StateObject(wrappedValue: DetailViewModel(photo: photo, manifest: manifest, roverVM: roverVM))
    }
    
    var body: some View {
        VStack(spacing: 0){
            ImageView(photo: vm.photo)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottomTrailing) { ZoomButton(action: vm.zoomImage) }
                .overlay(alignment: .top) { ImageTopButtons }
                .layoutPriority(1000)
            
            PhotoInformationView
                .sheet(isPresented: $vm.showingZoomImageView, content: {
                    ImageZoomView(image: vm.clickedImage!, tintColor: tintColor)
                })
            
            Spacer()
            
            ShareButton 
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationTitle("")
        .ignoresSafeArea()
        .onAppear {
            vm.setup(settingManager: settingManager, coreDataService: coreDataService)
        }
    }
}

extension DetailView {
    private var ImageTopButtons: some View {
        HStack(spacing: 0) {
            BackButton(color: tintColor) { dismiss() }
                .padding(.top, 24)
                .padding(.leading, -6)
            
            Spacer()
            
            Button(action: vm.favoriteButton){
                Image(systemName: vm.isFavorited ? "heart.fill" : "heart")
                    .font(.system(size: 30))
                    .foregroundColor(vm.isFavorited ? .red : .white)
            }
            .padding(.top, 32)
            .padding(.trailing)
        }
    }
    
    
    private var ShareButton: some View {
        Button(action: {
            vm.showShareSheet.toggle()
        }, label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share")
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(tintColor))
            .padding()
            
        }).sheet(isPresented: $vm.showShareSheet) {
            let photo = vm.getImage()!
            let itemSource = ShareActivityItemSource(shareText: vm.imageShareName, shareImage: photo)
            ShareSheet(activityItems: [photo, itemSource])
                .ignoresSafeArea()
        }
        .padding(.bottom)
    }
    
    private var PhotoInformationView: some View {
        VStack {
            CustomGroupHorizontalBox(iconName: "sun.max.fill",
                                     title: "Rover",
                                     subtitle: vm.photo.rover.name.rawValue,
                                     titleColor: tintColor)
            
            CustomGroupHorizontalBox(iconName: "heart.fill",
                                     title: "Rover Status",
                                     subtitle: vm.photo.rover.status.capitalized,
                                     titleColor: tintColor)
            
            CustomGroupHorizontalBox(iconName: "airplane.departure",
                                     title: "Launch Date",
                                     subtitle: "\(vm.manifest.launchDate.formatted(.dateTime.day().month().year()))",
                                     titleColor: tintColor)
            
            CustomGroupHorizontalBox(iconName: "airplane.arrival",
                                     title: "Landing Date",
                                     subtitle: "\(vm.manifest.landingDate.formatted(.dateTime.day().month().year()))",
                                     titleColor: tintColor)
            
            CustomGroupHorizontalBox(iconName: "calendar",
                                     title: "Taken Sol",
                                     subtitle: String(vm.photo.sol),
                                     titleColor: tintColor)
            
            CustomGroupHorizontalBox(iconName: "calendar",
                                     title: "Taken Earth Date",
                                     subtitle: "\(vm.photo.earthDate.formatted(.dateTime.day().month().year()))",
                                     titleColor: tintColor)
            
            CustomGroupHorizontalBox(iconName: "camera",
                                     title: "Camera Code",
                                     subtitle: vm.photo.camera.name.rawValue,
                                     titleColor: tintColor)
            
            CustomGroupHorizontalBox(iconName: "camera.badge.ellipsis",
                                     title: "Camera Name",
                                     subtitle: vm.photo.camera.fullName.rawValue,
                                     titleColor: tintColor)
        }
        .padding()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(photo: .previewData,
                   manifest: .previewData,
                   roverVM: RoverViewModel(rover: .spirit,
                                           shouldScrollToTop: .constant(false),
                                           dataService: .previewInstance))
    }
}
