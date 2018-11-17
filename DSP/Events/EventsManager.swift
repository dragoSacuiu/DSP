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
    let eventTypes = [ EventType(name: "ALARM", firstCode: 100, lastCode: 206),
                       EventType(name: "TROUBLE", firstCode: 300, lastCode: 393),
                       EventType(name: "OPEN CLOSE", firstCode: 400, lastCode: 466),
                       EventType(name: "TEST", firstCode: 601, lastCode: 616),
                       EventType(name: "FIRE SUPERVISORY", firstCode: 200, lastCode: 206),
                       EventType(name: "PROTECTION LOOP", firstCode: 371, lastCode: 378),
                       EventType(name: "SENSOR", firstCode: 380, lastCode: 385),
                       EventType(name: "SYSTEMACCES", firstCode: 411, lastCode: 434),
                       EventType(name: "DISABLES", firstCode: 501, lastCode: 553),
                       EventType(name: "BYPAS", firstCode: 570, lastCode: 579),
                       EventType(name: "EVENT LOG", firstCode: 621, lastCode: 628),
                       EventType(name: "SCHEDULE", firstCode: 630, lastCode: 632),
                       EventType(name: "MISCELANEOUS", firstCode: 654, lastCode: 962) ]
    
    func getEventType(eventCode: Int?) -> String{
        if eventCode != nil {
            for eventType in eventTypes {
                if eventCode! >= eventType.firstCode && eventCode! <= eventType.lastCode {
                    return eventType.name
                }
            }
        }
        return "Unknown code"
    }
}
