//
//  AlarmSettingVC.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-08.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmSettingVC: PortraitViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    
    private let TAG = "AlarmSettingVC"
    private let keys = ["Repeat", "Label", "Message"]
    private var settingCells = [AlarmSettingView]()
    private var deleteCell: AlarmDeleteView!
    private var settingState = SettingState.Add
    
    private var alarmContainerVC: AlarmContainerVC!
    private var alarm: Alarm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmContainerVC = self.navigationController!.viewControllers[0] as AlarmContainerVC
        
        if (self.alarmContainerVC.settingState == SettingState.Edit) {
            self.settingState = SettingState.Edit
            self.alarm = self.alarmContainerVC.editAlarm!.copy()
            //we need a delete alarm cell if so
            let contents = NSBundle.mainBundle().loadNibNamed("AlarmDeleteView", owner: nil, options: nil)
            let newView = contents.last! as AlarmDeleteView
            newView.selectionStyle = UITableViewCellSelectionStyle.None
            self.deleteCell = newView
        } else {
            self.settingState = SettingState.Add
            //instantiate new alarm with current time
            let time = Conversion.dateToHourMinute(self.timePicker.date)
            self.alarm = Alarm(text: "", minute: time.1, hour: time.0, enabled: true, repeat: false, fireDate: NSDate(), dates: AlarmDate(), index: 0, message: "")
        }
        
        //set the timer to the alarm date
        let newDate = Conversion.hourMinuteToDate(self.alarm.hour, minute: self.alarm.minute)
        dispatch_async(dispatch_get_main_queue(), {
            self.timePicker.setDate(newDate, animated: false)
        })
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.rowHeight = 50
        self.tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        for i in 0 ..< self.keys.count {
            self.addSettingCell(self.keys[i])
        }
    }
    
    @IBAction func cancelButtonDidPress(sender: AnyObject) {
        self.alarmContainerVC.cancelNewAlarm()
        self.returnToAlarmContainerVC()
    }
    
    @IBAction func saveButtonDidPress(sender: AnyObject) {
        self.alarmContainerVC.notifyNewAlarm(self.alarm)
        self.returnToAlarmContainerVC()
    }
    
    @IBAction func timePickerValueChanged(sender: AnyObject) {
        let hourMinute = Conversion.dateToHourMinute(timePicker.date)
        self.alarm.hour = hourMinute.0
        self.alarm.minute = hourMinute.1
        NSLog("(%@) %@", TAG, "New hour: \(self.alarm.hour), minute: \(self.alarm.minute)")
    }
    
    func addSettingCell(key: String) {
        let contents = NSBundle.mainBundle().loadNibNamed("AlarmSettingView", owner: nil, options: nil)
        let newView = contents.last! as AlarmSettingView
        switch key {
        case "Repeat":
            newView.setKeyDateLabel(key, defaultDate: self.alarm.dates, defaultLabel: nil)
        case "Label":
            newView.setKeyDateLabel(key, defaultDate: nil, defaultLabel: self.alarm.text)
        case "Message":
            newView.setKeyDateLabel(key, defaultDate: nil, defaultLabel: self.alarm.message)
        default:
            NSLog("(%@) %@", TAG, "No instance found for alarm setting cell with key \(key)")
        }
        newView.selectionStyle = UITableViewCellSelectionStyle.None
        self.settingCells.append(newView)
    }
    
    func notifyNewDate(date: AlarmDate) {
        self.alarm.dates = date
        if self.alarm.dates.hasAny() {
            self.alarm.repeat = true
        } else {
            self.alarm.repeat = false
        }
        self.updateRepeatLabel()
    }
    
    func notifyNewText(key: String, text: String) {
        if key == "Label" {
            self.alarm.text = text
            self.updateTextLabel()
        } else if key == "Message" {
            self.alarm.message = text
            self.updateMessageLabel()
        }
    }
    
    //for edit mode, we want to change the title to "Edit Nudge"
    func switchToAltNavBarTitle() {
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController!.navigationBar.topItem!.title = "Edit Nudge"
        })
    }
    
    func updateRepeatLabel() {
        let repeatCell = self.settingCells[0]
        repeatCell.setDate(self.alarm.dates)
    }
    
    func updateTextLabel() {
        let textCell = self.settingCells[1]
        textCell.setText(self.alarm.text)
    }
    
    func updateMessageLabel() {
        let textCell = self.settingCells[2]
        textCell.setText(self.alarm.message)

    }
    
    func returnToAlarmContainerVC() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //overrides
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.settingState == SettingState.Add {
            return 1 //we don't display the delete alarm cell
        } else {
            return self.keys.count
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.keys.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return self.settingCells[indexPath.row]
        } else {
            return self.deleteCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                //pressed "Repeat"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("AlarmRepeatVC") as AlarmRepeatVC
                vc.setAlarmDate(self.alarm.dates, alarmSettingVC: self)
                self.navigationController!.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                //pressed "Label"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("AlarmTextVC") as AlarmTextVC
                vc.setDefaultText("Label", text: self.alarm.text, alarmSettingVC: self)
                self.navigationController!.pushViewController(vc, animated: true)
            } else {
                //pressed "Label"
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("AlarmTextVC") as AlarmTextVC
                vc.setDefaultText("Message", text: self.alarm.message, alarmSettingVC: self)
                self.navigationController!.pushViewController(vc, animated: true)
            }
        } else {
            //pressed "Delete"
            self.alarmContainerVC.notifyDeleteAlarm()
            self.returnToAlarmContainerVC()
        }
    }
}
