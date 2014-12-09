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
    private let keys = ["Repeat", "Label"]
    private var settingCells = [AlarmSettingView]()
    
    private var alarmContainerVC: AlarmContainerVC!
    private var alarm: Alarm!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alarmContainerVC = self.navigationController!.viewControllers[0] as AlarmContainerVC
        
        let time = Conversion.dateToHourMinute(self.timePicker.date)
        
        let possibleAlarm = self.alarmContainerVC.editAlarm
        
        if (possibleAlarm != nil) {
            self.alarm = possibleAlarm!.copy()
        } else {
            self.alarm = Alarm(text: "Nudge", minute: time.1, hour: time.0, enabled: true, repeat: false, fireDate: NSDate(), dates: AlarmDate(), index: 0)
        }
        
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
        if key == self.keys[0] {
            newView.setKeyDateLabel(key, defaultDate: self.alarm.dates, defaultLabel: nil)
        } else {
            newView.setKeyDateLabel(key, defaultDate: nil, defaultLabel: self.alarm.text)
        }
        self.settingCells.append(newView)
        newView.selectionStyle = UITableViewCellSelectionStyle.None
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
    
    func notifyNewText(text: String) {
        self.alarm.text = text
        self.updateTextLabel()
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
    
    func returnToAlarmContainerVC() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //overrides
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.settingCells[indexPath.row]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("AlarmRepeatVC") as AlarmRepeatVC
            vc.setAlarmDate(self.alarm.dates, alarmSettingVC: self)
            self.navigationController!.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("AlarmTextVC") as AlarmTextVC
            vc.setDefaultText(self.alarm.text, alarmSettingVC: self)
            self.navigationController!.pushViewController(vc, animated: true)
        }
    }
}
