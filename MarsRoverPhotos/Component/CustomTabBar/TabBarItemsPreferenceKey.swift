//
//  TabBarItemsPreferenceKey.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Nick Sarno on 9/6/21.
//  https://youtu.be/FxW9Dxt896U
//

import Foundation
import SwiftUI

struct TabBarItemsPreferenceKey: PreferenceKey {
    
    static var defaultValue: [NavBarItem] = []
    
    static func reduce(value: inout [NavBarItem], nextValue: () -> [NavBarItem]) {
        value += nextValue()
    }
    
}

struct TabBarItemViewModifer: ViewModifier {
    
    let tab: NavBarItem
    @Binding var selection: NavBarItem
    
    func body(content: Content) -> some View {
        content
            .opacity(selection == tab ? 1.0 : 0.0)
            .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
    }
    
}

struct TabBarItemViewModiferWithOnAppear: ViewModifier {
    
    let tab: NavBarItem
    @Binding var selection: NavBarItem
    
    @ViewBuilder func body(content: Content) -> some View {
        if selection == tab {
            content
                .opacity(1)
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
        } else {
            Text("")
                .opacity(0)
                .preference(key: TabBarItemsPreferenceKey.self, value: [tab])
        }
    }
    
}

extension View {
    
    func tabBarItem(tab: NavBarItem, selection: Binding<NavBarItem>) -> some View {
        modifier(TabBarItemViewModiferWithOnAppear(tab: tab, selection: selection))
    }
    
}
