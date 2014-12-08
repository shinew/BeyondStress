//
//  AlarmRepeatView.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-08.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmRepeatView: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkmarkView: UIImageView!
    
    func setTextCheckmark(text: String, checkmarkOn: Bool) {
        dispatch_async(dispatch_get_main_queue(), {
            self.descriptionLabel.text = text
            self.checkmarkView.hidden = !checkmarkOn
        })
    }
    
    func toggleCheckmark() {
        dispatch_async(dispatch_get_main_queue(), {
            self.checkmarkView.hidden = !self.checkmarkView.hidden
        })
    }
}