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
    let date: String
    let cid: String
    let name: String
    let partition: String
    let zoneOrUser: String
    let group: String
    
    init(priority: Int, date: String, cid: String, eventName: String, partition: String, zoneOrUser: String, group: String) {
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


