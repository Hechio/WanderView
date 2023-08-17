//
//  TouristsResponse.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation

struct Tourist: Codable {
    let id: Int
    let touristName: String
    let touristEmail: String
    let touristProfilePicture: String?
    let touristLocation: String
    let createdAt: String

    private enum CodingKeys: String, CodingKey {
        case id
        case touristName = "tourist_name"
        case touristEmail = "tourist_email"
        case touristProfilePicture = "tourist_profilepicture"
        case touristLocation = "tourist_location"
        case createdAt = "createdat"
    }
}

struct TouristResponse: Codable {
    let page: Int
    let perPage: Int
    let totalRecord: Int
    let totalPages: Int
    let data: [Tourist]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case totalRecord = "totalrecord"
        case totalPages = "total_pages"
        case data
    }
    
}
