//
//  QuizSetupView.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-11.
//

import SwiftUI

struct QuizSetupView: View {
  @State private var selectedCategory: QuizCategory = .general
  @State private var selectedDifficulty: QuizDifficulty = .medium
  @State private var questionCount: Double = 10
  
  @State private var isStarting = false
  
  var body: some View {
    NavigationStack {
      ZStack {
        Color.bg.ignoresSafeArea()
        pixelBackground
        
        ScrollView {
          VStack(spacing: 0) {
            titleSection
              .padding(.top, 60)
              .padding(.bottom, 40)
            
            VStack(spacing: 24) {
              categorySection
              difficultySection
              questionCountSection
            }
            .padding(.horizontal, 24)
            
            startButton
              .padding(.top, 40)
              .padding(.bottom, 40)
          }
        }
      }
      .navigationTitle("")
    }
    .navigationDestination(isPresented: $isStarting) {
      QuizView(
        viewModel: QuizVM(
          service: QuizService(),
          category: selectedCategory,
          difficulty: selectedDifficulty,
          amount: Int(questionCount)
        )
      )
    }
    .onAppear {
      NavigationRouter.shared.enterGame()
    }
    .onDisappear {
      NavigationRouter.shared.exitGame()
    }
  }
  
  private var titleSection: some View {
    VStack(spacing: 8) {
      ZStack {
        Text("QUIZ SETUP")
          .font(Font.custom("Pixelify Sans", size: 42))
          .foregroundStyle(.border)
          .offset(x: 3, y: 3)
        
        Text("QUIZ SETUP")
          .font(Font.custom("Pixelify Sans", size: 42))
          .foregroundStyle(.text)
      }
      
      Text("Customize your challenge")
        .font(Font.custom("Pixelify Sans", size: 16))
        .foregroundStyle(.title.opacity(0.8))
    }
  }
  
  private var categorySection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("CATEGORY")
        .font(Font.custom("Pixelify Sans", size: 14))
        .foregroundStyle(.title.opacity(0.7))
      
      HStack(spacing: 12) {
        spinnerButton(icon: "chevron.left") {
          withAnimation(.easeInOut(duration: 0.15)) {
            selectedCategory = previousCategory()
          }
        }
        
        HStack {
          Spacer()
          Text(selectedCategory.displayName)
            .font(Font.custom("Pixelify Sans", size: 18))
            .foregroundStyle(.bg)
          Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(.on)
        .overlay(
          Rectangle()
            .stroke(.text, lineWidth: 2)
        )
        
        spinnerButton(icon: "chevron.right") {
          withAnimation(.easeInOut(duration: 0.15)) {
            selectedCategory = nextCategory()
          }
        }
      }
    }
  }
  
  private func spinnerButton(icon: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
      Image(systemName: icon)
        .font(.system(size: 18, weight: .bold))
        .foregroundStyle(.text)
        .frame(width: 44, height: 44)
        .background(.sectionBg)
        .overlay(
          Rectangle()
            .stroke(.border, lineWidth: 2)
        )
    }
    .buttonStyle(PixeledButtonStyle())
  }
  
  private func previousCategory() -> QuizCategory {
    let all = QuizCategory.allCases
    guard let currentIndex = all.firstIndex(of: selectedCategory) else {
      return selectedCategory
    }
    let newIndex = currentIndex == 0 ? all.count - 1 : currentIndex - 1
    return all[newIndex]
  }
  
  private func nextCategory() -> QuizCategory {
    let all = QuizCategory.allCases
    guard let currentIndex = all.firstIndex(of: selectedCategory) else {
      return selectedCategory
    }
    let newIndex = (currentIndex + 1) % all.count
    return all[newIndex]
  }
  
  private var difficultySection: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("DIFFICULTY")
        .font(Font.custom("Pixelify Sans", size: 14))
        .foregroundStyle(.title.opacity(0.7))
      
      HStack(spacing: 8) {
        ForEach(QuizDifficulty.allCases, id: \.self) { difficulty in
          difficultyButton(difficulty)
        }
      }
    }
  }
  
  private func difficultyButton(_ difficulty: QuizDifficulty) -> some View
  {
    let isSelected = selectedDifficulty == difficulty
    
    return Button {
      withAnimation(.easeInOut(duration: 0.15)) {
        selectedDifficulty = difficulty
      }
    } label: {
      Text(difficulty.displayName)
        .font(Font.custom("Pixelify Sans", size: 16))
        .foregroundStyle(isSelected ? .bg : .text)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(isSelected ? difficultyColor(difficulty) : .sectionBg)
        .overlay(
          Rectangle()
            .stroke(isSelected ? .text : .border, lineWidth: 2)
        )
    }
    .buttonStyle(PixeledButtonStyle())
  }
  
  private func difficultyColor(_ difficulty: QuizDifficulty) -> Color
  {
    switch difficulty {
    case .easy: return .title
    case .medium: return .on
    case .hard: return .text
    }
  }
  
  private var questionCountSection: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack {
        Text("QUESTIONS")
          .font(Font.custom("Pixelify Sans", size: 14))
          .foregroundStyle(.title.opacity(0.7))
        
        Spacer()
        
        Text("\(Int(questionCount))")
          .font(Font.custom("Pixelify Sans", size: 28))
          .foregroundStyle(.on)
          .monospacedDigit()
          .frame(width: 50)
      }
      
      HStack(spacing: 16) {
        Button {
          withAnimation(.easeInOut(duration: 0.1)) {
            questionCount = max(5, questionCount - 5)
          }
        } label: {
          Image(systemName: "minus")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.text)
            .frame(width: 44, height: 44)
            .background(.sectionBg)
            .overlay(
              Rectangle()
                .stroke(.border, lineWidth: 2)
            )
        }
        .buttonStyle(PixeledButtonStyle())
        
        GeometryReader { geo in
          ZStack(alignment: .leading) {
            Rectangle()
              .fill(.sectionBg)
              .overlay(
                Rectangle()
                  .stroke(.border, lineWidth: 1)
              )
            
            Rectangle()
              .fill(.on.opacity(0.6))
              .frame(width: geo.size.width * CGFloat(questionCount - 5) / 45)
          }
        }
        .frame(height: 20)
        
        Button {
          withAnimation(.easeInOut(duration: 0.1)) {
            questionCount = min(50, questionCount + 5)
          }
        } label: {
          Image(systemName: "plus")
            .font(.system(size: 20, weight: .bold))
            .foregroundStyle(.text)
            .frame(width: 44, height: 44)
            .background(.sectionBg)
            .overlay(
              Rectangle()
                .stroke(.border, lineWidth: 2)
            )
        }
        .buttonStyle(PixeledButtonStyle())
      }
    }
  }
  
  private var startButton: some View {
    Button {
      isStarting = true
    } label: {
      HStack(spacing: 12) {
        Text("START QUIZ")
          .font(Font.custom("Pixelify Sans", size: 24))
        
        Image(systemName: "arrow.right")
          .font(.system(size: 20, weight: .bold))
      }
      .foregroundStyle(.bg)
      .frame(maxWidth: .infinity)
      .padding(.vertical, 16)
      .background(.on)
      .overlay(
        Rectangle()
          .stroke(.text, lineWidth: 2)
      )
      .background(
        Rectangle()
          .fill(.border.opacity(0.5))
          .offset(x: 4, y: 4)
      )
    }
    .buttonStyle(PixeledButtonStyle())
    .padding(.horizontal, 24)
  }
  
  private var pixelBackground: some View {
    GeometryReader { geo in
      let spacing: CGFloat = 60
      let rows = Int(geo.size.height / spacing) + 1
      let cols = Int(geo.size.width / spacing) + 1
      
      pixelGrid(rows: rows, cols: cols, spacing: spacing)
    }
    .ignoresSafeArea()
  }
  
  @ViewBuilder
  private func pixelGrid(rows: Int, cols: Int, spacing: CGFloat) -> some View
  {
    VStack(spacing: spacing) {
      ForEach(0..<rows, id: \.self) { row in
        pixelRow(row: row, cols: cols, spacing: spacing)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  private func pixelRow(row: Int, cols: Int, spacing: CGFloat) -> some View
  {
    HStack(spacing: spacing) {
      ForEach(0..<cols, id: \.self) { col in
        pixelDot(row: row, col: col)
      }
    }
  }
  
  private func pixelDot(row: Int, col: Int) -> some View
  {
    let isVisible = (row + col) % 3 == 0
    return Rectangle()
      .fill(.on.opacity(isVisible ? 0.06 : 0))
      .frame(width: 4, height: 4)
  }
}

#Preview {
  QuizSetupView()
}
