//
//  AlarmCellView.swift
//  Nudge
//
//  Created by Shine Wang on 2014-12-06.
//  Copyright (c) 2014 Beyond Intelligence. All rights reserved.
//

import UIKit

//min height: 65
class AlarmCellView: UIView {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var ampmLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var enabledSwitch: UISwitch!
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    //sets the time in 24hr time, where hour is # hours past midnight
    //hour: [0, 23]
    //minutes: [0, 59]
    func setTime(hour: Int, minutes: Int) {
        let hourString = String(format: "%02d", (hour % 12 == 0) ? 12 : (hour % 12))
        let minuteString = String(format: "%02d", minutes)
        let timeString = hourString + ":" + minuteString
        let ampmString = (hour < 12) ? "am" : "pm"
        
        dispatch_async(dispatch_get_main_queue(), {
            self.timeLabel.text = timeString
            self.ampmLabel.text = ampmString
        })
    }
    
    //sets the description text, can be empty
    func setDescription(description: String) {
        let descriptionString = (description == "") ? "Description" : description
        dispatch_async(dispatch_get_main_queue(), {
            self.descriptionLabel.text = descriptionString
        })
    }
    
    //sets the coloring for the days of week
    func setDays(days: AlarmDate) {
        let dayLabels = [self.sundayLabel, self.mondayLabel, self.tuesdayLabel, self.wednesdayLabel, self.thursdayLabel, self.fridayLabel, self.saturdayLabel]
        for i in 0 ..< dayLabels.count {
            if days.contains(DayOfWeek.allValues[i]) {
                dispatch_async(dispatch_get_main_queue(), {
                    dayLabels[i].textColor = UIColor.blackColor()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    dayLabels[i].textColor = UIColor.lightGrayColor()
                })
            }
        }
    }
}