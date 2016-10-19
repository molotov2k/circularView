//
//  Type+CoreDataProperties.swift
//  Youplus
//
//  Created by Astarta on 10/16/16.
//  Copyright © 2016 Anvil. All rights reserved.
//

import Foundation
import CoreData

extension Type {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Type> {
        return NSFetchRequest<Type>(entityName: "Type");
    }

    @NSManaged public var name: String
    @NSManaged public var index: Int16
    @NSManaged public var items: Set<Item>

}

// MARK: Generated accessors for items
extension Type {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Item)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Item)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
