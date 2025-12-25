
import Foundation
import Combine
import SwiftUI

enum FocusField {
  case origin
  case destination
}

struct FlightSearchData {
  var origin: String = ""
  var destination: String = ""
}

final class MainViewModel: ObservableObject {
  
  @Published var searchData = FlightSearchData()
  @Published var focusedField: FocusField?
  @Published var showFlightResults = false
  
  @Published var scrollProgress: CGFloat = 0
  @Published var searchBarOffset: CGFloat = 0
  
  
  private let collapseThreshold: CGFloat = 0.8
  private let animationDuration: Double = 0.3
  
  var shadowRadius: CGFloat {
    interpolate(from: 4, to: 8, progress: scrollProgress)
  }
  
  var shadowColor: CGFloat {
    interpolate(from: 0.3, to: 0.1, progress: scrollProgress)
  }
  
  var fromY: CGFloat {
    interpolate(from: 2, to: 4, progress: scrollProgress)
  }
  
  var shadowOffsetY: CGFloat {
    interpolate(from: 4, to: 8, progress: scrollProgress)
  }
  
  var isSearchBarCollapsed: Bool {
    scrollProgress <= collapseThreshold
  }
  
  var searchBarPadding: CGFloat {
    interpolate(from: 20, to: 10, progress: scrollProgress)
  }
  
  var searchBarHeight: CGFloat {
    interpolate(from: 110, to: 60, progress: scrollProgress)
  }
  
  private func interpolate(from: CGFloat, to: CGFloat, progress: CGFloat) -> CGFloat {
    from + (to - from) * min(max(progress, 0), 1)
  }
}
