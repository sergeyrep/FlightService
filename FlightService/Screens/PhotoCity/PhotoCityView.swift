import SwiftUI

struct PhotoCityView: View {
  
  let cityCode: String
 
  private var fotoURL: URL? {
    URL(string: "https://photo.hotellook.com/static/cities/960x720/\(cityCode).jpg")
  }
  
  var body: some View {
    VStack {
      AsyncImage(url: fotoURL) { phase in
        Group {
          switch phase {
          case .success(let image):
            image
              .resizable()
              .cornerRadius(20)
          case .failure:
            Image(systemName: "person.fill")
              .resizable()
              .cornerRadius(20)
          case .empty:
            ProgressView()
              .cornerRadius(20)
          @unknown default:
            EmptyView()
          }
        }
      }
    }
  }
}

//#Preview {
//  PhotoCityView(viewModel: .init(), direction: .init(origin: "MOW", destination: "KJA", price: 1300), cityName: "KRSK", photoSize: 150, cityNameNew: .name)
//}
