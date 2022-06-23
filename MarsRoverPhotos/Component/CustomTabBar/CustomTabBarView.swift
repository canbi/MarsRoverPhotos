//
//  CustomTabBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Nick Sarno on 9/6/21.
//  https://youtu.be/FxW9Dxt896U
//

import SwiftUI

struct CustomTabBarView: View {
    let tabs: [NavBarItem]
    @Binding var selection: NavBarItem
    @Namespace private var namespace
    @State var localSelection: NavBarItem
    @Binding var scrollToTop: Bool
    
    var body: some View {
        tabBarVersion
            .onChange(of: selection, perform: { value in
                withAnimation(.easeInOut) {
                    localSelection = value
                }
            })
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static let tabs: [NavBarItem] = [.curiosity, .opportunity, .spirit]

    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!, scrollToTop: .constant(false))
        }
    }
}

extension CustomTabBarView {
    private func switchToTab(tab: NavBarItem) {
        selection = tab
    }
    
    private func tabView(tab: NavBarItem) -> some View {
        HStack(spacing: 0){
            Image(systemName: tab.iconName)
                .font(.subheadline)
            Text(tab.tabTitle)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
        }
        .foregroundColor(localSelection == tab ? tab.color : Color.secondary)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(tab.color.opacity(0.2))
                        .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
        )
        .contentShape(Rectangle())
    }
    
    private var tabBarVersion: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabView(tab: tab)
                    .onTapGesture {
                        switchToTab(tab: tab)
                    }
                    .simultaneousGesture(
                        TapGesture(count: 2)
                            .onEnded { _ in
                                scrollToTop = true
                            }
                    )
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 26)
                .fill(Color(UIColor.secondarySystemBackground))
        )
        .cornerRadius(20)
        .padding(.horizontal)
    }
}
