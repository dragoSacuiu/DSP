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
    
    init(name: String, color: CGColor, image: NSImage) {
        self.name = name
        self.color = color
        self.image = image
    }
}

class EventsManager {
   
    weak var delegate: EventsManagerVCDelegate?
    
    var reciversManager = ReciversManager()
    var storeData = StoreData()
    
    var runDispatchTimer: Timer?
    
    var accountsEvents = [AccountEvents]()
    var accountsDetailes = [AccountEntity]()
    
    let redColor = NSColor.systemRed.cgColor
    let blueColor = NSColor.systemBlue.cgColor
    let greenColor = NSColor.systemGreen.cgColor
    let yellowCollor = NSColor.yellow.cgColor
    let orangeColor = NSColor.systemOrange.cgColor
    let grayColor = NSColor.lightGray.cgColor
    let whiteColor = NSColor.white.cgColor
    
    let eventRestoreColor = NSColor.white.cgColor
    let systemDisarmColor = NSColor.systemYellow.cgColor
    
    let medicalAlarmImage = NSImage(named: "MedicalAlarm")!
    let panicAlarmImage = NSImage(named: "PanicImage")!
    let burglarAlarmImage = NSImage(named: "BurglarAlarmImage")!
    let fireAlarmImage = NSImage(named: "FireAlarmImage")!
    let generalAlarmImage = NSImage(named: "GeneralAlarm")!
    let troubleImage = NSImage(named: "TroubleImage")!
    let openCloseImage = NSImage(named: "OpenCloseImage")!
    let unknownImage = NSImage(named: "UnknownImage")!
    
    
    func run(getEventsTimeInterval: Double) {
        runDispatchTimer = Timer.scheduledTimer(timeInterval: getEventsTimeInterval , target: self, selector: #selector(getEvents), userInfo: nil, repeats: true)
    }
    func stop() {
        runDispatchTimer!.invalidate()
    }
    
    @objc func getEvents() {
        let events = reciversManager.getEventsFromRecivers()
        if events.count > 0 {
            filterEvents(events: events)
            delegate?.reloadTableViewData()
        }
    }
    
    func removeLowPriorityEvents() {
        
    }
}


extension EventsManager {
    
    func filterEvents(events: [AccountEvents]) {
        let newAccountEvents = events
        if accountsEvents.count == 0 {
            accountsEvents.append(contentsOf: newAccountEvents)
            for account in newAccountEvents {
                let accountModel = storeData.getAccountMO(accountId: account.id)
                accountsDetailes.append(accountModel)
            }
        } else {
            for newAccount in newAccountEvents {
                var matchAccount = false
                for accountIndex in 0..<accountsEvents.count {
                    if accountsEvents[accountIndex].id == newAccount.id {
                        accountsEvents[accountIndex].events.append(contentsOf: newAccount.events)
                        matchAccount = true
                        break
                    }
                }
                if !matchAccount {
                    accountsEvents.append(newAccount)
                    let accountModel = storeData.getAccountMO(accountId: newAccount.id)
                    accountsDetailes.append(accountModel)
                }
            }
        }
    }
    
    func priorityEventExists() {
        var foundPriorityEvent = false
        for i in 0..<accountsEvents.count {
            for event in accountsEvents[i].events {
                if event.priority < 9 && event.group == "1" {
                    foundPriorityEvent = true
                    break
                }
            }
            if !foundPriorityEvent {
                accountsEvents.remove(at: i)
            }
        }
    }
    
    func getEventType(eventPriority: Int, eventGroup: String) -> EventType {
        
        switch eventPriority {
            
        case 1: let medicalAlarmEventType = EventType(name: "MEDICAL ALARM", color: redColor, image: medicalAlarmImage)
            if eventGroup == "3" {
                medicalAlarmEventType.color = eventRestoreColor
            }
            return medicalAlarmEventType
            
        case 2: let fireAlarmEventType = EventType(name: "FIRE ALARM", color: redColor, image: fireAlarmImage)
            if eventGroup == "3" {
                fireAlarmEventType.color = eventRestoreColor
            }
            return fireAlarmEventType
            
        case 3: let panicAlarmEventType = EventType(name: "PANIC ALARM", color: redColor, image: panicAlarmImage)
            if eventGroup == "3" {
                panicAlarmEventType.color = eventRestoreColor
            }
            return panicAlarmEventType
            
        case 4: let burglarAlarmType = EventType(name: "BURGLAR ALARM", color: redColor, image: burglarAlarmImage)
            if eventGroup == "3" {
                burglarAlarmType.color = eventRestoreColor
            }
            return burglarAlarmType
            
        case 5: let generalAlarmEventType = EventType(name: "GENERAL ALARM", color: redColor, image: generalAlarmImage)
            if eventGroup == "3" {
                generalAlarmEventType.color = eventRestoreColor
            }
            return generalAlarmEventType
            
        case 6: let troubleEventType = EventType(name: "TROUBLE", color: blueColor, image: troubleImage)
            if eventGroup == "3" {
                troubleEventType.color = eventRestoreColor
            }
            return troubleEventType
            
        case 7: let openCloseEventType = EventType(name: "OPEN CLOSE", color: greenColor, image: openCloseImage)
            if eventGroup == "1" {
                openCloseEventType.color = systemDisarmColor
            }
            return openCloseEventType
            
        case 8: let testEventType = EventType(name: "TEST", color: grayColor, image: unknownImage)
            if eventGroup == "3" {
                testEventType.color = eventRestoreColor
            }
            return testEventType
            
        case 9: let fireSupervisoryEventType = EventType(name: "FIRE SUPERVISORY", color: blueColor, image: unknownImage)
            if eventGroup == "3" {
                fireSupervisoryEventType.color = eventRestoreColor
            }
            return fireSupervisoryEventType
            
        case 10: let protectionLoopEventType = EventType(name: "PROTECTION LOOP", color: blueColor, image: unknownImage)
            if eventGroup == "3" {
                protectionLoopEventType.color = eventRestoreColor
            }
            return protectionLoopEventType
            
        case 11: let sensorEvetType = EventType(name: "SENSOR", color: blueColor, image: unknownImage)
            if eventGroup == "3" {
                sensorEvetType.color = eventRestoreColor
            }
            return sensorEvetType
            
        case 12: let systemAccesEventType = EventType(name: "SYSTEMACCES", color: orangeColor, image: unknownImage)
            if eventGroup == "3" {
                systemAccesEventType.color = eventRestoreColor
            }
            return systemAccesEventType
            
        case 13: let disableEventType = EventType(name: "DISABLES", color:orangeColor, image: unknownImage)
            if eventGroup == "1" {
                disableEventType.color = eventRestoreColor
            }
            return disableEventType
            
        case 14: let bypassEventType = EventType(name: "BYPAS", color: orangeColor, image: unknownImage)
            if eventGroup == "3" {
                bypassEventType.color = eventRestoreColor
            }
            return bypassEventType
            
        case 15: let eventLogEventType = EventType(name: "EVENT LOG", color: grayColor, image: unknownImage)
            if eventGroup == "3" {
                eventLogEventType.color = eventRestoreColor
            }
            return eventLogEventType
            
        case 16: let scheduleEventType = EventType(name: "SCHEDULE", color: whiteColor, image: unknownImage)
            if eventGroup == "3" {
                scheduleEventType.color = eventRestoreColor
            }
            return scheduleEventType
            
        case 17: let miscelaneousEventType = EventType(name: "MISCELANEOUS", color: whiteColor, image: unknownImage)
            if eventGroup == "3" {
                miscelaneousEventType.color = eventRestoreColor
            }
            return miscelaneousEventType
            
        default:
            return EventType(name: "UNKNOWN EVENT", color: whiteColor, image: unknownImage)
        }
    }
}
