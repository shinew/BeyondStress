//
//  OnboardingManager.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-10.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit

class OnboardingManager {
    
    var onboardingVC: OnboardingViewController!
    private let texts = [
        "1. Set nudges when you want to feel calm. We’ve preset three for you.",
        "2. Get nudged with a custom message at the desired time.",
        "3. Swipe the nudge for clinically proven ways to reduce stress.",
        "4. Open the app anytime you feel tense or stressed and need help."
    ]
    private let images = [
        UIImage(named: "onboarding1"),
        UIImage(named: "onboarding2"),
        UIImage(named: "onboarding3"),
        UIImage(named: "onboarding4")
    ]
    
    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var pages = [OnboardingContentViewController]()
        
        for i in 1 ... 5 {
            let page = storyboard
                .instantiateViewControllerWithIdentifier("OnboardingVC")
                as OnboardingContentViewController
            let optimizationHack = page.view == nil //BUG: http://stackoverflow.com/questions/12523198/storyboard-instantiateviewcontrollerwithidentifier-not-setting-iboutlets
            pages.append(page)
        }
        pages[0].makeStartScreen()
        for i in 1 ... 4 {
            pages[i].customize(images[i-1]!, subtitle: texts[i-1], enableButton: i == 4)
        }
        self.onboardingVC = OnboardingViewController(backgroundImage: nil, contents: pages)
    }
}