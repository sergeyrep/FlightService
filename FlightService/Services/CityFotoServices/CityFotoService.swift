//
//  CityFotoServices.swift
//  FlightService
//
//  Created by Сергей on 21.12.2025.
//

import Foundation
//import SwiftUI
import UIKit
import SwiftUI

protocol CityFotoServiceProtocol {
  func sendRequestForCityFoto(cityCode: String) async throws -> UIImage
}

final class CityFotoServices: CityFotoServiceProtocol {
 
  private let networkService: NetworkServiceProtocol
  private let baseURL = "https://photo.hotellook.com"
  
  init(networkService: NetworkServiceProtocol = NetworkService()) {
    self.networkService = networkService
  }
  
  func sendRequestForCityFoto(cityCode: String) async throws -> UIImage {
    
    let endpoint: EndpointProtocol = ApiMethod.fetchFotoCity(cityCode: cityCode)
    
    do {
      let response = try await networkService.fetchFoto(endpoint, baseURL: baseURL)
      
      guard let image = UIImage(data: response) else {
        throw NetworkServiceError.decodingError
      }
      
      return image
      
    } catch {
      print("No foto city")
      throw error
    }
  }
}

struct FotoCotyes: Codable {
  let url: String
}

//GET https://photo.hotellook.com/static/cities/960x720/LED.jpg https://photo.hotellook.com/static/cities/960x720/MOW.jpg
