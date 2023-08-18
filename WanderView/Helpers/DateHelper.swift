//
//  DateHelper.swift
//  WanderView
//
//  Created by Steve Hechio on 16/08/2023.
//

import Foundation

extension DateFormatter {
    static let customFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()
}

extension Date {
    var formattedDate: String {
        return DateFormatter.customFormatter.string(from: self)
    }
    
    static func formattedString(from dateString: String) -> String? {
            let inputFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
            let outputFormat = "dd MMM yyyy 'at' HH:mm"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat
            if let date = dateFormatter.date(from: dateString) {
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = outputFormat
                return outputFormatter.string(from: date)
            }
            return nil
        }
}

extension String {
    var formattedStringDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS"
        return dateFormatter.date(from: self) ?? Date.now
    }
}
