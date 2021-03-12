//
//  LocalUser+CoreDataProperties.swift
//  
//
//  Created by Thien Nguyen on 9/3/21.
//
//

import Foundation
import CoreData


extension LocalUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LocalUser> {
        return NSFetchRequest<LocalUser>(entityName: "LocalUser")
    }

    @NSManaged public var email: String?
    @NSManaged public var password: String?

}
