//
//  SettingsView.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 23.06.2022.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm: SettingsViewModel = SettingsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ColorSettingsSection
                DeveloperSection
            }
            .font(.headline)
            .accentColor(.blue)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton { dismiss() }
                    .padding(.leading, -24)
                }
            }
        }
    }
}

extension SettingsView {
    private var ColorSettingsSection: some View {
        Section(header: Text("Color Settings")){
            ColorPicker("Curiosity Theme", selection: $vm.colorCuriosity, supportsOpacity: false)
            ColorPicker("Opportunity Theme", selection: $vm.colorOpportunity, supportsOpacity: false)
            ColorPicker("Spirit Theme", selection: $vm.colorSpirit, supportsOpacity: false)
            Button { vm.resetTheme() } label: {
                Text("Reset Theme")
            }

        }
    }
    
    
    private var DeveloperSection: some View {
        Section(header: Text("Developer")) {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was developed by Nick Sarno. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.red)
            }
            .padding(.vertical)
            Link("Visit Website 🤙", destination: vm.personalURL)
            Link("Contact me on Twitter 🤙", destination: vm.twitterURL)
            Link("See my public projects on GitHub 🤙", destination: vm.githubURL)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
