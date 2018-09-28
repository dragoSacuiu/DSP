//
//  File.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

struct EventType {
    let name: String
    let firstCode: Int
    let lastCode: Int
    init(name: String, firstCode: Int, lastCode: Int) {
        self.name = name
        self.firstCode = firstCode
        self.lastCode = lastCode
    }
}

struct EventsManager {
    let eventTypes = [ EventType(name: "Alarm", firstCode: 100, lastCode: 169),
                       EventType(name: "Trouble", firstCode: 300, lastCode: 357),
                       EventType(name: "Open Close", firstCode: 400, lastCode: 466),
                       EventType(name: "Test", firstCode: 601, lastCode: 616),
                       EventType(name: "Fire Supervisory", firstCode: 200, lastCode: 206),
                       EventType(name: "Protection loop", firstCode: 371, lastCode: 378),
                       EventType(name: "Sensor", firstCode: 380, lastCode: 385),
                       EventType(name: "System acces", firstCode: 411, lastCode: 434),
                       EventType(name: "Disables", firstCode: 501, lastCode: 553),
                       EventType(name: "Bypass", firstCode: 570, lastCode: 579),
                       EventType(name: "Event log", firstCode: 621, lastCode: 628),
                       EventType(name: "Schedule", firstCode: 630, lastCode: 632),
                       EventType(name: "Special Codes", firstCode: 651, lastCode: 789),
                       EventType(name: "Miscellaneous", firstCode: 654, lastCode: 962) ]
    
    func getEventType(eventCode: String) -> String{
        for eventType in eventTypes {
            if Int(eventCode)! > eventType.firstCode && Int(eventCode)! < eventType.lastCode {
                return eventType.name
            }
        }
        return "Unknown code"
    }
}
