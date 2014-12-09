//
//  BreakActivityCounter.swift
//  Caramel
//
//  Created by Shine Wang on 2014-11-06.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import Foundation

struct BreakActivityCounter {
    
    var activity: String
    var counter: Int
    
    init(activity: String, counter: Int) {
        self.activity = activity
        self.counter = counter
    }
}