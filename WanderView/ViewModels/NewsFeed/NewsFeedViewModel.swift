//
//  NewsFeedViewModel.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation
import Combine
import RealmSwift

protocol NewsFeedViewModelDelegate: AnyObject {
    func dataDidLoad()
}


class NewsFeedViewModel : ObservableObject {
    weak var delegate: NewsFeedViewModelDelegate?
    
    private var subscriptions = Set<AnyCancellable>()
    var dataApi = DataLoader.shared
    private var currentPage = 1
    private var totalPages = 1
    private var isFetchingNextPage = false
    
    @Published var cellViewModels: [NewsFeedCellViewModel] = []
    
    init() {
        if NetworkConnectivity.shared.isReachable() {
            fetchData(page: 1) // Fetch initial data
        } else {
            let persistedData = fetchPersistedData()
            self.cellViewModels = createCellViewModels(from: persistedData)
        }
    }
    
    // MARK: - Fetch Data
    
    // Fetch data through the API
    
    func fetchData(page: Int) {
        dataApi.fetchData(from: Endpoint.newsFeed.rawValue + "?page=\(page)")
            .sink { [unowned self] completion in
                if case let .failure(error) = completion {
                    self.handleError(error)
                }
            }
    receiveValue: { [unowned self]  in
        let newsFeed: FeedResponse = $0
        self.totalPages = newsFeed.totalPages
        self.currentPage = newsFeed.page
        
        self.persistData(newsFeed.data)
        
        let newViewModels = self.createCellViewModels(from: newsFeed.data)
        
        self.cellViewModels.append(contentsOf: newViewModels)
        delegate?.dataDidLoad()
    }
    .store(in: &self.subscriptions)
    }
    
    // Create CellViewModels from the data response
    func createCellViewModels(from resultsArray: [FeedItem]) -> [NewsFeedCellViewModel] {
        
        var viewModels: [NewsFeedCellViewModel] = []
        
        for result in resultsArray {
            let cellViewModel = buildCellModel(from: result)
            viewModels.append(cellViewModel)
        }
        
        return viewModels
    }
    
    func buildCellModel(from newsFeed : FeedItem) -> NewsFeedCellViewModel {
        return NewsFeedCellViewModel(id: newsFeed.id, multimediaURLs: newsFeed.multiMedia.map { $0.url }, username: newsFeed.user.name, profilePicture: newsFeed.user.profilePicture, title: newsFeed.title, description: newsFeed.description, location: newsFeed.location, date: newsFeed.createdAt)
    }
    
    // Return a CellViewModel for the current IndexPath
    func getCellViewModel(at indexPath: IndexPath) -> NewsFeedCellViewModel {
        print("here 3")
        return cellViewModels[indexPath.row]
    }
    
    
    // MARK: - Handle errors
    
    func handleError(_ apiError: DataApiError) {
        print("ERROR: \(apiError.localizedDescription)!!!!!")
    }
    
    
    private func persistData(_ feedItems: [FeedItem]) {
        do {
            let realm = try Realm(configuration: config)
            try realm.write {
                for feedItem in feedItems {
                    let realmItem = RealmNewsFeedItem()
                    realmItem.id = feedItem.id
                    let realmMultimediaItems: [RealmMultimediaItem] = feedItem.multiMedia.map { media in
                        return RealmMultimediaItem(id: media.id, name: media.name, title: media.title, mediaDescription: media.description, url: media.url, createAt: media.createAt)
                    }
                    realmItem.multimediaURLs.append(objectsIn: realmMultimediaItems)
                    realmItem.userId = feedItem.user.userId
                    realmItem.username = feedItem.user.name
                    realmItem.profilePicture = feedItem.user.profilePicture
                    realmItem.title = feedItem.title
                    realmItem.feedDescription = feedItem.description
                    realmItem.location = feedItem.location
                    realmItem.date = feedItem.createdAt
                    realmItem.commentCount = feedItem.commentCount
                    realm.add(realmItem, update: .modified)
                }
            }
        } catch {
            print("Realm error: \(error)")
        }
    }
    
    private func fetchPersistedData() -> [FeedItem] {
        do {
            let realm = try Realm()
            let persistedItems = realm.objects(RealmNewsFeedItem.self)
            return persistedItems.compactMap { realmItem in
                let multimedia: [MultiMedia] = realmItem.multimediaURLs.map { realmMedia in
                    return MultiMedia(id: realmMedia.id, title: realmMedia.title, name: realmMedia.name, description: realmMedia.mediaDescription, url: realmMedia.url, createAt: realmMedia.createAt)
                            }
                return FeedItem(id: realmItem.id, title: realmItem.title ?? "", description: realmItem.feedDescription ?? "", location: realmItem.location ?? "", multiMedia: multimedia, createdAt: realmItem.date, user: User(userId: realmItem.userId, name: realmItem.username ?? "", profilePicture: realmItem.profilePicture ?? ""), commentCount: realmItem.commentCount)
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

