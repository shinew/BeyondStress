//
//  AlarmDB.swift
//  Nudge
//
//  Created by Shine Wang on 2014-12-04.
//  Copyright (c) 2014 Beyond Intelligence. All rights reserved.
//

import UIKit
import CoreData

private let _global_alarm_queue = dispatch_queue_create("me.getbeyond.alarmQueue", nil)
private var _db_alarmResult = [Alarm]()


//interfaces with Core Data to manage alarms
class AlarmDB {
    
    private let TAG = "AlarmDB"
    
    //retrives the alarms from Core Data
    func getAlarms() -> [Alarm] {
        NSLog("(%@) %@", TAG, "retriving alarms from Core Data")
        
        dispatch_sync(_global_alarm_queue, {
            let appContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            var request = NSFetchRequest(entityName: "Alarm")
            request.returnsObjectsAsFaults = false
            var searchResults = appContext.executeFetchRequest(request, error: nil)!
            _db_alarmResult.removeAll(keepCapacity: true)
            for item in searchResults {
                let thisItem = item as NSManagedObject
                _db_alarmResult.append(
                    Alarm(
                        index: thisItem.valueForKey("index") as Int,
                        enabled: thisItem.valueForKey("enabled") as Bool,
                        repeat: thisItem.valueForKey("repeat") as Bool,
                        dates: AlarmDate(days: thisItem.valueForKey("dates") as Int),
                        hour: thisItem.valueForKey("hour") as Int,
                        minute: thisItem.valueForKey("minute") as Int,
                        text: thisItem.valueForKey("text") as String
                    )
                )
            }
        })
        
        return _db_alarmResult
    }
    
    func setAlarms(alarms: [Alarm]) {
        NSLog("(%@) %@", TAG, "resetting alarms from Core Data")
        
        dispatch_sync(_global_alarm_queue, {
            let appContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!
            var request = NSFetchRequest(entityName: "Alarm")
            request.returnsObjectsAsFaults = false
            var searchResults = appContext.executeFetchRequest(request, error: nil)!
            for item in searchResults {
                appContext.deleteObject(item as NSManagedObject)
            }
            
            for alarm in alarms {
                var alarmEntity = NSEntityDescription.insertNewObjectForEntityForName("Alarm", inManagedObjectContext: appContext) as NSManagedObject
                alarmEntity.setValue(alarm.index, forKey: "index")
                alarmEntity.setValue(alarm.enabled, forKey: "enabled")
                alarmEntity.setValue(alarm.repeat, forKey: "repeat")
                alarmEntity.setValue(alarm.dates.getRaw(), forKey: "dates")
                alarmEntity.setValue(alarm.hour, forKey: "hour")
                alarmEntity.setValue(alarm.minute, forKey: "minute")
                alarmEntity.setValue(alarm.text, forKey: "text")
            }
            
            appContext.save(nil)
        })
    }
}