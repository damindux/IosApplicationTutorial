//
//  AnswerButton.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-03.
//

import SwiftUI

struct AnswerButton: View {
  let title: String
  let isSelected: Bool
  let isCorrect: Bool?
  let action: () -> Void
  
  @State private var flash = false
  
  var body: some View {
    Button(action: {
      action()
      
      if isCorrect == true {
        withAnimation(.easeOut(duration: 0.2)) {
          flash = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          flash = false
        }
      }
    }) {
      Text(title)
        .font(.title3)
        .fontWeight(.bold)
        .foregroundStyle(.white)
        .frame(width: 300, height: 50)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .scaleEffect(isCorrect == true && flash ? 1.05 : 1.0)
    }
  }
  
  private var backgroundColor: Color {
    if isSelected {
      if isCorrect == true {
        return .green
      } else if isCorrect == false {
        return .red
      }
    }
    
    return .primary
  }
}
