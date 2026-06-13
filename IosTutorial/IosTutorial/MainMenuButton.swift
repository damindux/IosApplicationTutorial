//
//  MainMenuButton.swift
//  IosTutorial
//
//  Created by Student3 on 2026-06-13.
//

import SwiftUI

struct MainMenuButton: View {
    let text: String
    let color: Color
    
    var body: some View {
        Button(text) {
        }
        .font(.title3)
        .fontWeight(.semibold)
        .foregroundStyle(.white)
        .frame(maxWidth: 150, maxHeight: 30)
        .padding(15)
        .background(color)
        .clipShape(Capsule())
    }
}
//
//#Preview {
//    MainMenuButton()
//}
