//
//  Alarm.swift
//  Nudge
//
//  Created by Shine Wang on 2014-12-04.
//  Copyright (c) 2014 Beyond Intelligence. All rights reserved.
//

import Foundation

//represents one alarm set by the user
struct Alarm {
    
    var dates: AlarmDate
    var enabled: Bool
    var minute: Int //[0, 59]
    var hour: Int //[0, 23], 0 = midnight
    var repeat: Bool
    var index: Int
    var text: String
    
    init() {
        self.dates = AlarmDate()
        self.enabled = false
        self.minute = 0
        self.hour = 0
        self.repeat = false
        self.index = 0
        self.text = ""
    }
    
    init(index: Int, enabled: Bool, repeat: Bool, dates: AlarmDate, hour: Int, minute: Int, text: String) {
        self.index = index
        self.enabled = enabled
        self.repeat = repeat
        self.dates = dates
        self.hour = hour
        self.minute = minute
        self.text = text
    }
    
    //Returns a time to fire the (first) notification for this alarm. Guaranteed to be on weekday 'day' (if day != nil), and not before the current time.
    func getDate(day: DayOfWeek?) -> NSDate {
        let currentDate = NSDate()
        let components = NSCalendar.currentCalendar().components(
            .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay,
            fromDate: currentDate
        )
        let currentDateStart = NSCalendar.currentCalendar().dateFromComponents(components)!
        var notifyDate = currentDateStart.dateByAddingTimeInterval(NSTimeInterval(self.hour * 3600 + self.minute * 60))
        
        if day == nil {
            //check to make sure notification date is after the current date - push back a DAY
            if notifyDate.compare(currentDate) == NSComparisonResult.OrderedAscending {
                notifyDate = notifyDate.dateByAddingTimeInterval(24 * 3600)
            }
            return notifyDate
        }
        
        //move to the correct weekday
        let weekday = NSCalendar.currentCalendar().components(.CalendarUnitWeekday, fromDate: currentDate).weekday
        var distance = AlarmDate.getWeekdayNumber(day!) - weekday
        if distance < 0 { distance += 7 }
        notifyDate = notifyDate.dateByAddingTimeInterval(NSTimeInterval(distance * 24 * 3600))
        
        //check to make sure notification date is after the current date - push back a WEEK
        if notifyDate.compare(currentDate) == NSComparisonResult.OrderedAscending {
            notifyDate = notifyDate.dateByAddingTimeInterval(7 * 24 * 3600)
        }
        return notifyDate
    }
}