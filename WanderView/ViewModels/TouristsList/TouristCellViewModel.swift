//
//  TouristCellViewModel.swift
//  WanderView
//
//  Created by Steve Hechio on 17/08/2023.
//

import Foundation

struct TouristCellViewModel: Equatable {
    let id: Int
    let username: String?
    let profilePicture: String?
    let email: String?
    let touristLocation: String = ""
    let createdAt: String = ""
}
