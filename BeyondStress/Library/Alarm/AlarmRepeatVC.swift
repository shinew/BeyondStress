//
//  AlarmRepeatVC.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-08.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmRepeatVC: UITableViewController {
    
    private let TAG = "AlarmRepeatVC"
    private let prefix = "Every "
    private let suffixes = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    private var settingCells = [AlarmRepeatView]()
    private var date = AlarmDate()
    
    var alarmSettingVC: AlarmSettingVC!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
            dispatch_async(dispatch_get_main_queue(), {
                self.navigationController!.navigationBar.topItem!.title = "Repeat"
            })
        }
        self.tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        
        for i in 0 ..< self.suffixes.count {
            self.addSettingCell(
                self.prefix + self.suffixes[i],
                checkmarkOn: date.contains(DayOfWeek.allValues[i])
            )
        }
    }
    
    func setAlarmDate(date: AlarmDate, alarmSettingVC: AlarmSettingVC) {
        self.date = date
        self.alarmSettingVC = alarmSettingVC
    }
    
    func addSettingCell(text: String, checkmarkOn: Bool) {
        let contents = NSBundle.mainBundle().loadNibNamed("AlarmRepeatView", owner: nil, options: nil)
        let newView = contents.last! as AlarmRepeatView
        newView.selectionStyle = UITableViewCellSelectionStyle.None
        newView.setTextCheckmark(text, checkmarkOn: checkmarkOn)
        self.settingCells.append(newView)
    }
    
    func returnToAlarmContainerVC() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.suffixes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.settingCells[indexPath.row]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.settingCells[indexPath.row].toggleCheckmark()
        self.date.toggle(AlarmDate.getDayOfWeek(indexPath.row))
        self.alarmSettingVC.notifyNewDate(self.date)
    }
}
