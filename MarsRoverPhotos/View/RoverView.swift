//
//  RoverView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 20.06.2022.
//

import SwiftUI

struct RoverView: View {
    @EnvironmentObject var coreDataService: CoreDataDataService
    @EnvironmentObject var settingManager: SettingManager
    @ObservedObject var networkMonitor: NetworkMonitor = NetworkMonitor()
    @StateObject var vm: RoverViewModel
    @Binding var shouldScrollToTop: Bool
    
    var currentTintColor: Color { settingManager.getTintColor(roverType: vm.rover)}
    
    init(rover: RoverType, shouldScroolToTop: Binding<Bool>, dataService: JSONDataService){
        self._vm = StateObject(wrappedValue: RoverViewModel(rover: rover,
                                                            dataService: dataService))
        self._shouldScrollToTop = shouldScroolToTop
    }
    
    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                LazyVStack(spacing: 6, pinnedViews: .sectionHeaders) {
                    PageHeader
                        .sheet(isPresented: $vm.showingSettingsViewSheet) {
                            SettingsView(tintColor: currentTintColor)
                        }
                        .onAppear{
                            vm.setup(coreDataService: coreDataService, networkMonitor: networkMonitor)
                        }
                    
                    RoverImageView
                    
                    RoverInformationView
                    
                    ImageSectionView
                        .sheet(isPresented: $vm.showingFilterViewSheet) {
                            FilterView(roverVM: vm, tintColor: currentTintColor)
                        }
                }
                
                Spacer().frame(height: 100)
            }
            .navigationDestination(for: $vm.selectedImage) { photo in
                DetailView(photo: photo, manifest: vm.roverManifest!, roverVM: vm)
            }
            .navigationDestination(for: $vm.selectedOfflineImage) { photo in
                DetailView(cdPhoto: photo, manifest: vm.roverManifest ?? vm.getLocalRoverManifestData(), roverVM: vm)
            }
            .onChange(of: shouldScrollToTop) { _ in
                withAnimation {
                    reader.scrollTo("top", anchor: .top)
                    shouldScrollToTop = false
                }
            }
        }
    }
}

// MARK: - Image
extension RoverView {
    private var ImageSectionView: some View {
        Section(header: SectionHeader, footer: SectionFooter) {
            if vm.roverImages.isEmpty && !vm.isLoaded && networkMonitor.isConnected {
                RedactedEmptyImageView
            }
            
            let oneColumns = [GridItem(.flexible(maximum: .infinity))]
            let twoColumns = [GridItem(.flexible(maximum: .infinity)),
                              GridItem(.flexible(maximum: .infinity))]
            
            LazyVGrid(columns: settingManager.gridDesign == .oneColumn ? oneColumns : twoColumns,
                      alignment: .leading, spacing: 10) {
                
                if vm.showingOnlyFavorites {
                    FavoriteImagesView
                }
                else {
                    MainImagesView
                }
            }
                      .padding(.horizontal)
                      .animation(.easeInOut, value: settingManager.gridDesign)
        }
    }
    
    private var MainImagesView: some View {
        ForEach(vm.roverImages, id: \.id) { photo in
            ImageView(photo: photo, showCameraInfo: true)
                .overlay(Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .imageScale(settingManager.gridDesign == .oneColumn ? .large : .medium)
                    .opacity(coreDataService.isFavorited(in: vm.favoritePhotos, id: photo.id) ? 1 : 0)
                    .padding([.top,.trailing], 6),
                         alignment: .topTrailing)
                .cornerRadius(16)
                .onTapGesture { vm.selectedImage = photo }
        }
    }
    
    private var FavoriteImagesView: some View {
        ForEach(vm.favoritePhotos, id: \.wrappedId) { photo in
            ImageOfflineView(photo: photo, showCameraInfo: true)
                .overlay(Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .imageScale(settingManager.gridDesign == .oneColumn ? .large : .medium)
                    .padding([.top,.trailing], 6),
                         alignment: .topTrailing)
                .cornerRadius(16)
                .onTapGesture { vm.selectedOfflineImage = photo }
        }
    }
    
    private var RedactedEmptyImageView: some View {
        RoundedRectangle(cornerRadius: 16)
            .foregroundColor(Color(UIColor.secondarySystemBackground))
            .frame(height:300)
            .frame(maxWidth: .infinity)
            .padding([.horizontal])
            .redacted(reason: .placeholder)
    }
    
    private var RoverImageView: some View {
        Image(vm.rover.rawValue.lowercased())
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 300)
            .padding(.leading)
    }
}

// MARK: - Section
extension RoverView {
    private var PageHeader: some View {
        HStack {
            TitleView(vm.rover.rawValue)
            Spacer()
            SettingsButton
        }
        .padding(.top, 44)
        .id("top")
    }
    
    private var RoverInformationView: some View {
        Group {
            if networkMonitor.isConnected {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 95), spacing: 10)]) {
                    OnlineGroupBoxes
                }
                .padding(.horizontal)
                .redacted(reason: vm.roverManifest == nil ? .placeholder : [])
            } else {
                let localManifestData = vm.getLocalRoverManifestData()
                if let localManifestData = localManifestData {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 95), spacing: 10)]) {
                        OfflineGroupBoxes(localManifestData)
                    }
                    .padding(.horizontal)
                    if let localSaveDate = localManifestData.localSaveDate {
                        OfflineLastUpdateText(localSaveDate)
                    }
                }
                else {
                    Text("No internet connection.")
                }
            }
        }
    }
    
    private func OfflineLastUpdateText(_ localSaveDate: Date) -> some View {
        HStack{
            Spacer()
            Text("Last update \(localSaveDate.formatted(.dateTime.day().month().year()))")
                .font(.caption)
                .padding(.trailing)
        }
    }
    
    private func OfflineGroupBoxes(_ localManifestData: PhotoManifest) -> some View {
        Group {
            CustomGroupBox(iconName: "sun.max.fill",
                           title: "Max Sol",
                           subtitle: String(localManifestData.maxSol),
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "calendar",
                           title: "Max Date",
                           subtitle: "\(localManifestData.maxDate.formatted(.dateTime.day().month().year()))",
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "photo.on.rectangle.angled",
                           title: "Total Photos",
                           subtitle: String(localManifestData.totalPhotos),
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "heart.fill",
                           title: "Status",
                           subtitle: localManifestData.status.capitalized,
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "airplane.departure",
                           title: "Launch Date",
                           subtitle: "\(localManifestData.launchDate.formatted(.dateTime.day().month().year()))",
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "airplane.arrival",
                           title: "Landing Date",
                           subtitle: "\(localManifestData.landingDate.formatted(.dateTime.day().month().year()))",
                           titleColor: currentTintColor)
        }
    }
    
    private var OnlineGroupBoxes: some View {
        Group {
            CustomGroupBox(iconName: "sun.max.fill",
                           title: "Max Sol",
                           subtitle: String(vm.roverManifest?.maxSol ?? 0),
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "calendar",
                           title: "Max Date",
                           subtitle: "\(vm.roverManifest?.maxDate.formatted(.dateTime.day().month().year()) ?? "")",
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "photo.on.rectangle.angled",
                           title: "Total Photos",
                           subtitle: String(vm.roverManifest?.totalPhotos ?? 0),
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "heart.fill",
                           title: "Status",
                           subtitle: vm.roverManifest?.status.capitalized,
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "airplane.departure",
                           title: "Launch Date",
                           subtitle: "\(vm.roverManifest?.launchDate.formatted(.dateTime.day().month().year()) ?? "")",
                           titleColor: currentTintColor)
            
            CustomGroupBox(iconName: "airplane.arrival",
                           title: "Landing Date",
                           subtitle: "\(vm.roverManifest?.landingDate.formatted(.dateTime.day().month().year()) ?? "")",
                           titleColor: currentTintColor)
        }
    }
    
    private var SectionHeader: some View {
        VStack(alignment:.leading, spacing: 0) {
            HStack(spacing: 0) {
                TitleView("Photos")
                
                Spacer()
                
                FavoritesButton
                
                GridButton
                
                FilterButton
            }
            Group {
                if !vm.roverImages.isEmpty{
                    CurrentFiltersBanner
                }
            }
            .font(.caption)
            .padding(.leading)
            .padding(.top, -10)
        }
        .padding(.top, 30)
        .padding(.bottom, 8)
    }
    
    private var CurrentFiltersBanner: some View {
        Group{
            Text(vm.selectedDateType == .sol ? "Sol \(String(vm.sol))" : "Earth Date \(vm.earthDate.formatted(.dateTime.day().month().year()))") + Text(", \(vm.selectedCameraType.rawValue),  \(vm.sorting.rawValue)")
        }
        .padding(.horizontal,6)
        .padding(.vertical,4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .opacity(vm.showingOnlyFavorites ? 0 : 1)
    }
    
    private var SectionFooter: some View {
        Group {
            if vm.roverImages.isEmpty && vm.isLoaded {
                VStack{
                    Title2View("Nothing")
                    SubtitleView("There are no available photos. Change filters to explore!")
                }
            } else if vm.favoritePhotos.isEmpty && vm.showingOnlyFavorites {
                VStack{
                    Title2View("Nothing")
                    SubtitleView("There are no favorite photos. Explore and favorite photos!")
                }
            } else if vm.isLoaded {
                VStack{
                    Title2View("Done")
                    SubtitleView("You have visited all the available photos. Change filters to explore!")
                }
            }
        }
        .onChange(of: vm.roverImages) { _ in
            vm.isLoaded = true
        }
    }
}

// MARK: - Texts
extension RoverView {
    private func TitleView(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(currentTintColor)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.leading)
            Spacer()
        }
    }
    
    private func Title2View(_ title: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(currentTintColor)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading)
            Spacer()
        }
    }
    
    private func SubtitleView(_ subtitle: String) -> some View {
        HStack {
            Text(subtitle)
                .foregroundColor(currentTintColor)
                .font(.body)
                .padding(.leading)
            Spacer()
        }
    }
}

// MARK: - Buttons
extension RoverView {
    private var FilterButton: some View {
        Button {
            vm.showingFilterViewSheet.toggle()
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title)
                .tint(currentTintColor)
                .padding(.vertical)
                .padding(.horizontal, 8)
        }
    }
    
    private var GridButton: some View {
        Button {
            settingManager.changeGrid()
        } label: {
            Image(systemName: settingManager.gridDesign == .oneColumn ? "rectangle.grid.2x2" : "rectangle.grid.1x2")
                .font(.title)
                .tint(currentTintColor)
                .padding(.vertical)
                .padding(.horizontal, 8)
        }
    }
    
    private var FavoritesButton: some View {
        Button {
            guard networkMonitor.isConnected else { return }
            vm.showingOnlyFavorites.toggle()
        } label: {
            Image(systemName: vm.showingOnlyFavorites ? "heart.fill" : "heart")
                .font(.title)
                .tint(currentTintColor)
                .padding(.vertical)
                .padding(.horizontal, 8)
        }
    }
    
    private var SettingsButton: some View {
        Button {
            vm.showingSettingsViewSheet.toggle()
        } label: {
            Image(systemName: "gear")
                .font(.title)
                .tint(currentTintColor)
                .padding()
        }
    }
}

// MARK: - Preview
struct RoverView_Previews: PreviewProvider {
    static var previews: some View {
        RoverView(rover: .curiosity, shouldScroolToTop: .constant(false), dataService: .previewInstance)
    }
}
