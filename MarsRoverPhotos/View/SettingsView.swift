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
    
    let tintColor: Color
    
    var body: some View {
        NavigationView {
            List {
                ColorSettingsSection
                DeveloperSection
            }
            .font(.headline)
            .accentColor(tintColor)
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarHidden(false)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton(color: tintColor) { dismiss() }
                    .padding(.leading, -24)
                }
            }
            .overlay(ApplySettingsButton, alignment: .bottom)
        }
    }
}

extension SettingsView {
    private var ApplySettingsButton: some View {
        Button(action: {
            vm.applySettings()
            dismiss()
        }, label: {
            Text("Apply Settings")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(RoundedRectangle(cornerRadius: 16).foregroundColor(tintColor))
                .padding()
        })
        .opacity(vm.isAnythingChanged ? 1 : 0)
        .disabled(vm.isAnythingChanged ? false : true)
    }
    
    private var ColorSettingsSection: some View {
        Section(header: Text("Color Settings")){
            Group{
                ColorPicker("Curiosity Theme", selection: $vm.colorCuriosity, supportsOpacity: false)
                ColorPicker("Opportunity Theme", selection: $vm.colorOpportunity, supportsOpacity: false)
                ColorPicker("Spirit Theme", selection: $vm.colorSpirit, supportsOpacity: false)
            }
            .padding(.vertical)
            
            Button { vm.resetTheme() } label: {
                Text("Reset Theme")
            }
        }
    }
    
    
    private var DeveloperSection: some View {
        Section(header: Text("Developer")) {
            Text("This app was developed by Can Bi. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers, and data persistance.")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            Link("Visit Website 🤙", destination: vm.personalURL)
            Link("Contact me on Twitter 🤙", destination: vm.twitterURL)
            Link("See my public projects on GitHub 🤙", destination: vm.githubURL)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(tintColor: .red)
    }
}
