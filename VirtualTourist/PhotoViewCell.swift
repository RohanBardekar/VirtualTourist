//
//  PhotoViewCell.swift
//  VirtualTourist
//
//  Created by Rohan Bardekar on 18/08/17.
//  Copyright © 2017 Onbinge. All rights reserved.
//

import UIKit

final class PhotoViewCell: UICollectionViewCell {
   
@IBOutlet weak var collectionImageView: UIImageView!
    
    var cancelTaskCellReused: URLSessionTask? {
        didSet {
            if let cancelTask = oldValue {
                cancelTask.cancel()
            }
        }
    }
}

