//
//  ContactEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/12/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
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
    @NSManaged public var phone: String?
    @NSManaged public var priority: String?
    @NSManaged public var user: String?
    @NSManaged public var objective: AccountEntity?

}
