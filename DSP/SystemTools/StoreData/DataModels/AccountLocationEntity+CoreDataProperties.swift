//
//  AccountLocationEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 11/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension AccountLocationEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountLocationEntity> {
        return NSFetchRequest<AccountLocationEntity>(entityName: "AccountLocationEntity")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var adress1: String?
    @NSManaged public var adress2: String?
    @NSManaged public var city: String?
    @NSManaged public var county: String?
    @NSManaged public var account: AccountEntity?

}
