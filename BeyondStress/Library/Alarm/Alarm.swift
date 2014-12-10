//
//  Alarm.swift
//  Nudge
//
//  Created by Shine Wang on 2014-12-04.
//  Copyright (c) 2014 Beyond Intelligence. All rights reserved.
//

import Foundation

//represents one alarm set by the user
class Alarm {
    
    var text: String
    var minute: Int //[0, 59]
    var hour: Int //[0, 23], 0 = midnight
    var enabled: Bool
    var repeat: Bool
    var fireDate: NSDate
    var dates: AlarmDate
    var index: Int
    var message: String
    
    init() {
        self.text = ""
        self.minute = 0
        self.hour = 0
        self.enabled = false
        self.repeat = false
        self.fireDate = NSDate()
        self.dates = AlarmDate()
        self.index = 0
        self.message = ""
    }
    
    //used for re-initialization from DB
    init(text: String, minute: Int, hour: Int, enabled: Bool, repeat: Bool, fireDate: NSDate, dates: AlarmDate, index: Int, message: String) {
        self.text = text
        self.minute = minute
        self.hour = hour
        self.enabled = enabled
        self.repeat = repeat
        self.fireDate = fireDate
        self.dates = dates
        self.index = index
        self.message = message
    }
    
    func copy() -> Alarm {
        return Alarm(
            text: self.text,
            minute: self.minute,
            hour: self.hour,
            enabled: self.enabled,
            repeat: self.repeat,
            fireDate: self.fireDate,
            dates: self.dates.copy(),
            index: self.index,
            message: self.message
        )
    }
    
    //Returns a time to fire the notification for this alarm. Guaranteed to be on weekday 'day' (if day != nil), and after the current time.
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
            if notifyDate.compare(currentDate) != NSComparisonResult.OrderedDescending {
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
        if notifyDate.compare(currentDate) != NSComparisonResult.OrderedDescending {
            notifyDate = notifyDate.dateByAddingTimeInterval(7 * 24 * 3600)
        }
        return notifyDate
    }
    
    //Disables timer if fireDate < currentDate for NON-REPEATING, ENABLED ALARMS
    //Happens if users miss the notification
    func disableIfNecessary(thisView: AlarmCellView?) {
        if self.enabled == false || self.repeat == true {
            //we don't need to worry about these cases
            return
        }
        
        if self.fireDate.compare(NSDate()) != NSComparisonResult.OrderedDescending {
            self.enabled = false
            if thisView == nil {
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                thisView!.enabledSwitch.setOn(false, animated: true)
            })
        }
    }
    
    //Re-enables the alarm, sets relevant fireDates
    func enableAlarm() {
        self.enabled = true
        if self.repeat == true {
            return
        }
        //one-time - may need to adjust fireDate
        self.fireDate = self.getDate(nil)
    }
    
    func disableAlarm() {
        self.enabled = false
    }
}