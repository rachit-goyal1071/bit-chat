//
//  MessageEntity+CoreDataProperties.swift
//  BitChat
//
//  Created by Rachit Goyal on 08/08/25.
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var isSynced: Bool
    @NSManaged public var sender: String?
    @NSManaged public var text: String?
    @NSManaged public var timestamp: Date?

}

extension MessageEntity : Identifiable {

}
