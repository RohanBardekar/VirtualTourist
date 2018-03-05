//
//  CoreDataClassForPhoto.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import CoreData
import Foundation

public class Photo: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        
        let entityDescription = NSEntityDescription.entity(forEntityName: Constant.photo, in: context)!
        super.init(entity: entityDescription, insertInto: context)
        self.stringURL = dictionary[Constant.urlM] as? String
        self.id = dictionary[Constant.id] as? String
        
    }
}
