//
//  AlarmCellView.swift
//  Nudge
//
//  Created by Shine Wang on 2014-12-06.
//  Copyright (c) 2014 Beyond Intelligence. All rights reserved.
//

import UIKit

//min height: 65
class AlarmCellView: UITableViewCell {
    
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
    
    @IBOutlet weak var rightArrowView: UIImageView!
    
    private let TAG = "AlarmCellView"
    
    private var alarm: Alarm!
    private var alarmContainerVC: AlarmContainerVC!
    
    @IBAction func enabledSwitchDidChange(sender: AnyObject) {
        NSLog("(%@) %@", TAG, "alarm has toggled to \(self.enabledSwitch.on)")
        self.alarmContainerVC.updatedAlarmState(self.alarm, enabledState: self.enabledSwitch.on)
        self.updateView()
    }
    
    func setReferences(alarm: Alarm, alarmContainerVC: AlarmContainerVC) {
        self.alarm = alarm
        self.alarmContainerVC = alarmContainerVC
        self.updateView()
    }
    
    func updateView() {
        self.setEnabled(self.alarm.enabled)
        self.setDays(self.alarm.dates)
        self.setTime(self.alarm.hour, minutes: self.alarm.minute)
        self.setDescription(self.alarm.text)
    }
    
    //sets the time in 24hr time, where hour is # hours past midnight
    //hour: [0, 23]
    //minutes: [0, 59]
    private func setTime(hour: Int, minutes: Int) {
        let hourString = String(format: "%d", (hour % 12 == 0) ? 12 : (hour % 12))
        let minuteString = String(format: "%02d", minutes)
        let timeString = hourString + ":" + minuteString
        let ampmString = (hour < 12) ? "am" : "pm"
        
        dispatch_async(dispatch_get_main_queue(), {
            self.timeLabel.text = timeString
            self.ampmLabel.text = ampmString
        })
    }
    
    //sets the description text, can be empty
    private func setDescription(description: String) {
        let descriptionString = (description == "") ? "Nudge" : description
        dispatch_async(dispatch_get_main_queue(), {
            self.descriptionLabel.text = descriptionString
        })
    }
    
    //sets the coloring for the days of week
    private func setDays(days: AlarmDate) {
        let dayLabels = [
            self.sundayLabel,
            self.mondayLabel,
            self.tuesdayLabel,
            self.wednesdayLabel,
            self.thursdayLabel,
            self.fridayLabel,
            self.saturdayLabel
        ]
        for i in 0 ..< dayLabels.count {
            if days.contains(DayOfWeek.allValues[i]) {
                if self.alarm.enabled {
                    dispatch_async(dispatch_get_main_queue(), {
                        dayLabels[i].textColor = UIColor.blackColor()
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        dayLabels[i].textColor = UIColor.darkGrayColor()
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    dayLabels[i].textColor = UIColor.lightGrayColor()
                })
            }
        }
    }
    
    private func setEnabled(enabled: Bool) {
        if enabled {
            dispatch_async(dispatch_get_main_queue(), {
                self.backgroundColor = UIColor.whiteColor()
                self.timeLabel.textColor = UIColor.blackColor()
                self.ampmLabel.textColor = UIColor.blackColor()
                self.descriptionLabel.textColor = UIColor.blackColor()
                self.enabledSwitch.setOn(true, animated: true)
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.backgroundColor = Conversion.UIColorFromRGB(239, green: 239, blue: 244)
                self.timeLabel.textColor = UIColor.darkGrayColor()
                self.ampmLabel.textColor = UIColor.darkGrayColor()
                self.descriptionLabel.textColor = UIColor.darkGrayColor()
                self.enabledSwitch.setOn(false, animated: true)
            })
        }
    }
}