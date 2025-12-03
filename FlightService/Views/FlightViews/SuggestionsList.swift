//
//  SwiftUIView.swift
//  FlightService
//
//  Created by Сергей on 01.12.2025.
//

import SwiftUI

struct SuggestionsList: View {
  let suggestions: [CitySuggestion]
  let onSelect: (CitySuggestion) -> Void
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(suggestions, id: \.self) { suggestion in
        Button {
          onSelect(suggestion)
        } label: {
          VStack(alignment: .leading) {
            Text(suggestion.name)
              .font(.headline)
            Text("\(suggestion.code) • \(suggestion.countryName)")
              .font(.caption)
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.vertical, 8)
          .padding(.horizontal, 12)
        }
        .buttonStyle(.plain)
        
        Divider()
      }
    }
    .background(Color(.systemBackground))
    .cornerRadius(8)
    .shadow(radius: 2)
    .padding(.horizontal)
  }
}
