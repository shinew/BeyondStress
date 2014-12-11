//
//  OnboardingContentViewController.swift
//  OnboardSwift
//
//  Created by Mike on 9/11/14.
//  Copyright (c) 2014 Mike Amaral. All rights reserved.
//

import UIKit

class OnboardingContentViewController: UIViewController {

    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var escapeButton: UIButton!
    
    func makeStartScreen() {
        self.mainTitleLabel.hidden = false
        self.mainImageView.hidden = true
        self.resetTextView("We make stress reduction a part of life instead of a break from life")
        (self.view as UIImageView).image = UIImage(named: "onboarding-background")!
    }
    
    func customize(image: UIImage, subtitle: String, enableButton: Bool) {
        self.resetTextView(subtitle)
        self.mainImageView.image = image
        self.escapeButton.hidden = !enableButton
        
        self.escapeButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.escapeButton.layer.borderWidth = 1
        self.escapeButton.layer.cornerRadius = 7.5
    }
    
    private func resetTextView(text: String) {
        self.bottomTextView.text = text
        self.bottomTextView.textColor = UIColor.whiteColor()
        self.bottomTextView.font = UIFont(name: "UniversLightCondensed-Regular", size: 20)
        self.bottomTextView.scrollRangeToVisible(NSMakeRange(0, 1))
    }
    
    @IBAction func escapeButtonDidPress(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let page = storyboard
            .instantiateViewControllerWithIdentifier("InitialTabBarController")
            as UITabBarController
        (UIApplication.sharedApplication().delegate as AppDelegate).window!.rootViewController = page
    }
}