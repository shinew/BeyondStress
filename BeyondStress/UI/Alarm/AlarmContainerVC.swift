//
//  AlarmContainerVC.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-07.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmContainerVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.navigationController != nil {
            self.navigationController!.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Univers-Light-Bold", size: 18)!]
        }
        self.tableView.rowHeight = 80
        
        let contents = NSBundle.mainBundle().loadNibNamed("AlarmCellView", owner: nil, options: nil)
        let tmpView = contents.last! as AlarmCellView
        tmpView.frame = self.tableView.frame
        self.tableView.addSubview(tmpView)
    }
}