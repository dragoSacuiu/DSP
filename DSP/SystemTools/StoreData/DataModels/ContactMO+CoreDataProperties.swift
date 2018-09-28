//
//  ContactMO+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 15/09/2018.
//  Copyright © 2018 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension ContactMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactMO> {
        return NSFetchRequest<ContactMO>(entityName: "ContactMO")
    }

    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    @NSManaged public var priority: String?
    @NSManaged public var user: String?
    @NSManaged public var objective: ObjectiveMO?

}
