//
//  Protocols.swift
//  DSP
//
//  Created by Sacuiu Dragos on 27/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation
import CoreData


protocol ReciverProtocol {
    func getEvents() -> [AccountEvents]
}
protocol EventProtocol {
    var priority: Int { get }
    var date: NSDate { get }
    var cid: String { get }
    var name: String { get }
    var partition: Int { get }
    var zoneOrUser: Int { get }
    var group: Int { get }
}




