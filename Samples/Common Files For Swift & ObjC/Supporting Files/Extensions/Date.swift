//
//  Date.swift
//  PayUNativeOtpAssistSwiftSample
//
//  Created by Amit Salaria on 25/06/21.
//

import Foundation

enum TimeZoneType {
    case gmt
    case utc
    case local
}

enum DateFormat: String {
    case mm = "MM"
    case yyyy = "yyyy"
    case mmyyyy = "MM/yyyy"
}

extension Date {
    
    func stringFromDate(format: DateFormat, type: TimeZoneType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        switch type {
        case .gmt:
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        case .utc:
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        case .local:
            dateFormatter.timeZone = .current
        }
        return dateFormatter.string(from: self)
    }
    
}
