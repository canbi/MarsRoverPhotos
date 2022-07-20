//
//  SettingsView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingManager: SettingManager
    @StateObject var vm: SettingsViewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    let tintColor: Color
    
    init(tintColor: Color){
        self.tintColor = tintColor
        UITableView.appearance().contentInset.top = -20
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(tintColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(tintColor)]
    }
    
    var body: some View {
        NavigationView {
            List {
                ColorSettingsSection
                SaveAndFavoriteSection
                DeveloperSection
                APISection
                Color.clear.listRowBackground(Color.clear)
            }
            .font(.headline)
            .accentColor(tintColor)
            .listStyle(.automatic)
            .navigationTitle("Settings")
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(color: tintColor) { dismiss() }
                        .padding(.leading, -24)
                }
            }
            .overlay(ApplySettingsButton, alignment: .bottom)
            .onAppear {
                vm.setup(settingManager)
            }
        }
    }
}

// MARK: Button
extension SettingsView {
    private var ApplySettingsButton: some View {
        Button(action: {
            vm.applySettings()
            dismiss()
        }, label: {
            Text("Apply Settings".uppercased())
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(tintColor))
                .padding()
        })
        .opacity(vm.isAnythingChanged ? 1 : 0)
        .disabled(vm.isAnythingChanged ? false : true)
    }
}

// MARK: Sections
extension SettingsView {
    private var ColorSettingsSection: some View {
        Section(header: Text("Color Settings".uppercased())){
            ForEach(Themes.allCases) { theme in
                HStack {
                    Text(theme.rawValue)
                        .foregroundColor(vm.selectedTheme == theme ? tintColor : nil)
                    Spacer()
                    Group {
                        theme.curiosityColor
                        theme.opportunityColor
                        theme.spiritColor
                    }
                    .clipShape(Circle())
                    .frame(width: 30, height: 30)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    vm.selectedTheme = theme
                }
            }
            .padding(.vertical)
        }
    }
    
    private var SaveAndFavoriteSection: some View {
        Section(header: Text("Save Settings".uppercased())){
            Toggle("Save to Photos when favorited", isOn: $vm.saveToPhotoSelection)
        }
    }
    
    
    private var DeveloperSection: some View {
        Section(header: Text("Developer")) {
            Text("This app was developed by Can Bi. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical)
            Link("Visit Website 🖥️", destination: vm.personalURL)
            Link("Contact me on Twitter 🐦", destination: vm.twitterURL)
            Link("See my public projects on GitHub 👨‍💻", destination: vm.githubURL)
        }
    }
    
    private var APISection: some View {
        Section(header: Text("API")) {
            Text("Mars Rover Photos API is designed to collect image data gathered by NASA's Curiosity, Opportunity, and Spirit rovers on Mars and make it more easily available to other developers, educators, and citizen scientists.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical)
            Link("Visit APIs Website 🖥️", destination: vm.apiURL)
        }
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tintColor: .red)
    }
}
