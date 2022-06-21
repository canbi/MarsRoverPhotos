//
//  CustomTabBarContainerView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Nick Sarno on 9/6/21.
//  https://youtu.be/FxW9Dxt896U
//

import SwiftUI

struct CustomTabBarContainerView<Content:View>: View {
    @Binding var selection: NavBarItem
    let content: Content
    @State private var tabs: [NavBarItem] = []
    
    init(selection: Binding<NavBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            CustomTabBarView(tabs: tabs, selection: $selection, localSelection: selection)
                .padding(.bottom, 0)
            
        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct CustomTabBarContainerView_Previews: PreviewProvider {
    static let tabs: [NavBarItem] = [.curiosity, .opportunity, .spirit]
    
    static var previews: some View {
        CustomTabBarContainerView(selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}
