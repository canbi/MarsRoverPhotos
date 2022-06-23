//
//  DetailView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 21.06.2022.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showShareSheet = false
    
    init(photo: Photo, manifest: PhotoManifest){
        self._vm = StateObject(wrappedValue: DetailViewModel(photo: photo, manifest: manifest))
    }
    
    var body: some View {
        VStack(spacing: 0){
            ImageView(photo: vm.photo)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottomTrailing) {
                    ZoomButton(action: vm.zoomImage)
                }
                .sheet(isPresented: $vm.showingZoomImageView, content: {
                    ImageZoomView(image: vm.clickedImage!)
                })
                .overlay(alignment: .topLeading) {
                    BackButton { dismiss() }
                        .padding(.top, 24)
                        .padding(.leading, -6)
                }
            
            Spacer().frame(height: 20)
            
            PhotoInformationView
            
            Spacer()
            
            ShareButton 
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .navigationTitle("")
        .ignoresSafeArea()
    }
}

extension DetailView {
    private var ShareButton: some View {
        Button(action: {
            self.showShareSheet.toggle()
        }, label: {
            HStack {
                Image(systemName: "square.and.arrow.up")
                Text("Share")
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 16).foregroundColor(.red))
            .padding()
            
        }).sheet(isPresented: $showShareSheet) {
            let photo = vm.getImage()!
            let itemSource = ShareActivityItemSource(shareText: vm.imageShareName, shareImage: photo)
            ShareSheet(activityItems: [photo, itemSource])
                .ignoresSafeArea()
        }
        .padding(.bottom)
    }
    
    private var PhotoInformationView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 95), spacing: 10, alignment: .top)]) {
            GroupBox(label: Label("Rover", systemImage: "sun.max.fill").foregroundColor(vm.roverType.color)) {
                Text(vm.photo.rover.name.rawValue)
            }
            
            GroupBox(label: Label("Rover Status", systemImage: "heart.fill").foregroundColor(vm.roverType.color)) {
                Text(vm.photo.rover.status.capitalized)
            }
            
            GroupBox(label: Label("Launch Date", systemImage: "airplane.departure").foregroundColor(vm.roverType.color)) {
                Text("\(vm.manifest.launchDate.formatted(.dateTime.day().month().year()))")
            }
            
            GroupBox(label: Label("Landing Date", systemImage: "airplane.arrival").foregroundColor(vm.roverType.color)) {
                Text("\(vm.manifest.landingDate.formatted(.dateTime.day().month().year()))")
            }
            
            GroupBox(label: Label("Taken Sol", systemImage: "calendar").foregroundColor(vm.roverType.color)) {
                Text(String(vm.photo.sol))
            }
            
            GroupBox(label: Label("Taken Earth Date", systemImage: "calendar").foregroundColor(vm.roverType.color)) {
                Text("\(vm.photo.earthDate.formatted(.dateTime.day().month().year()))")
            }
            
            GroupBox(label: Label("Camera Code", systemImage: "camera").foregroundColor(vm.roverType.color)) {
                Text(vm.photo.camera.name.rawValue)
            }
            
            GroupBox(label: Label("Camera Name", systemImage: "camera.badge.ellipsis").foregroundColor(vm.roverType.color)) {
                Text(vm.photo.camera.fullName.rawValue)
            }
        }
        .groupBoxStyle(CardGroupBoxStyle())
        .padding(.horizontal)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(photo: .previewData, manifest: .previewData)
    }
}
