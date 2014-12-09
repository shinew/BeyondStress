//
//  AlarmTextVC.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-08.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmTextVC: PortraitViewController {
    
    @IBOutlet weak var textField: UITextField!
    private var alarmSettingVC: AlarmSettingVC!
    
    override func viewDidLoad() {
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController!.navigationBar.topItem!.title = "Label"
        })
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:")))
    }
    
    @objc func dismissKeyboard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func setDefaultText(text: String, alarmSettingVC: AlarmSettingVC) {
        self.alarmSettingVC = alarmSettingVC
        dispatch_async(dispatch_get_main_queue(), {
            self.textField.text = text
        })
    }
    
    @IBAction func editingDidEnd(sender: AnyObject) {
        self.alarmSettingVC.notifyNewText(self.textField.text)
    }
}