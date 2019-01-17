//
//  Event.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

struct Event: EventProtocol {
    let priority: Int
    let date: String
    let cid: String
    let name: String
    let type: String
    let partition: String
    let zoneOrUser: String
    let group: String
    
    init(priority: Int, date: String, cid: String, eventName: String, type: String, partition: String, zoneOrUser: String, group: String) {
        self.priority = priority
        self.date = date
        self.cid = cid
        self.name = eventName
        self.type = type
        self.partition = partition
        self.zoneOrUser = zoneOrUser
        self.group = group
    }
}



