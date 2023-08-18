//
//  TouristProfileViewModel.swift
//  WanderView
//
//  Created by Steve Hechio on 18/08/2023.
//

import Foundation
import Combine

class TouristProfileViewModel: ObservableObject {
    private var subscriptions = Set<AnyCancellable>()
    var dataApi: ApiService = DataLoader.shared
    @Published var tourist: Tourist?
    
    
    func fetchData(id: Int) {
        dataApi.fetchData(from: Endpoint.tourists.rawValue + "/\(id)")
            .sink { [unowned self] completion in
                if case let .failure(error) = completion {
                    self.handleError(error)
                }
            }
    receiveValue: { [unowned self]  in
        let tourist: Tourist = $0
        self.tourist = tourist
       
    }
    .store(in: &self.subscriptions)
    }
    
    func handleError(_ apiError: DataApiError) {
        print("ERROR: \(apiError.localizedDescription)!!!!!")
    }
}
