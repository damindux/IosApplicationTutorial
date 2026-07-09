//
//  PixelDatePicker.swift
//  IosTutorial
//
//  Created by Student3 on 2026-07-09.
//

import SwiftUI

struct PixelDatePicker: View {
  let title: String
  @Binding var time: Date
  
  @State private var showPicker = false
  
  private let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter
  }()
  
  var body: some View {
    HStack {
      Text(title)
        .font(Font.custom("Pixelify Sans", size: 18))
        .foregroundStyle(.text)
      
      Spacer()
      
      // Display button
      Button {
        withAnimation(.easeInOut(duration: 0.15)) {
          showPicker.toggle()
        }
      } label: {
        Text(timeFormatter.string(from: time))
          .font(Font.custom("Pixelify Sans", size: 18))
          .foregroundStyle(.text)
          .frame(width: 100, height: 36)
          .background(.sectionBg)
          .overlay(
            Rectangle()
              .stroke(.border, lineWidth: 2)
          )
      }
    }
    .sheet(isPresented: $showPicker) {
      PixelTimePickerSheet(time: $time, isPresented: $showPicker)
    }
  }
}

struct PixelTimePickerSheet: View {
  @Binding var time: Date
  @Binding var isPresented: Bool
  
  @State private var selectedHour: Int
  @State private var selectedMinute: Int
  @State private var isAM: Bool
  
  init(time: Binding<Date>, isPresented: Binding<Bool>) {
    self._time = time
    self._isPresented = isPresented
    
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour, .minute], from: time.wrappedValue)
    let hour = components.hour ?? 0
    self._selectedHour = State(initialValue: hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour))
    self._selectedMinute = State(initialValue: components.minute ?? 0)
    self._isAM = State(initialValue: hour < 12)
  }
  
  var body: some View {
    VStack(spacing: 32) {
      Text("Select Time")
        .font(Font.custom("Pixelify Sans", size: 28))
        .foregroundStyle(.text)
      
      HStack(spacing: 8) {
        PixelWheel(
          value: $selectedHour,
          range: 1...12,
          label: "Hour"
        )
        
        Text(":")
          .font(Font.custom("Pixelify Sans", size: 32))
          .foregroundStyle(.text)
        
        PixelWheel(
          value: $selectedMinute,
          range: 0...59,
          label: "Min"
        )
        
        VStack(spacing: 4) {
          PixelButton(title: "AM", isSelected: isAM) {
            isAM = true
          }
          PixelButton(title: "PM", isSelected: !isAM) {
            isAM = false
          }
        }
      }
      
      HStack(spacing: 16) {
        Button("Cancel") {
          isPresented = false
        }
        .pixelButtonStyle(color: .sectionBg)
        
        Button("Set") {
          var hour = selectedHour
          if hour == 12 {
            hour = isAM ? 0 : 12
          } else if !isAM {
            hour += 12
          }
          
          let calendar = Calendar.current
          var components = calendar.dateComponents([.year, .month, .day], from: Date())
          components.hour = hour
          components.minute = selectedMinute
          
          if let newTime = calendar.date(from: components) {
            time = newTime
          }
          isPresented = false
        }
        .pixelButtonStyle(color: .on)
      }
    }
    .padding(32)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.bg)
  }
}

struct PixelWheel: View {
  @Binding var value: Int
  let range: ClosedRange<Int>
  let label: String
  
  var body: some View {
    VStack(spacing: 4) {
      Button {
        withAnimation(.easeInOut(duration: 0.1)) {
          value = value == range.upperBound ? range.lowerBound : value + 1
        }
      } label: {
        Image(systemName: "chevron.up")
          .font(.system(size: 20, weight: .bold))
          .foregroundStyle(.text)
          .frame(width: 64, height: 32)
          .background(.sectionBg)
          .overlay(Rectangle().stroke(.border, lineWidth: 2))
      }
      
      Text(String(format: "%02d", value))
        .font(Font.custom("Pixelify Sans", size: 32))
        .foregroundStyle(.on)
        .frame(width: 64, height: 48)
        .background(.bg)
        .overlay(Rectangle().stroke(.border, lineWidth: 2))
      
      Button {
        withAnimation(.easeInOut(duration: 0.1)) {
          value = value == range.lowerBound ? range.upperBound : value - 1
        }
      } label: {
        Image(systemName: "chevron.down")
          .font(.system(size: 20, weight: .bold))
          .foregroundStyle(.text)
          .frame(width: 64, height: 32)
          .background(.sectionBg)
          .overlay(Rectangle().stroke(.border, lineWidth: 2))
      }
      
      Text(label)
        .font(Font.custom("Pixelify Sans", size: 12))
        .foregroundStyle(.text.opacity(0.7))
    }
  }
}

struct PixelButton: View {
  let title: String
  let isSelected: Bool
  let action: () -> Void
  
  var body: some View {
    Button(action: action) {
      Text(title)
        .font(Font.custom("Pixelify Sans", size: 16))
        .foregroundStyle(isSelected ? .text : .text.opacity(0.5))
        .frame(width: 56, height: 32)
        .background(isSelected ? .on : .sectionBg)
        .overlay(Rectangle().stroke(.border, lineWidth: 2))
    }
  }
}

struct PixelButtonStyle: ButtonStyle {
  let color: Color
  
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(Font.custom("Pixelify Sans", size: 18))
      .foregroundStyle(.text)
      .padding(.horizontal, 24)
      .padding(.vertical, 12)
      .background(color)
      .overlay(
        Rectangle()
          .stroke(.border, lineWidth: 2)
          .offset(x: configuration.isPressed ? 2 : 0, y: configuration.isPressed ? 2 : 0)
      )
      .offset(x: configuration.isPressed ? 2 : 0, y: configuration.isPressed ? 2 : 0)
  }
}

