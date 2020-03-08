//
//  DateExtension.swift
//  ChatView
//
//  Created by APPLE'S iMac on 3/9/20.
//  Copyright © 2020 APPLE'S iMac. All rights reserved.
//

import UIKit

extension Date {
    public func addingDays(_ days: Int) -> Date {
        return self.addingTimeInterval(Double(days) * 60 * 60 * 24)
    }
    
    public func subtractingDays(_ days: Int) -> Date {
        return self.addingTimeInterval(Double(-days) * 60 * 60 * 24)
    }
    
    public func days(since date: Date) -> Int {
        let interval = self.timeIntervalSince(date)
        return Int(interval / (60 * 60 * 24))
    }
    
    public func isSameDay(date: Date) -> Bool {
        let comps1 = NSCalendar.current.dateComponents([.day, .month, .year], from: self)
        let comps2 = NSCalendar.current.dateComponents([.day, .month, .year], from: date)
        return (comps1.year == comps2.year) && (comps1.month == comps2.month) && (comps1.day == comps2.day)
    }
    
    public func isFirstDay() -> Bool {
        let day = NSCalendar.current.component(.day, from: self)
        return day == 1
    }
}

