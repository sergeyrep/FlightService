import SwiftUI

struct SearchTextField: View {
  let title: String
  let icon: IconField
  @Binding var text: String
  let suggestions: [CitySuggestion]
  let field: SearchField
  @FocusState.Binding var focusedField: SearchField?
  let onSuggestionSelect: (CitySuggestion) -> Void
  
  private var isFocused: Bool {
    focusedField == field
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: icon.rawValue)
          .padding(8)
        TextField(title, text: $text)
          .focused($focusedField, equals: field)
          .padding(10)          
      }
      
      if isFocused && !suggestions.isEmpty {
        SuggestionsList(
          suggestions: suggestions,
          onSelect: { suggestion in
            text = suggestion.code
            onSuggestionSelect(suggestion)
            focusedField = nil
          }
        )
      }
    }
  }
}

//onSelect: { suggestion in
//                text.wrappedValue = suggestion.code
//                viewModel.suggestionsDestination = []
//                focusedField = nil
//                onSelect(suggestion)
//            }
