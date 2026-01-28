import SwiftUI
import Combine

struct DetailPopularFlightView: View {
  
  let cityCode: String
  let cityName: String
  
  var body: some View {
    ScrollView {
      VStack(spacing: 0) {
        PhotoCityView(
          cityCode: cityCode,
        )
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        
        Text(cityName)
          .frame(maxHeight: .infinity)
      }
    }
    .ignoresSafeArea(edges: .top)
  }
}

#Preview {
  DetailPopularFlightView(cityCode: "MOW", cityName: "MOSCOW")
}

final class DetailPopularFlightViewModel: ObservableObject {
  
}
