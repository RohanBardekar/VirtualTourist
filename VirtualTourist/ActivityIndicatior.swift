//
//  ActivityIndicatior.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit
import Foundation

private var activityIndicator: ActivityIndicator?

protocol ActivityIndicatorDelegate {
   
    func showActivityIndicator()
    func hideActivityIndicator()
}

extension UIViewController: ActivityIndicatorDelegate {
    
    internal func hideActivityIndicator() {
        
        activityIndicator?.activityIndicator.stopAnimating()
        HideAnimation.hide(view: activityIndicator!, alpha: 0)
    }
    
    internal func showActivityIndicator() {
        
        if activityIndicator?.superview != nil {
            
            activityIndicator?.removeFromSuperview()
        }
        
        activityIndicator = ActivityIndicator(frame: UIScreen.screenBounds())
        activityIndicator?.activityIndicator.startAnimating()
        activityIndicator?.alpha = 1
        view.addSubview(activityIndicator!)
    }
    
    internal func showActivityIndicator(topField: CGFloat) {
        
        if activityIndicator?.superview != nil {
            
            activityIndicator?.removeFromSuperview()
        }
        
        activityIndicator = ActivityIndicator(frame: CGRect(x: 0, y: 0 + topField, width: UIScreen.screenWidth(), height: UIScreen.screenHeight() - (0 + topField)))
        activityIndicator?.activityIndicator.startAnimating()
        activityIndicator?.alpha = 1
        view.addSubview(activityIndicator!)
    }
    
   
}



