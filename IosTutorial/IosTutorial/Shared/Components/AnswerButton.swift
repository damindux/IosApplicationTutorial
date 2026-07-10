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
  let isCorrectAnswer: Bool
  let hasAnswered: Bool
  let action: () -> Void
  
  @State private var flash = false
  
  var body: some View {
    Button(action: {
      guard !hasAnswered else { return }
      action()
      
      if isCorrectAnswer {
        withAnimation(.easeOut(duration: 0.15)) {
          flash = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          withAnimation(.easeIn(duration: 0.15)) {
            flash = false
          }
        }
      }
    }) {
      HStack {
        Text(title)
          .font(Font.custom("Pixelify Sans", size: 18))
          .foregroundStyle(textColorComputed)
          .multilineTextAlignment(.leading)
        
        Spacer()
        
        if hasAnswered {
          Image(systemName: isCorrectAnswer ? "checkmark" : (isSelected ? "xmark" : ""))
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(iconColor)
        }
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity)
      .background(backgroundColor)
      .overlay(
        Rectangle()
          .stroke(borderColorComputed, lineWidth: 2)
      )
      .background(
        Rectangle()
          .fill(shadowColor)
          .offset(x: 3, y: 3)
      )
      .scaleEffect(flash ? 1.03 : 1.0)
    }
    .disabled(hasAnswered)
    .buttonStyle(PixelAnswerButtonStyle())
  }
  
  private var backgroundColor: Color {
    guard hasAnswered else { return .sectionBg }
    if isCorrectAnswer { return .on.opacity(0.25) }
    if isSelected && !isCorrectAnswer { return .text.opacity(0.15) }
    
    return .sectionBg.opacity(0.5)
  }
  
  private var borderColorComputed: Color {
    guard hasAnswered else { return .inactive }
    if isCorrectAnswer { return .on }
    if isSelected && !isCorrectAnswer { return .text }
    
    return .inactive.opacity(0.3)
  }
  
  private var textColorComputed: Color {
    guard hasAnswered else { return .text }
    if isCorrectAnswer { return .on }
    if isSelected && !isCorrectAnswer { return .text }
    
    return .text.opacity(0.3)
  }
  
  private var iconColor: Color {
    isCorrectAnswer ? .on : .text
  }
  
  private var shadowColor: Color {
    guard hasAnswered else { return .border.opacity(0.5) }
    if isCorrectAnswer { return .on.opacity(0.3) }
    if isSelected && !isCorrectAnswer { return .text.opacity(0.3) }
    
    return .border.opacity(0.2)
  }
}

struct PixeledButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View
  {
    configuration.label
      .offset(x: configuration.isPressed ? 2 : 0, y: configuration.isPressed ? 2 : 0)
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}

struct PixelAnswerButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View
  {
      configuration.label
      .offset(x: configuration.isPressed ? 2 : 0, y: configuration.isPressed ? 2 : 0)
      .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
  }
}
