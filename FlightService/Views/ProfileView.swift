//
//  ProfileView.swift
//  FlightService
//
//  Created by Сергей on 08.12.2025.
//

import SwiftUI

struct ProfileView: View {
  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  SmartCombinedField()
}

struct SmartCombinedField: View {
  @State private var text1 = ""
  @State private var text2 = ""
  @FocusState private var focusedField: Field?
  @State private var displayText = ""
  
  enum Field {
    case first, second
  }
  
  var body: some View {
    VStack(spacing: 20) {
      // Визуально одно поле
      ZStack {
        TextField("", text: $displayText)
          .disabled(true)
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.blue, lineWidth: 2)
          )
        
        // Невидимые поля для ввода
        VStack(spacing: 0) {
          TextField("", text: $text1)
            .focused($focusedField, equals: .first)
            .opacity(0)
            .frame(width: 0)
            .onChange(of: text1) { _, newValue in
              updateDisplayText()
            }
          
          TextField("", text: $text2)
            .focused($focusedField, equals: .second)
            .opacity(0)
            .frame(width: 0)
            .onChange(of: text2) { _, newValue in
              updateDisplayText()
            }
        }
      }
      .frame(height: 50)
      .contentShape(Rectangle())
      .onTapGesture {
        // При тапе активируем первое поле
        if focusedField == nil {
          focusedField = .first
        }
      }
      
      // Индикатор активного поля
      HStack {
        Button("Поле 1") { focusedField = .first }
        Text("|")
        Button("Поле 2") { focusedField = .second }
      }
      
      // Отладочная информация
      VStack {
        Text("Активно: \(focusedField == .first ? "Первое" : focusedField == .second ? "Второе" : "Ничего")")
        Text("Text1: \(text1)")
        Text("Text2: \(text2)")
      }
    }
    .padding()
  }
  
  private func updateDisplayText() {
    displayText = "\(text1) / \(text2)"
  }
}
