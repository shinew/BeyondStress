//
//  AlarmTextVC.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-08.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class AlarmTextVC: PortraitViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    private var alarmSettingVC: AlarmSettingVC!
    private var key = ""
    
    override func viewDidLoad() {
        dispatch_async(dispatch_get_main_queue(), {
            self.navigationController!.navigationBar.topItem!.title = "Label"
        })
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard:")))
        self.textField.delegate = self
        self.textField.becomeFirstResponder()
    }
    
    @objc func dismissKeyboard(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.textField.resignFirstResponder()
        self.editingDidEnd(self)
        self.returnToAlarmContainerVC()
        return true
    }
    
    func setDefaultText(key: String, text: String, alarmSettingVC: AlarmSettingVC) {
        self.key = key
        self.alarmSettingVC = alarmSettingVC
        dispatch_async(dispatch_get_main_queue(), {
            self.textField.text = text
        })
    }
    
    @IBAction func editingDidEnd(sender: AnyObject) {
        self.alarmSettingVC.notifyNewText(self.key, text: self.textField.text)
    }
    
    func returnToAlarmContainerVC() {
        self.navigationController!.popViewControllerAnimated(true)
    }
}