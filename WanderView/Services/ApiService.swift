//
//  ApiService.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation
import Combine

protocol ApiService {
    
    func fetchData<T: Codable>(from endpoint: String) -> Future<T, DataApiError>
    
}


enum Endpoint: String {
  case newsFeed = "api/Feed/GetNewsFeed"
  case tourists = "api/Tourist"
}
