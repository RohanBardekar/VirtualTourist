//
//  ActivityIndicator.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit
import Foundation

final class ActivityIndicator: UIView {
    
    var activityIndicator = UIActivityIndicatorView()
    let heightActivitiIndicator = CGFloat(40)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGray
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicator.color = UIColor.black
        activityIndicator.center.x = self.center.x
        activityIndicator.center.y = self.frame.height * 0.5
        self.addSubview(activityIndicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
       
        fatalError("init(coder:) not implemented")
    }
}
