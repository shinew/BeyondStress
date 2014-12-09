//
//  ActionDB.swift
//  BeyondStress
//
//  Created by Shine Wang on 2014-12-08.
//  Copyright (c) 2014 Beyond. All rights reserved.
//

import UIKit
import CoreData

//we reference _global_db_queue from AlarmDB

private var _db_break_result: BreakActivityCounter!

class ActionDB {
    
    private let TAG = "ActionDB"
    
    func updateBreakActivityCounter(activity: BreakActivityCounter) {
        
        println("(\(TAG)) Updating break activity counter")
        
        dispatch_sync(_global_db_queue, {
            let appContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            var request = NSFetchRequest(entityName: "BreakActivityCounter")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "activity == %@", activity.activity)
            var searchResults = appContext.executeFetchRequest(request, error: nil)!
            if searchResults.count == 0 {
                var stressScore = NSEntityDescription.insertNewObjectForEntityForName("BreakActivityCounter", inManagedObjectContext: appContext) as NSManagedObject
                stressScore.setValue(activity.activity, forKey: "activity")
                stressScore.setValue(activity.counter, forKey: "counter")
            } else {
                let item = searchResults.first! as NSManagedObject
                item.setValue(activity.counter, forKey: "counter")
            }
            appContext.save(nil)
        })
    }
    
    func getBreakActivityCounter(fixedActivity: BreakActivityCounter) -> BreakActivityCounter {
        
        println("(\(TAG)) Retriving break activity counter")
        
        dispatch_sync(_global_db_queue, {
            let appContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            var activity = fixedActivity
            var request = NSFetchRequest(entityName: "BreakActivityCounter")
            request.returnsObjectsAsFaults = false
            request.predicate = NSPredicate(format: "activity == %@", activity.activity)
            var searchResults = appContext.executeFetchRequest(request, error: nil)!
            if searchResults.count == 0 {
                activity.counter = 0
            } else {
                let item = searchResults.first! as NSManagedObject
                activity.counter = item.valueForKey("counter") as Int
            }
            _db_break_result = activity
        })
        return _db_break_result!
    }

}