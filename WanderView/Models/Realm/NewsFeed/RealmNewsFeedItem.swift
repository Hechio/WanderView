//
//  RealmNewsFeedItem.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation
import RealmSwift


class RealmNewsFeedItem: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var multimediaURLs: List<RealmMultimediaItem>
    @Persisted var username: String?
    @Persisted var userId: Int
    @Persisted var profilePicture: String?
    @Persisted var title: String?
    @Persisted var feedDescription: String?
    @Persisted var location: String?
    @Persisted var date: String
    @Persisted var commentCount: Int
        
}


