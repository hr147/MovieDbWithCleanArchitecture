//
//  Date+Extension.swift
//  MoviesListing
//
//  Created by Haroon Ur Rasheed on 04/05/2019.
//  Copyright © 2019 Haroon Ur Rasheed. All rights reserved.
//

import Foundation

extension Date {
    enum StringFormat: String {
        case standard = "yyyy-MM-dd"
    }
    
    func string(with format: StringFormat = .standard) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}
