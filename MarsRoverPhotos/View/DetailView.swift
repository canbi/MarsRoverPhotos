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
    
    let oneColumns = [GridItem(.flexible(maximum: .infinity))]
    let twoColumns = [GridItem(.flexible(maximum: .infinity)),
                      GridItem(.flexible(maximum: .infinity))]
    
    let maxWidth: CGFloat = 700
    var tintColor: Color { settingManager.getTintColor(roverType: vm.roverType) }
    
    init(photo: Photo? = nil, cdPhoto: CDPhotos? = nil, manifest: PhotoManifest?, roverVM: RoverViewModel){
        self._vm = StateObject(wrappedValue: DetailViewModel(photo: photo,cdPhoto: cdPhoto, manifest: manifest, roverVM: roverVM))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0){
                if let photo = vm.photo {
                    ImageView(photo: photo)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .bottomTrailing) { ZoomButton(action: vm.zoomImage) }
                        .overlay(alignment: .top) { ImageTopButtons }
                        .layoutPriority(1000)
                    
                    PhotoInformationView
                    
                } else {
                    ImageOfflineView(photo: vm.cdPhoto!)
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .bottomTrailing) { ZoomButton(action: vm.zoomImage) }
                        .overlay(alignment: .top) { ImageTopButtons }
                        .layoutPriority(1000)
                    
                    PhotoInformationOfflineView
                }
                
                Spacer()
                    .sheet(isPresented: $vm.showingZoomImageView, content: {
                        ImageZoomView(image: vm.clickedImage!, tintColor: tintColor)
                    })
                
                ShareButton
                    .sheet(isPresented: $vm.showShareSheet) {
                        let photo = vm.getImage()!
                        let itemSource = ShareActivityItemSource(shareText: vm.imageShareName, shareImage: photo)
                        ShareSheet(activityItems: [photo, itemSource])
                            .ignoresSafeArea()
                    }
            }
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

// MARK: - Buttons
extension DetailView {
    private var ImageTopButtons: some View {
        HStack(spacing: 0) {
            BackButton(color: tintColor) { dismiss() }
                .padding(.top, 24)
                .padding(.leading, -6)
            
            Spacer()
            
            FavoritesButton
        }
    }
    
    private var FavoritesButton: some View {
        Button{
            vm.favoriteButton {dismiss()}
        } label: {
            Image(systemName: vm.isFavorited ? "heart.fill" : "heart")
                .font(.system(size: 30))
                .foregroundColor(vm.isFavorited ? .red : .white)
        }
        .padding(.top, 32)
        .padding(.trailing)
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
            
        })
        .padding(.bottom)
        .frame(maxWidth: maxWidth)
    }
}

// MARK: - Rover Information
extension DetailView {
    private var PhotoInformationOfflineView: some View {
        LazyVGrid(columns: settingManager.idiom == .pad ? twoColumns : oneColumns, alignment: .center, spacing: 10) {
            if let photo = vm.cdPhoto {
                CustomGroupHorizontalBox(iconName: "sun.max.fill",
                                         title: "Rover",
                                         subtitle: photo.wrappedRoverType.rawValue,
                                         titleColor: tintColor)
                
                if let manifest = vm.manifest {
                    CustomGroupHorizontalBox(iconName: "heart.fill",
                                             title: "Rover Status",
                                             subtitle: manifest.status,
                                             titleColor: tintColor)
                    
                    CustomGroupHorizontalBox(iconName: "airplane.departure",
                                             title: "Launch Date",
                                             subtitle: "\(manifest.launchDate.formatted(.dateTime.day().month().year()))",
                                             titleColor: tintColor)
                    
                    CustomGroupHorizontalBox(iconName: "airplane.arrival",
                                             title: "Landing Date",
                                             subtitle: "\(manifest.landingDate.formatted(.dateTime.day().month().year()))",
                                             titleColor: tintColor)
                }
                
                
                CustomGroupHorizontalBox(iconName: "calendar",
                                         title: "Taken Sol",
                                         subtitle: String(photo.sol),
                                         titleColor: tintColor)
                
                if let date = photo.earthDate {
                    CustomGroupHorizontalBox(iconName: "calendar",
                                             title: "Taken Earth Date",
                                             subtitle: "\(date.formatted(.dateTime.day().month().year()))",
                                             titleColor: tintColor)
                }
                
                CustomGroupHorizontalBox(iconName: "camera",
                                         title: "Camera Code",
                                         subtitle: photo.wrappedCameraType.rawValue,
                                         titleColor: tintColor)
                
                CustomGroupHorizontalBox(iconName: "camera.badge.ellipsis",
                                         title: "Camera Name",
                                         subtitle: photo.wrappedCameraType.fullName.rawValue,
                                         titleColor: tintColor)
            }
        }
        .padding()
    }
    
    
    private var PhotoInformationView: some View {
        LazyVGrid(columns: settingManager.idiom == .pad ? twoColumns : oneColumns, alignment: .center, spacing: 10) {
            if let photo = vm.photo {
                CustomGroupHorizontalBox(iconName: "sun.max.fill",
                                         title: "Rover",
                                         subtitle: photo.rover.name.rawValue,
                                         titleColor: tintColor)
                
                CustomGroupHorizontalBox(iconName: "heart.fill",
                                         title: "Rover Status",
                                         subtitle: photo.rover.status.capitalized,
                                         titleColor: tintColor)
                if let manifest = vm.manifest {
                    CustomGroupHorizontalBox(iconName: "airplane.departure",
                                             title: "Launch Date",
                                             subtitle: "\(manifest.launchDate.formatted(.dateTime.day().month().year()))",
                                             titleColor: tintColor)
                    
                    CustomGroupHorizontalBox(iconName: "airplane.arrival",
                                             title: "Landing Date",
                                             subtitle: "\(manifest.landingDate.formatted(.dateTime.day().month().year()))",
                                             titleColor: tintColor)
                }
                
                CustomGroupHorizontalBox(iconName: "calendar",
                                         title: "Taken Sol",
                                         subtitle: String(photo.sol),
                                         titleColor: tintColor)
                
                CustomGroupHorizontalBox(iconName: "calendar",
                                         title: "Taken Earth Date",
                                         subtitle: "\(photo.earthDate.formatted(.dateTime.day().month().year()))",
                                         titleColor: tintColor)
                
                CustomGroupHorizontalBox(iconName: "camera",
                                         title: "Camera Code",
                                         subtitle: photo.camera.name.rawValue,
                                         titleColor: tintColor)
                
                CustomGroupHorizontalBox(iconName: "camera.badge.ellipsis",
                                         title: "Camera Name",
                                         subtitle: photo.camera.fullName.rawValue,
                                         titleColor: tintColor)
            }
        }
        .padding()
    }
}

// MARK: - Preview
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(photo: .previewData, cdPhoto: CDPhotos(),
                   manifest: .previewData,
                   roverVM: RoverViewModel(rover: .spirit,
                                           dataService: .previewInstance))
    }
}
