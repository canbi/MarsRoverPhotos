//
//  CustomGroupBox.swift
//  MarsRoverPhotos
//
//  Created by Can Bi on 25.06.2022.
//

import SwiftUI

struct CustomGroupBox: View {
    var iconName: String
    var title: String
    var subtitle: String?
    var titleColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2){
            Label(title, systemImage: iconName)
                .foregroundColor(titleColor)
            Text(subtitle ?? "")
        }
        .frame(minWidth: 95, alignment: .leading)
        .font(.caption)
        .padding([.leading,.vertical], 8)
        .padding(.trailing, 6)
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
