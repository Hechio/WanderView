//
//  TouristsListViewModelTests.swift
//  WanderViewTests
//
//  Created by Steve Hechio on 17/08/2023.
//

import XCTest
@testable import WanderView
import RealmSwift
import Combine

class TouristsListViewModelTests: XCTestCase {
    
    var viewModel: TouristsListViewModel!
    var expectation: XCTestExpectation!

    override func setUpWithError() throws {
        viewModel = TouristsListViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    // Mock data for testing
    let mockTouristData: [Tourist] = [
        Tourist(id: 19, touristName: "John Doe", touristEmail: "emeababel@gmail.com", touristProfilePicture: "http://restapi.adequateshop.com/Media//Images/userimageicon.png", touristLocation: "USA", createdAt: "2020-04-29T20:31:36.1333717"),
        Tourist(id: 20, touristName: "Steve Hechio", touristEmail: "shubham744@gmail.com", touristProfilePicture: "http://restapi.adequateshop.com/Media/Images/1dfa3272-ebf1-40bd-9520-6b1f225cb5a7.png", touristLocation: "USA", createdAt: "2020-04-30T05:05:46.2315675")
    ]

    // Test if cellViewModels are populated after fetching data
    func testFetchData() {
        expectation = XCTestExpectation(description: "Data did load")

        let jsonData = try! JSONEncoder().encode(mockTouristData) // Convert to Data
        viewModel.dataApi = MockDataLoader(mockResponse: .success(jsonData))
        viewModel.delegate = self // Assign a delegate to handle the expectation
        viewModel.fetchData(page: 1)
        
        wait(for: [expectation], timeout: 2)
    }
}

extension TouristsListViewModelTests: TouristsListViewModelDelegate {
    func dataDidLoad() {
        print("dataDidLoad called. Current count: \(viewModel.cellViewModels.count)")
        XCTAssertEqual(viewModel.cellViewModels.count, 10)
        expectation.fulfill()
    }
}

// Mock DataLoader for testing
class MockDataLoader: ApiService {
    var mockResponse: Result<Data, DataApiError>
    
    init(mockResponse: Result<Data, DataApiError>) {
        self.mockResponse = mockResponse
    }
    
    func fetchData<T: Codable>(from endpoint: String) -> Future<T, DataApiError> {
        return Future<T, DataApiError> { promise in
            switch self.mockResponse {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedData))
                } catch {
                    promise(.failure(.decodingError(error as! DecodingError)))
                }
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
}
