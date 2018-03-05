//
//  UIScreen.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import Foundation
import UIKit

extension UIScreen {
   
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static func screenHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
