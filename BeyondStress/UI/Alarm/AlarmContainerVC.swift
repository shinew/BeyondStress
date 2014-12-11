//
//  AlarmContainerVC.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-07.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

enum SettingState {
    case Add
    case Edit
}

class AlarmContainerVC: UITableViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    private var cellViews = [AlarmCellView]()
    private var alarmContainer = AlarmContainer()
    private var indentConstraints = [NSLayoutConstraint]()
    private var unindentConstraints = [NSLayoutConstraint]()
    
    private let TAG = "AlarmContainerVC"
    
    var settingState = SettingState.Add
    var editAlarm: Alarm? = nil //used for editing mode
    var editIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TESTING CODE
        //self.alarmContainer.add(Alarm(text: "", minute: 2, hour: 3, enabled: true, repeat: true, fireDate: NSDate().dateByAddingTimeInterval(5), dates: AlarmDate(day: DayOfWeek.Friday), index: -1))
        //END TESTING CODE
        
        //view formatting
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        }
        self.tableView.rowHeight = 95
        //remove extra separators for non-existing cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        self.addDefaultAlarms()
        
        for i in 0 ..< self.alarmContainer.count() {
            self.addInitialAlarmCell(self.alarmContainer.getAlarmAtIndex(i))
        }
        self.reindentRows()
    }
    
    @IBAction func editButtonDidPress(sender: AnyObject) {
        NSLog("(%@) %@", TAG, "Pressed edit button")
        self.editToggleViewUpdate()
    }
    
    private func addDefaultAlarms() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if userDefaults.boolForKey("addedDefaultAlarms") {
            return
        }
        
        self.alarmContainer.add(Alarm(text: "Pre-work focus", minute: 30, hour: 8, enabled: false, repeat: true, fireDate: NSDate().dateByAddingTimeInterval(5), dates: AlarmDate.getWeekdays(), index: -1, message: "Hey, let's take a moment to focus before work."))
        self.alarmContainer.add(Alarm(text: "After lunch", minute: 0, hour: 13, enabled: false, repeat: true, fireDate: NSDate().dateByAddingTimeInterval(5), dates: AlarmDate.getWeekdays(), index: -1, message: "Take a breather after the lunch-break?"))
        self.alarmContainer.add(Alarm(text: "Night", minute: 0, hour: 19, enabled: false, repeat: true, fireDate: NSDate().dateByAddingTimeInterval(5), dates: AlarmDate.getWeekdays(), index: -1, message: "Let's take a moment to be calm for family time."))
        
        userDefaults.setBool(true, forKey: "addedDefaultAlarms")
        userDefaults.synchronize()
    }
    
    func editToggleViewUpdate() {
        if self.tableView.editing {
            dispatch_async(dispatch_get_main_queue(), {
                self.editButton.title = "Edit"
            })
            self.tableView.setEditing(false, animated: true)
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.editButton.title = "Done"
            })
            self.tableView.setEditing(true, animated: true)
        }
        self.reindentRows()
    }
    
    //adds/removes the autolayout constraint to indent the front
    func reindentRows() {
        for i in 0 ..< self.cellViews.count {
            if self.tableView.editing {
                dispatch_async(dispatch_get_main_queue(), {
                    self.cellViews[i].removeConstraint(self.unindentConstraints[i])
                    self.cellViews[i].addConstraint(self.indentConstraints[i])
                    self.cellViews[i].enabledSwitch.hidden = true
                    self.cellViews[i].rightArrowView.hidden = false
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.cellViews[i].removeConstraint(self.indentConstraints[i])
                    self.cellViews[i].addConstraint(self.unindentConstraints[i])
                    self.cellViews[i].enabledSwitch.hidden = false
                    self.cellViews[i].rightArrowView.hidden = true
                })
            }
        }
    }
    
    func addAlarmCell(alarm: Alarm) {
        self.alarmContainer.add(alarm)
        self.addInitialAlarmCell(alarm)
        
        Mixpanel.sharedInstance().track("Added alarm", properties: ["alarmCount": self.alarmContainer.count()])
        
        self.reindentRows()
    }
    
    //does not reschedule for efficiency
    func addInitialAlarmCell(alarm: Alarm) {
        let contents = NSBundle.mainBundle().loadNibNamed("AlarmCellView", owner: nil, options: nil)
        let newView = contents.last! as AlarmCellView
        newView.selectionStyle = UITableViewCellSelectionStyle.None
        self.cellViews.append(newView)
        self.cellViews.last!.setReferences(alarm, alarmContainerVC: self)
        self.cellViews.last!.updateView()
        
        //add indentation logic
        let indentConstraint = NSLayoutConstraint(item: newView.timeLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: newView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 45.0)
        let unindentConstraint = NSLayoutConstraint(item: newView.timeLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: newView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 16.0)
        self.indentConstraints.append(indentConstraint)
        self.unindentConstraints.append(unindentConstraint)
    }
    
    //uses self.editIndexPath
    func updateAlarmCell(alarm: Alarm) {
        self.alarmContainer.update(self.editIndexPath!.row, newState: alarm)
        self.cellViews[self.editIndexPath!.row].setReferences(alarm, alarmContainerVC: self)
    }
    
    func removeAlarmCell(indexPath: NSIndexPath) {
        self.alarmContainer.remove(indexPath.row)
        self.cellViews.removeAtIndex(indexPath.row)
        self.indentConstraints.removeAtIndex(indexPath.row)
        self.unindentConstraints.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        
        Mixpanel.sharedInstance().track("Deleted alarm", properties: ["alarmCount": self.alarmContainer.count()])
    }
    
    //called by AlarmCellView if enabledSwitch was toggled (in non-editing mode)
    func updatedAlarmState(alarm: Alarm, enabledState: Bool) {
        if enabledState {
            alarm.enableAlarm()
        } else {
            alarm.disableAlarm()
        }
        self.alarmContainer.update()
    }
    
    func cancelNewAlarm() {
        if self.settingState == SettingState.Edit {
            self.resetEditState()
        }
    }
    
    func notifyNewAlarm(alarm: Alarm) {
        alarm.fireDate = NSDate().dateByAddingTimeInterval(5) //hack to ensure this alarm will be enabled upon registering
        if self.settingState == SettingState.Add {
            self.addAlarmCell(alarm)
        } else if self.settingState == SettingState.Edit {
            self.updateAlarmCell(alarm)
            self.resetEditState()
        }
    }
    
    func notifyDeleteAlarm() {
        self.removeAlarmCell(self.editIndexPath!)
        self.resetEditState()
    }
    
    func resetEditState() {
        self.editIndexPath = nil
        self.editAlarm = nil
        self.settingState = SettingState.Add
        if self.tableView.editing == true {
            self.editToggleViewUpdate()
        }
    }
    
    /*----------------------OVERRIDE FUNCTIONS----------------------*/
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cellViews[indexPath.row]
    }
    
    //removes the alarm indexed at indexPath
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle != UITableViewCellEditingStyle.Delete {
            return
        }
        self.removeAlarmCell(indexPath)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.tableView.editing == false {
            return
        }
        self.settingState = SettingState.Edit
        self.editAlarm = self.alarmContainer.getAlarmAtIndex(indexPath.row)
        self.editIndexPath = indexPath
        self.performSegueWithIdentifier("pushCustomization", sender: self)
    }
}