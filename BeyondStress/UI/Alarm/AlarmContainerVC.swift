//
//  AlarmContainerVC.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-07.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmContainerVC: UITableViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    private var cellViews = [AlarmCellView]()
    private var alarmContainer = AlarmContainer()
    private var indentConstraints = [NSLayoutConstraint]()
    
    private let TAG = "AlarmContainerVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TESTING CODE
        //self.alarmContainer.add(Alarm(text: "what", minute: 23, hour: 18, enabled: true, repeat: false, fireDate: NSDate().dateByAddingTimeInterval(5), dates: AlarmDate(), index: -1))
        //self.alarmContainer.add(Alarm(text: "", minute: 2, hour: 3, enabled: true, repeat: true, fireDate: NSDate().dateByAddingTimeInterval(5), dates: AlarmDate(day: DayOfWeek.Friday), index: -1))
        //END TESTING CODE
        
        //view formatting
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        }
        self.tableView.rowHeight = 80
        //remove extra separators for non-existing cells
        self.tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        for i in 0 ..< self.alarmContainer.count() {
            self.addAlarmCell(self.alarmContainer.getAlarmAtIndex(i))
        }
    }
    
    @IBAction func editButtonDidPress(sender: AnyObject) {
        NSLog("(%@) %@", TAG, "Pressed edit button")
        self.editViewUpdate()
    }
    
    func editViewUpdate() {
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
                    self.cellViews[i].addConstraint(self.indentConstraints[i])
                    self.cellViews[i].enabledSwitch.hidden = true
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.cellViews[i].removeConstraint(self.indentConstraints[i])
                    self.cellViews[i].enabledSwitch.hidden = false
                })
            }
        }
    }
    
    func addAlarmCell(alarm: Alarm) {
        let contents = NSBundle.mainBundle().loadNibNamed("AlarmCellView", owner: nil, options: nil)
        let newView = contents.last! as AlarmCellView
        newView.selectionStyle = UITableViewCellSelectionStyle.None
        self.cellViews.append(newView)
        self.cellViews.last!.setReferences(alarm, alarmContainerVC: self)
        self.cellViews.last!.updateView()
        
        //add indentation logic
        let indentConstraint = NSLayoutConstraint(item: newView.timeLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: newView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 45.0)
        self.indentConstraints.append(indentConstraint)
    }
    
    func removeAlarmCell(indexPath: NSIndexPath) {
        self.alarmContainer.remove(indexPath.row)
        self.cellViews.removeAtIndex(indexPath.row)
        self.indentConstraints.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
    }
    
    func rowDidTap(indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("pushCustomization", sender: self)
    }
    
    //called by AlarmCellView if enabledSwitch was toggled
    func updatedAlarmState(alarm: Alarm, enabledState: Bool) {
        if enabledState {
            alarm.enableAlarm()
        } else {
            alarm.disableAlarm()
        }
        self.alarmContainer.update()
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
        self.rowDidTap(indexPath)
    }
}