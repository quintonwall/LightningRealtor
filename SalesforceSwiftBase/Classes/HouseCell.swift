//
//  HouseCell.swift
//  LightningRealtor
//
//  Created by Quinton Wall on 3/8/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import UIKit

class HouseCell: UICollectionViewCell {

    @IBOutlet weak var propertyImage : UIImageView!
    @IBOutlet weak var numLikes : UILabel!
    var houseId : String!
    
    
    
    var propertyImageUrl = "" {
        didSet {
            loadImage(propertyImageUrl)
           
        }
    }
    
    
    
    
    func loadImage(url:String) {
        // load image
        let image_url:String = url
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let url:NSURL = NSURL(string:image_url)!
            let data:NSData = NSData(contentsOfURL: url)!
            
            // update ui
            dispatch_async(dispatch_get_main_queue()) {
                self.propertyImage.image = UIImage(data: data)!
            }
        }
        
    }
   
}
