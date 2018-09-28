//
//  Event.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

struct Event {
    let date: String
    let cid: String
    let eventName: String
    let eventType: String
    let partition: String
    let zoneOrUser: String
    let group: String
    let mac: String
    
    init(date: String, cid: String, eventName: String, eventType: String, partition: String, zoneOrUser: String, group: String, mac: String) {
        self.date = date
        self.cid = cid
        self.eventName = eventName
        self.eventType = eventType
        self.partition = partition
        self.zoneOrUser = zoneOrUser
        self.group = group
        self.mac = mac
    }
}
