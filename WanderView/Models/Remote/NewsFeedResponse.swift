//
//  NewsFeedResponse.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation

struct MultiMedia: Codable {
    let id: Int
    let title: String?
    let name: String
    let description: String?
    let url: String
    let createAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case name
        case description
        case url
        case createAt = "createat"
    }
}

struct User: Codable {
    let userId: Int
    let name: String
    let profilePicture: String
    
    private enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case name
        case profilePicture = "profilepicture"
    }
}

struct FeedItem: Codable {
    let id: Int
    let title: String?
    let description: String?
    let location: String
    let multiMedia: [MultiMedia]
    let createdAt: String
    let user: User
    let commentCount: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case location
        case multiMedia
        case createdAt = "createdat"
        case user
        case commentCount
    }
}

struct FeedResponse: Codable {
    let page: Int
    let perPage: Int
    let totalRecord: Int
    let totalPages: Int
    let data: [FeedItem]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case totalRecord = "totalrecord"
        case totalPages = "total_pages"
        case data
    }
}
