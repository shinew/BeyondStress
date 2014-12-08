//
//  AlarmContainerVC.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-07.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmContainerVC: UITableViewController {
    
    var cellViews = [AlarmCellView]()
    var alarmContainer = AlarmContainer()
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.alarmContainer.add(Alarm(index: 0, enabled: true, repeat: false, dates: AlarmDate(), hour: 18, minute: 23, text: "Hi!"))
        
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        }
        
        self.tableView.rowHeight = 80
        
        for i in 0 ..< self.alarmContainer.count() {
            let contents = NSBundle.mainBundle().loadNibNamed("AlarmCellView", owner: nil, options: nil)
            self.cellViews.append(contents.last! as AlarmCellView)
            self.cellViews.last!.containerReference = self
            self.cellViews.last!.updateView()
        }
    }
    
    func updatedAlarmState(alarm: Alarm, enabledState: Bool) {
        if enabledState {
            alarm.enableAlarm()
        } else {
            alarm.disableAlarm()
        }
        self.alarmContainer.update()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellViews.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.cellViews[indexPath.indexAtPosition(0)]
    }
}