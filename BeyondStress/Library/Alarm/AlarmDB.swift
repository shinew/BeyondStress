//
//  AlarmDB.swift
//  Nudge
//
//  Created by Shine Wang on 2014-12-04.
//  Copyright (c) 2014 Beyond Intelligence. All rights reserved.
//

import UIKit
import CoreData

let _global_db_queue = dispatch_queue_create("me.getbeyond.dbQueue", nil)
private var _db_alarmResult = [Alarm]()

//interfaces with Core Data to manage alarms
class AlarmDB {
    
    private let TAG = "AlarmDB"
    
    //retrives the alarms from Core Data
    func getAlarms() -> [Alarm] {
        NSLog("(%@) %@", TAG, "retriving alarms from Core Data")
        
        dispatch_sync(_global_db_queue, {
            let appContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            var request = NSFetchRequest(entityName: "Alarm")
            request.returnsObjectsAsFaults = false
            var searchResults = appContext.executeFetchRequest(request, error: nil)!
            _db_alarmResult.removeAll(keepCapacity: true)
            for item in searchResults {
                let thisItem = item as NSManagedObject
                _db_alarmResult.append(
                    Alarm(
                        text: thisItem.valueForKey("text") as String,
                        minute: thisItem.valueForKey("minute") as Int,
                        hour: thisItem.valueForKey("hour") as Int,
                        enabled: thisItem.valueForKey("enabled") as Bool,
                        repeat: thisItem.valueForKey("repeat") as Bool,
                        fireDate: thisItem.valueForKey("fireDate") as NSDate,
                        dates: AlarmDate(days: thisItem.valueForKey("dates") as Int),
                        index: thisItem.valueForKey("index") as Int,
                        message: thisItem.valueForKey("message") as String
                    )
                )
            }
        })
        
        return _db_alarmResult
    }
    
    func setAlarms(alarms: [Alarm]) {
        NSLog("(%@) %@", TAG, "resetting alarms from Core Data")
        
        dispatch_sync(_global_db_queue, {
            let appContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            var request = NSFetchRequest(entityName: "Alarm")
            request.returnsObjectsAsFaults = false
            var searchResults = appContext.executeFetchRequest(request, error: nil)!
            for item in searchResults {
                appContext.deleteObject(item as NSManagedObject)
            }
            
            for alarm in alarms {
                var alarmEntity = NSEntityDescription.insertNewObjectForEntityForName("Alarm", inManagedObjectContext: appContext) as NSManagedObject
                alarmEntity.setValue(alarm.text, forKey: "text")
                alarmEntity.setValue(alarm.minute, forKey: "minute")
                alarmEntity.setValue(alarm.hour, forKey: "hour")
                alarmEntity.setValue(alarm.enabled, forKey: "enabled")
                alarmEntity.setValue(alarm.repeat, forKey: "repeat")
                alarmEntity.setValue(alarm.fireDate, forKey: "fireDate")
                alarmEntity.setValue(alarm.dates.getRaw(), forKey: "dates")
                alarmEntity.setValue(alarm.index, forKey: "index")
                alarmEntity.setValue(alarm.message, forKey: "message")
            }
            
            appContext.save(nil)
        })
    }
}