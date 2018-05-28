//
//  TimeWork.swift
//  Beefficient
//
//  Created by Eugen on 28/05/2018.
//  Copyright © 2018 Eugen. All rights reserved.
//

import Foundation

class TimeWork {
    let formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    let componentFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter
    }()
    
    func dateFromString( _ string: String?) -> Date? {
        guard let string = string,
            let date = formatter.date(from: string)
        else {
            return nil
        }
        
        return date
        
    }
    
    func formattedIntervalSinceNow( _ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        
        return componentFormatter.string(from: date.timeIntervalSinceNow) ?? ""
    }
}
