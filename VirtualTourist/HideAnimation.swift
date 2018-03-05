//
//  HideAnimation.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit
import Foundation

fileprivate protocol ActivityIndicatorAnimation {
    
    static func hide(view: UIView, alpha: Int)
}

final class HideAnimation: ActivityIndicatorAnimation {
    
    static func hide(view: UIView, alpha: Int) {
        
        let duration = Animation.TimeDuration.medium
        UIView.animate(withDuration: TimeInterval(duration), delay: TimeInterval(0), options: [UIViewAnimationOptions.allowUserInteraction, UIViewAnimationOptions.beginFromCurrentState], animations: {
            
            view.alpha = CGFloat(alpha)
        
        },completion: { (_) in
            
            view.removeFromSuperview()
        })
    }
}
