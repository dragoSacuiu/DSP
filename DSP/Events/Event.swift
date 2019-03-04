//
//  Event.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation
import Cocoa

struct Event: EventProtocol {
    let priority: Int
    let date: NSDate
    let cid: String
    let name: String
    let partition: Int
    let zoneOrUser: Int
    let group: Int
    
    init(priority: Int, date: NSDate, cid: String, eventName: String, partition: Int, zoneOrUser: Int, group: Int) {
        self.priority = priority
        self.date = date
        self.cid = cid
        self.name = eventName
        self.partition = partition
        self.zoneOrUser = zoneOrUser
        self.group = group
    }
}

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


