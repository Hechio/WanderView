//
//  RealmTourist.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import Foundation
import RealmSwift


class RealmTourist: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var touristName: String
    @Persisted var touristEmail: String
    @Persisted var touristProfilePicture: String
    @Persisted var touristLocation: String
    @Persisted var createdAt: String
}
