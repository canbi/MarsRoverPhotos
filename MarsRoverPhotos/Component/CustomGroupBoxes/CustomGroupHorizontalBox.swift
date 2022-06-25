//
//  CustomGroupHorizontalBox.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

struct CustomGroupHorizontalBox: View {
    var iconName: String
    var title: String
    var subtitle: String?
    var titleColor: Color
    
    var body: some View {
        HStack(spacing: 2){
            Label(title, systemImage: iconName)
                .foregroundColor(titleColor)
            Spacer()
            Text(subtitle ?? "")
        }
        .font(.caption)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
