//
//  TouristsListViewModel.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import Foundation
import Combine
import RealmSwift


protocol TouristsListViewModelDelegate: AnyObject {
    func dataDidLoad()
}

class TouristsListViewModel: ObservableObject {
    weak var delegate: TouristsListViewModelDelegate?
    
    private var subscriptions = Set<AnyCancellable>()
    var dataApi: ApiService = DataLoader.shared
    private var currentPage = 1
    private var totalPages = 1
    private var isFetchingNextPage = false

    
    @Published var cellViewModels: [TouristCellViewModel] = []
    
    init(){
        fetchData(page: 1) // Fetch initial data
        //let persistedData = fetchPersistedData()
//        if persistedData.isEmpty {
//            fetchData(page: 1) // Fetch initial data
//        } else {
//            self.cellViewModels = createCellViewModels(from: persistedData)
//        }
    }
    
    func fetchData(page: Int) {
        dataApi.fetchData(from: Endpoint.tourists.rawValue + "?page=\(page)")
            .sink { [unowned self] completion in
                if case let .failure(error) = completion {
                    self.handleError(error)
                }
            }
    receiveValue: { [unowned self]  in
        let tourist: TouristResponse = $0
        self.totalPages = tourist.totalPages
        self.currentPage = tourist.page
        
        self.persistData(tourist.data)
        
        let newViewModels = self.createCellViewModels(from: tourist.data)
                        
        self.cellViewModels.append(contentsOf: newViewModels)
        delegate?.dataDidLoad()
    }
    .store(in: &self.subscriptions)
    }
    
    // Create CellViewModels from the data response
    func createCellViewModels(from resultsArray: [Tourist]) -> [TouristCellViewModel] {
        
        var viewModels: [TouristCellViewModel] = []
        
        for result in resultsArray {
            let cellViewModel = buildCellModel(from: result)
            viewModels.append(cellViewModel)
        }
        
        return viewModels
    }
    
    func buildCellModel(from tourist : Tourist) -> TouristCellViewModel {
        return TouristCellViewModel(id: tourist.id, username: tourist.touristName, profilePicture: tourist.touristProfilePicture, email: tourist.touristEmail)
    }
    
    // Return a CellViewModel for the current IndexPath
    func getCellViewModel(at indexPath: IndexPath) -> TouristCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    
    // MARK: - Handle errors
    
    func handleError(_ apiError: DataApiError) {
        print("ERROR: \(apiError.localizedDescription)!!!!!")
    }
    
    
    private func persistData(_ tourists: [Tourist]) {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                for tourist in tourists{
                    let realmItem = RealmTourist()
                    realmItem.id = tourist.id
                    realmItem.touristName = tourist.touristName
                    realmItem.touristEmail = tourist.touristEmail
                    realmItem.touristProfilePicture = tourist.touristProfilePicture ?? ""
                    realmItem.touristLocation = tourist.touristLocation
                    realmItem.createdAt = tourist.createdAt
                    realm.add(realmItem, update: .modified)
                }
            }
        } catch {
            print("Realm error: \(error)")
        }
    }
    
    private func fetchPersistedData() -> [Tourist] {
        do {
            let realm = try Realm()
            let persistedItems = realm.objects(RealmTourist.self)
            return persistedItems.compactMap { realmItem in

                return Tourist(id: realmItem.id, touristName: realmItem.touristName, touristEmail: realmItem.touristEmail, touristProfilePicture: realmItem.touristProfilePicture, touristLocation: realmItem.touristLocation, createdAt: realmItem.createdAt)
            }
        } catch {
            print("Realm error: \(error)")
            return []
        }
    }
    
    func fetchNextPage() {
        guard !isFetchingNextPage, currentPage < totalPages else {
            return
        }

        isFetchingNextPage = true
        let nextPage = currentPage + 1
        fetchData(page: nextPage)
        isFetchingNextPage = false
    }
    

    
}



