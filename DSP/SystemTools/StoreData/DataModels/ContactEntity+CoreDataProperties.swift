//
//  ContactEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 22/02/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactEntity> {
        return NSFetchRequest<ContactEntity>(entityName: "ContactEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var observations: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var priority: Int16
    @NSManaged public var userNumber: Int16
    @NSManaged public var position: String?
    @NSManaged public var objective: AccountEntity?

}
