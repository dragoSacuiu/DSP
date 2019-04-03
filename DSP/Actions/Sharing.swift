//
//  File.swift
//  DSP
//
//  Created by Sacuiu Dragos on 22/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//

import Foundation
import AppKit

class SendEmail {
    private func send(recipients: [String], subject: String, message: [String]) {
        let service = NSSharingService(named: NSSharingService.Name.composeEmail)
        service?.recipients = recipients
        service?.subject = subject
        service?.perform(withItems: message)
    }
    
    func sendTicket(emails: [String], subject: String , account: AccountEntity, message: String) {
        let dateFormater = DateFormatter()
        let user = "User: \(UsersManager.activeUser)"
        let date = "Date: \(dateFormater.string(from: Date()))"
        let client = "Client: \(account.client!)"
        let objective = "Objective: \(account.objective!)"
        let adress = "Adress: \(account.location!.adress1!) \(account.location!.adress2!)"
        let latitude = "Latitude: \(account.location!.latitude)"
        let longitude = "Longitude: \(account.location!.longitude)"
        send(recipients: emails, subject: subject , message: [user, date, " ", client, objective, adress, latitude, longitude, message])
    }
}
