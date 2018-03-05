//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 17/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
  
    static let coreDataStack = CoreDataStack(modelName: "VirtualTourist")!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count-1] as URL)
        
        return true
    }
   
}

