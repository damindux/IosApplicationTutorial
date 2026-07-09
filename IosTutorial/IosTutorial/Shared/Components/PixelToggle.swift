//
//  PixelToggle.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-09.
//

import SwiftUI

struct PixelToggle: View {
  let title: String
  @Binding var isOn: Bool
  
  var body: some View {
    HStack {
      Text(title)
        .font(Font.custom("Pixelify Sans", size: 18))
        .foregroundStyle(.text)
      Spacer()
      
      ZStack(alignment: isOn ? .trailing : .leading) {
        Rectangle()
          .fill(isOn ? .on : .sectionBg)
          .frame(width: 56, height: 28)
          .overlay(
            Rectangle()
              .stroke(.border, lineWidth: 2)
          )
        
        Rectangle()
          .fill(.text)
          .frame(width: 24, height: 24)
          .offset(x: isOn ? -2 : 2)
          .shadow(color: .border.opacity(0.5), radius: 0, x: 2, y: 2)
      }
      .onTapGesture {
        withAnimation(.easeInOut(duration: 0.15)) {
          isOn.toggle()
        }
      }
    }
  }
}
