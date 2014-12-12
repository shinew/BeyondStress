//
//  ProtocolsViewController.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-11.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class ProtocolsViewController: PortraitViewController {
    
    @IBOutlet weak var frustrationButton: UIButton!
    @IBOutlet weak var conflictButton: UIButton!
    @IBOutlet weak var overwhelmedButton: UIButton!
    @IBOutlet weak var fearButton: UIButton!
    
    var buttons: [UIButton]!
    let vcIDs = [
        "FrustrationViewController",
        "ConflictViewController",
        "OverwhelmedViewController",
        "FearViewController"
    ]
    let rootVCID = "DeepBreathsViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttons = [self.frustrationButton, self.conflictButton, self.overwhelmedButton, self.fearButton]
        
        for index in 0 ..< self.buttons.count {
            self.buttons[index].layer.borderColor = UIColor.blackColor().CGColor
            self.buttons[index].layer.borderWidth = 0.5
        }
    }
    @IBAction func frustrationButtonDidPress(sender: AnyObject) {
        self.openBreathingVC(0)
    }
    @IBAction func conflictButtonDidPress(sender: AnyObject) {
        self.openBreathingVC(1)
    }
    @IBAction func overwhelmedButtonDidPress(sender: AnyObject) {
        self.openBreathingVC(2)
    }
    @IBAction func fearButtonDidPress(sender: AnyObject) {
        self.openBreathingVC(3)
    }
    
    private func openBreathingVC(id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let breathingVC = storyboard.instantiateViewControllerWithIdentifier(rootVCID) as DeepBreathsViewController
        breathingVC.setNext(vcIDs[id])
        self.navigationController?.pushViewController(breathingVC, animated: true)
    }
}