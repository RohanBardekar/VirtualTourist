//
//  CoreDataClassForPin.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation
import CoreData
import MapKit

public class Pin: NSManagedObject, MKAnnotation {
    
    public var coordinate: CLLocationCoordinate2D {
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
   override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Constant.pin, in: context)!
        super.init(entity: entity, insertInto: context)
        self.latitude = latitude
        self.longitude = longitude
    }
}
