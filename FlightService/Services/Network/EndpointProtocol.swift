//
//  EndpointProtocol.swift
//  FlightService
//
//  Created by Сергей on 28.11.2025.
//

import Foundation

protocol EndpointProtocol {
  var httpMethod: HTTPMethod { get }
  var path: String { get }
  var queryItems: [String: Any] { get }
}
