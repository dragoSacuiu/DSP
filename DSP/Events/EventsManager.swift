//
//  File.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation
import Cocoa


class EventType {
    var name: String
    var color: CGColor
    var image: NSImage
    var priority: Int
    var firstCode: Int
    var lastCode: Int
    
    init(name: String, color: CGColor, image: NSImage, priority: Int, firstCode: Int, lastCode: Int) {
        self.name = name
        self.color = color
        self.image = image
        self.priority = priority
        self.firstCode = firstCode
        self.lastCode = lastCode
    }
}

class EventsManager {
    
    let medicalAlarm = EventType(name: "MEDICAL ALARM", color: NSColor.red.cgColor, image: NSImage(named: "MedicalAlarm")!, priority: 1, firstCode: 100, lastCode: 109)
    let fireAlarm = EventType(name: "FIRE ALARM", color: NSColor.red.cgColor, image: NSImage(named: "FireAlarmImage")!, priority: 2, firstCode: 110, lastCode: 119)
    let panicAlarm = EventType(name: "PANIC ALARM", color: NSColor.red.cgColor, image: NSImage(named: "PanicImage")!, priority: 3, firstCode: 120, lastCode: 129)
    let burglarAlarm = EventType(name: "BURGLAR ALARM", color: NSColor.red.cgColor, image: NSImage(named: "BurglarAlarmImage")!, priority: 4, firstCode: 130, lastCode: 139)
    let generalAlarm = EventType(name: "GENERAL ALARM", color: NSColor.red.cgColor, image: NSImage(named: "GeneralAlarm")!, priority: 5, firstCode: 150, lastCode: 163)
    let trouble = EventType(name: "TROUBLE", color: NSColor.blue.cgColor, image: NSImage(named: "TroubleImage")!, priority: 6, firstCode: 300, lastCode: 393)
    let openClose = EventType(name: "OPEN CLOSE", color: NSColor.green.cgColor, image: NSImage(named: "OpenCloseImage")!, priority: 7, firstCode: 400, lastCode: 466)
    let test = EventType(name: "TEST", color: NSColor.gray.cgColor, image: NSImage(named: "UnknownImage")!, priority: 8, firstCode: 601, lastCode: 616)
    let fireSupervisory = EventType(name: "FIRE SUPERVISORY", color: NSColor.red.cgColor, image: NSImage(named: "UnknownImage")!, priority: 9, firstCode: 200, lastCode: 206)
    let protectionLoop = EventType(name: "PROTECTION LOOP", color: NSColor.blue.cgColor, image:NSImage(named: "UnknownImage")!, priority: 10, firstCode: 371, lastCode: 378)
    let sensor = EventType(name: "SENSOR", color: NSColor.red.cgColor, image:NSImage(named: "UnknownImage")!, priority: 11, firstCode: 380, lastCode: 385)
    let systemAcces = EventType(name: "SYSTEMACCES", color: NSColor.red.cgColor, image:NSImage(named: "UnknownImage")!, priority: 12, firstCode: 411, lastCode: 434)
    let disables = EventType(name: "DISABLES", color: NSColor.red.cgColor, image:NSImage(named: "UnknownImage")!, priority: 13, firstCode: 501, lastCode: 553)
    let bypass = EventType(name: "BYPAS", color: NSColor.red.cgColor, image:NSImage(named: "UnknownImage")!, priority: 14, firstCode: 570, lastCode: 579)
    let eventLog = EventType(name: "EVENT LOG", color: NSColor.red.cgColor, image:NSImage(named: "UnknownImage")!, priority: 15, firstCode: 621, lastCode: 628)
    let schedule = EventType(name: "SCHEDULE", color: NSColor.red.cgColor, image:NSImage(named: "UnknownImage")!, priority: 16, firstCode: 630, lastCode: 632)
    let miscelaneous = EventType(name: "MISCELANEOUS", color: NSColor.red.cgColor, image:NSImage(named: "UnknownImage")!, priority: 17, firstCode: 654, lastCode: 962)
    let unknownEvent = EventType(name: "UNKNOWN EVENT", color: NSColor.yellow.cgColor, image:NSImage(named: "UnknownImage")!, priority: 18, firstCode: 0, lastCode: 0)
    
    lazy var eventTypes: [EventType] = [ medicalAlarm, fireAlarm, panicAlarm, burglarAlarm, generalAlarm, trouble, openClose, test, fireSupervisory, protectionLoop, sensor, systemAcces, disables, bypass, eventLog, schedule, miscelaneous, unknownEvent]
    
    func getEventType(eventCode: Int?, eventGroup: String) -> EventType? {
        var eventType: EventType?
        var eventCodeIsValid = false
        if eventCode != nil {
            for searchedEventType in eventTypes {
                if eventCode! >= searchedEventType.firstCode && eventCode! <= searchedEventType.lastCode {
                    eventCodeIsValid = true
                    eventType = searchedEventType
                    eventType!.name = searchedEventType.name
                    if eventGroup == "1" {
                        eventType!.color = searchedEventType.color
                    } else {
                        if eventType!.name == openClose.name {
                            eventType!.color = NSColor.orange.cgColor
                        } else {
                            eventType!.color = NSColor.lightGray.cgColor
                        }
                    }
                    eventType!.image = searchedEventType.image
                }
            }
            guard eventCodeIsValid else {
                print("Invalid CID code!")
                return unknownEvent
            }
        }
        return eventType
    }
    
    func getEventTypeAndPriority(event: Event) -> (String, Int) {
        for eventType in eventTypes {
            if Int(event.cid)! >= eventType.firstCode && Int(event.cid)! <= eventType.lastCode {
                return (eventType.name, eventType.priority)
            }
        }
        
        return ("UNKNOWN EVENT", 0)
    }
    
    func getEventColor(cid: String, group: String) {
        
        
    }
    
}
