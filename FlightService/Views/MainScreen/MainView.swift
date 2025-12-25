
import SwiftUI

struct MainView: View {
  
  @StateObject var viewModel: MainViewModel
  @FocusState private var isFocused: FocusField?
  
  var body: some View {
    ScrollView {
      LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
        headScrols
        Section(
          header: MainSearchBarView(
            viewModel: viewModel,
            origin: $viewModel.searchData.origin,
            destination: $viewModel.searchData.destination,
            isFocused: $isFocused,
            progress: viewModel.scrollProgress
          )
          .background(animationSearchBar())
        ) {
          PopularDirectionsView(viewModel: .init())
          InterestingContent()
          SalesFlight()
          WeekendFlight()
        }
      }
    }
    .background(.gray.opacity(0.3))
    .ignoresSafeArea()
    //    .onPreferenceChange(ScrollOffsetKey.self) { value in
    //      print("Offset = \(value)")
    //      viewModel.scrollProgress = value
    //    }
    .sheet(isPresented: $viewModel.showFlightResults) {
      FlightView(viewModel: .init())
    }
    .onChange(of: isFocused) { _, newValue in
      if newValue == .origin || newValue == .destination {
        viewModel.showFlightResults = true
      }
    }
  }
  
  @ViewBuilder
  private func animationSearchBar() -> some View {
    GeometryReader { geometry in
      Color.clear
        .onAppear {
          viewModel.searchBarOffset = geometry.frame(in: .global).minY
        }
        .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
          let distanceFromTop = max(0, viewModel.searchBarOffset - newValue)
          let newProgress = min(distanceFromTop / 100, 1.0)
          
          withAnimation(.spring(response: 0.3)) {
            viewModel.scrollProgress = newProgress
          }
        }
    }
  }
  
  @ViewBuilder
  private var headScrols: some View {
    GeometryReader { geometry in
      let offset = geometry.frame(in: .global).minY
      let isScrolled = offset > 0
      let headerHeight = 250 + (isScrolled ? offset : 0)
      ZStack {
        LinearGradient(
          colors: [Color.blue, Color.blue.opacity(0.5), Color.gray.opacity(0.01)],
          startPoint: .top,
          endPoint: .bottom
        )
        .frame(height: headerHeight)
        .offset(y: isScrolled ? -offset : 0)
        
        VStack {
          Text("Тут покупают дешевые авиабилеты")
            .font(.title.bold())
            .foregroundColor(Color.white)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
            .padding(.bottom, 30)
        }
      }
    }
    .frame(height: 150)
  }
}

struct SearchBarOffsetKey: PreferenceKey {
  static var defaultValue: CGFloat = 0
  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = nextValue()
  }
}

#Preview {
  MainView(viewModel: .init())
}

struct MainSearchBarView: View {
  
  @ObservedObject var viewModel: MainViewModel
  
  @Binding var origin: String
  @Binding var destination: String
  @FocusState.Binding var isFocused: FocusField?
  
  let progress: CGFloat
  
  var body: some View {
    ZStack {
      rectangleForTextField
      ZStack {
        RoundedRectangle(cornerRadius: 20)
          .fill(Color.gray.opacity(0.3))
        HStack {
          if viewModel.isSearchBarCollapsed {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.gray)
              .font(.system(size: 20))
              .padding(.leading)
            VStack(spacing: 0) {
              TextField("", text: $origin)
                .focused($isFocused, equals: .origin)
                .opacity(1.0 - progress)
              Divider()
                .padding(.vertical)
                .opacity(1.0 - progress)
              TextField("", text: $destination)
                .focused($isFocused, equals: .destination)
            }
            .opacity(1.0 - progress * 0.5)
            .frame(height: 50 * (1.75 - progress))
          } else {
            HStack {
              Image(systemName: "magnifyingglass")
              TextField("", text: $destination)
                .focused($isFocused, equals: .destination)
                .frame(height: 50)
            }
            .opacity((progress - 0.7) * 3.3)
          }
        }
      }
      .padding(EdgeInsets(top: 60, leading: 10 * (1.5 - progress), bottom: 10 * (1.5 - progress), trailing: 10 * (1.5 - progress)))
    }
    .padding(.horizontal, 20 - (20 * progress))
    .animation(.spring(response: 0.3), value: progress)
  }
  
  private var rectangleForTextField: some View {
    RoundedRectangle(cornerRadius: 20)
      .fill(Color.white)
      .shadow(
        color: .black.opacity(viewModel.shadowColor),
        radius: viewModel.shadowRadius,
        x: 0,
        y: viewModel.fromY
      )
  }
}


//  private var header: some View {
//    ZStack {
//      headScrols
//      searchBar
//    }
//    .padding(.bottom, 100)
//  }

// @ViewBuilder
//  private var searchBar: some View {
//    ZStack {
//      RoundedRectangle(cornerRadius: 20)
//        .fill(Color.white)
//        .shadow(
//          color: .black.opacity(interpolate(from: 0.3, to: 0.1, progress: progress)),
//          radius: interpolate(from: 4, to: 9, progress: progress),
//          x: 0,
//          y: interpolate(from: 2, to: 4, progress: progress)
//        )
//      ZStack {
//        RoundedRectangle(cornerRadius: 20)
//          .fill(Color.gray.opacity(0.3))
//        HStack {
//          if progress < 0.8 {
//            Image(systemName: "magnifyingglass")
//              .foregroundColor(.gray)
//              .font(.system(size: 20))
//              .padding(.leading)
//            VStack(spacing: 0) {
//              TextField("", text: $text)
//                .focused($isFocused, equals: .origin)
//                .opacity(1.0 - progress)
//              Divider()
//                .padding(.vertical)
//                .opacity(1.0 - progress)
//              TextField("", text: $text2)
//            }
//            .opacity(1.0 - progress * 0.5)
//            .frame(height: 50 * (1.75 - progress))
//          } else {
//            HStack {
//              Image(systemName: "magnifyingglass")
//              TextField("", text: $text2)
//                .focused($isFocused, equals: .destination)
//                .frame(height: 50)
//            }
//            .opacity((progress - 0.7) * 3.3)
//          }
//        }
//      }
//      .padding(EdgeInsets(top: 60, leading: 10 * (1.5 - progress), bottom: 5 * (1 - progress), trailing: 10 * (1.5 - progress)))
//    }
//    .padding(.horizontal, 20 - (20 * progress))
//    .animation(.spring(response: 0.3), value: progress)
//  }
