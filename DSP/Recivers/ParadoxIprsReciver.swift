//
//  IPRS-7.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//

import Foundation

protocol IprsReciverDelegate {
    var blackList: [String] {get set}
}

class Iprs: ReciverProtocol {
    var delegate: IprsReciverDelegate?
    
    private var iprsCSVLogFilesPath = "/Volumes/home/iprs/201903"
    private var textFilesTools = FilesTools()
    
    private let medicalAlarmCID    = (firstCode: 100, lastCode: 109, priority: 1)
    private let fireAlarmCID       = (firstCode: 110, lastCode: 119, priority: 2)
    private let panicAlarmCID      = (firstCode: 120, lastCode: 129, priority: 3)
    private let burglarAlarmCID    = (firstCode: 130, lastCode: 139, priority: 4)
    private let generalAlarmmCID   = (firstCode: 150, lastCode: 163, priority: 5)
    private let troubleCID         = (firstCode: 300, lastCode: 393, priority: 6)
    private let openCloseCID       = (firstCode: 400, lastCode: 466, priority: 7)
    private let testCID            = (firstCode: 601, lastCode: 616, priority: 8)
    private let fireSupervisoryCID = (firstCode: 200, lastCode: 206, priority: 9)
    private let protectionLoopCID  = (firstCode: 371, lastCode: 378, priority: 10)
    private let sensorCID          = (firstCode: 380, lastCode: 385, priority: 11)
    private let systemAccesCID     = (firstCode: 411, lastCode: 434, priority: 12)
    private let disablesCID        = (firstCode: 501, lastCode: 553, priority: 13)
    private let bypassCID          = (firstCode: 570, lastCode: 579, priority: 14)
    private let eventLogCID        = (firstCode: 621, lastCode: 628, priority: 15)
    private let scheduleCID        = (firstCode: 630, lastCode: 632, priority: 16)
    private let miscelaneousCID    = (firstCode: 654, lastCode: 962, priority: 17)
    
}

extension Iprs {
    
    func getEvents() -> [AccountEvents] {
        var accountEvents = [AccountEvents]()
        let textFiles = textFilesTools.getTextFromFile(from: iprsCSVLogFilesPath, fileType: "csv")
        if textFiles.count > 0 {
            for file in textFiles {
                let fileName = file.FileName
                let accountID = textFilesTools.cutFromTextLine(TextLine: fileName, From: 8, To: 12)
                if !delegate!.blackList.contains(accountID) {
                    let account = AccountEvents(id: accountID)
                    let textLines = file.Content.components(separatedBy: "\n")
                    for textLine in textLines {
                        if textLine != "" {
                            let splitTextEvent = textLine.components(separatedBy: ",")
                            let eventName = textFilesTools.replaceCharInString(string: splitTextEvent[5], charToBeReplaced: "\"", with: "")
                            let cidAndGroup = splitTextEvent[2].components(separatedBy: " ")
                            let cid = cidAndGroup[1]
                            let group = Int(cidAndGroup[0])!
                            var partition = splitTextEvent[3]
                            for _ in partition {
                                let index = partition.index(partition.startIndex, offsetBy: 0)
                                if partition[index] == "0" && partition.count > 1 {
                                    partition.remove(at: index)
                                } else {break}
                            }
                            var zoneOrUser = splitTextEvent[4]
                            for _ in zoneOrUser {
                                let index = zoneOrUser.index(zoneOrUser.startIndex, offsetBy: 0)
                                if zoneOrUser[index] == "0" && zoneOrUser.count > 1 {
                                    zoneOrUser.remove(at: index)
                                } else {break}
                            }
                            let priority = getEventPriority(eventCode: Int(cid)!)
                            let event = Event(priority: priority, date: NSDate(), cid: cid, eventName: eventName.uppercased(), partition: Int(partition)!, zoneOrUser: Int(zoneOrUser)!, group: group)
                            account.events.append(event)
                        }
                    }
                    if account.events.count > 0 {
                        accountEvents.append(account)
                    }
                }
            }
        }
        return accountEvents
    }
    
    private func getEventPriority(eventCode: Int) -> Int {
        let cidCodes = [medicalAlarmCID, fireAlarmCID, panicAlarmCID, burglarAlarmCID, generalAlarmmCID, troubleCID, openCloseCID, testCID, fireSupervisoryCID, protectionLoopCID, sensorCID, systemAccesCID, disablesCID, bypassCID, eventLogCID, scheduleCID, miscelaneousCID]
        var foundCid = false
        for cid in cidCodes {
            if eventCode >= cid.firstCode && eventCode <= cid.lastCode {
                foundCid = true
                return cid.priority
            }
        }
        if !foundCid {
            return 88
        }
    }
}








