////
////  CoreDataExtension.swift
////  The Mouve
////
////  Created by Hilal Habashi on 7/16/15.
////  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//extension NSManagedObjectContext {
//    
//    func insert<T : NSManagedObject>(entity: T.Type) -> T {
//        let entityName = entity.entityName
//        return NSEntityDescription.insertNewObjectForEntityForName(entityName, inManagedObjectContext:self) as! T
//    }
//    
//}