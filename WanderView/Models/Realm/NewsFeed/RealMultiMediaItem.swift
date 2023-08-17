//
//  RealMultiMediaItem.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import Foundation
import RealmSwift


class RealmMultimediaItem: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String?
    @Persisted var name: String
    @Persisted var mediaDescription: String?
    @Persisted var url: String
    @Persisted var createAt: String
    
    convenience init(id: Int, name: String,title: String?,mediaDescription: String?,url: String,createAt: String) {
        self.init()
        self.id = id
        self.name = name
        self.title = title
        self.mediaDescription = mediaDescription
        self.url = url
        self.createAt = createAt
    }
}
