import SwiftUI

struct DetailFlightView: View {
  
  let flight: Flight
  
  var body: some View {
    ScrollView {
      header
      tariffCondition
      VStack(alignment: .leading) {
        Text("\(flight.origin.uppercased()) - \(flight.destination.uppercased())")
          .font(.title3.bold())
        Text("5ч 20мин в пути")
      }
      detailInfo
      
    }
    .background(.gray.opacity(0.3))
    .ignoresSafeArea()
  }
  
  private var detailInfo: some View {
    VStack(alignment: .leading) {
      HStack {
        Image(systemName: "airplane.departure")
        
        VStack(alignment: .leading) {
          Text(flight.airline)
            .font(.title3.bold())
          Text("5ч 20мин в полете")
        }
        Spacer()
        
        Button("Подробнее") {
          
        }
        //.buttonStyle(.borderedProminent)
        .padding(5)
        .background(.gray.opacity(0.3))
        .foregroundStyle(.black)
        .cornerRadius(13)
      }
      
      HStack {
        ZStack {
          Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(maxWidth: 2, maxHeight: .infinity)
            .padding(0)
          VStack {
            Image(systemName: "record.circle.fill")
            Spacer()
            Image(systemName: "record.circle.fill")
          }
        }
        
        VStack(alignment: .leading) {
          Text("\(flight.departureTime)")
            .font(.title3.bold())
          Text("(hello)")
            .font(.caption)
            .foregroundStyle(.black.opacity(0.6))
          
          if let arrivalTime = flight.arrivalTime {
            Text("\(arrivalTime)")
              .font(.title3.bold())
          }
          
          Text("30 dec, bt")
            .font(.caption)
            .foregroundStyle(.black.opacity(0.6))
        }
      }
    }
    .background(.white)
    .cornerRadius(20)
  }
  
  private var header: some View {
    VStack {
      Image(systemName: "banknote")
        .foregroundStyle(Color.green)
      Text("билет из \(flight.origin) в \(flight.destination)")
      //.searchable(text: $search)
    }
  }
  
  private var tariffCondition: some View {
    VStack(alignment: .leading) {
      Text("Условия тарифа")
        .font(.title2.bold())
      
      VStack(alignment: .leading) {
        HStack {
          Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(Color.green)
          Text("Ручная кладь")
        }
        HStack {
          Image(systemName: "xmark")
          Text("Без багажа")
        }
        HStack {
          Image(systemName: "checkmark.circle.fill")
            .foregroundStyle(Color.green)
          Text("Обмен платный")
        }
        HStack {
          Image(systemName: "xmark")
          Text("Без возврата")
        }
      }
    }
    .frame(maxWidth: .infinity)
    .background(.white)
    .cornerRadius(20)
    .padding()
  }
}

#Preview {
  DetailFlightView(flight: .init(airline: "", flightNumber: "", departureTime: .now, arrivalTime: .now, price: 3, origin: "", destination: "", currency: "", isReturn: false, returnTime: .now))
}
