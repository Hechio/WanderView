//
//  DataLoader.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation
import Combine

class DataLoader: ApiService {
    
    // MARK: - Properties
    
    static let shared = DataLoader()
    private let baseApiURL = "http://restapi.adequateshop.com"
    private let urlSession = URLSession.shared
    private var subscriptions = Set<AnyCancellable>()
    
    private let jsonDecoder: JSONDecoder = {
      let jsonDecoder = JSONDecoder()
      return jsonDecoder
    }()
    
    
    private init() {}
    
    // MARK: - ApiService protocol
    func fetchData<T: Codable>(from endpoint: String) -> Future<T, DataApiError> {
        
        return Future<T,  DataApiError> { [unowned self] promise in
          guard let url = self.createURL(with: endpoint)
          else {
            return promise(.failure(.urlError(URLError(.unsupportedURL))))
          }
          
    
          self.urlSession.dataTaskPublisher(for: url)
            .tryMap { (data, response) -> Data in
                print("Received Data: \(String(data: data, encoding: .utf8) ?? "Invalid UTF-8 data")")
                    
              guard let httpResponse = response as? HTTPURLResponse,
                    200...299 ~= httpResponse.statusCode
              else {
                throw  DataApiError.responseError(
                  (response as? HTTPURLResponse)?.statusCode ?? 500)
              }
              return data
            }
            .decode(type: T.self,
                    decoder: self.jsonDecoder)
            .receive(on: RunLoop.main)
            .sink { completion in
              if case let .failure(error) = completion {
                switch error {
                  case let urlError as URLError:
                    promise(.failure(.urlError(urlError)))
                  case let decodingError as DecodingError:
                    promise(.failure(.decodingError(decodingError)))
                  case let apiError as  DataApiError:
                    promise(.failure(apiError))
                  default:
                    promise(.failure(.anyError))
                }
              }
            }
          receiveValue: {
            promise(.success($0))
          }
        .store(in: &self.subscriptions)
          
        }
    }
    
    
    // MARK: - Create Endpoint
    
    private func createURL(with endpoint: String) -> URL? {
      
      guard let urlComponents = URLComponents(string: "\(baseApiURL)/\(endpoint)")
      else { return nil }
      
      return urlComponents.url
    }
}
