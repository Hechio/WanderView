//
//  NewsFeedCellViewModel.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation
import UIKit

struct NewsFeedCellViewModel: Equatable {
    let id: Int
    let multimediaURLs: [String]
    let username: String?
    let profilePicture: String?
    let title: String?
    let description: String?
    let location: String?
    let date: String
    
    static func ==(lhs: NewsFeedCellViewModel, rhs: NewsFeedCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    func getMultimediaItems() -> [MediaItem] {
        var multimediaItems: [MediaItem] = []
        
        for urlString in multimediaURLs {
            if let url = URL(string: urlString) {
                let mediaType: MediaType
                if ["jpg", "jpeg", "png"].contains(url.pathExtension.lowercased()) {
                    if let imageURL = URL(string: urlString) {
                        mediaType = .image(imageURL)
                    } else {
                        //Handle image loading error
                        continue
                    }
                }
                else if let videoURL = URL(string: urlString), videoURL.host?.contains("youtu.be") == true {
                    let videoID = videoURL.lastPathComponent
                    let youtubeVideoURLString = "https://www.youtube.com/watch?v=\(videoID)"
                    if let youtubeVideoURL = URL(string: youtubeVideoURLString) {
                        mediaType = .video(youtubeVideoURL)
                    } else {
                        continue
                    }
                    
                } else {
                    // Handle unsupported format
                    continue
                }
                
                multimediaItems.append(MediaItem(type: mediaType, value: url))
            }
        }
        
        return multimediaItems
    }
    
    
    
    
    
    func getFormattedDate() -> String{
        return date.formattedStringDate.formattedDate
    }
    
}

enum MediaType {
    case image(URL)
    case video(URL)
}

struct MediaItem {
    let type: MediaType
    let value: Any
}
