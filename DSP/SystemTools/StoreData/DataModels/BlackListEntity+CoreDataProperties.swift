//
//  BlackListEntity+CoreDataProperties.swift
//  DSP
//
//  Created by Sacuiu Dragos on 04/03/2019.
//  Copyright © 2019 Sacuiu Dragos. All rights reserved.
//
//

import Foundation
import CoreData


extension BlackListEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BlackListEntity> {
        return NSFetchRequest<BlackListEntity>(entityName: "BlackListEntity")
    }

    @NSManaged public var accountID: String?
    @NSManaged public var details: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var user: String?
    @NSManaged public var account: NSSet?

}

// MARK: Generated accessors for account
extension BlackListEntity {

    @objc(addAccountObject:)
    @NSManaged public func addToAccount(_ value: AccountEntity)

    @objc(removeAccountObject:)
    @NSManaged public func removeFromAccount(_ value: AccountEntity)

    @objc(addAccount:)
    @NSManaged public func addToAccount(_ values: NSSet)

    @objc(removeAccount:)
    @NSManaged public func removeFromAccount(_ values: NSSet)

}
