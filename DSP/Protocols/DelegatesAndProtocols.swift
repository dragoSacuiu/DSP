//
//  Protocols.swift
//  DSP
//
//  Created by Sacuiu Dragos on 27/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation



protocol ReciverProtocol {
    func getEvents() -> [AccountEvents]
}
protocol IprsEventProtocol {
    var date: String { get }
    var cid: String { get }
    var eventName: String { get }
    var eventType: String { get }
    var partition: String { get }
    var zoneOrUser: String { get }
    var group: String { get }
    var mac: String { get }
}
