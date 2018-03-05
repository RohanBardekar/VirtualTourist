//
//  CoreDataPropertyForPhoto.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import CoreData
import Foundation

extension Photo {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        
        return NSFetchRequest<Photo>(entityName: Constant.photo);
    }
    
    @NSManaged public var photo: Data?
    @NSManaged public var pin: Pin?
    @NSManaged public var stringURL: String?
    @NSManaged public var id: String?
    
}
