//
//  HouseDetailRowController.swift
//  LightningRealtor
//
//  Created by Quinton Wall on 3/10/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit

class HouseDetailRowController : NSObject {
    
    @IBOutlet var numLikes: WKInterfaceLabel!
    @IBOutlet var propertyImage: WKInterfaceImage!
    var propertyImageUrl : String!
    var houseid : String!
    
    
    
    func loadImage(url:String, forImageView: WKInterfaceImage) {
        // load image
        let image_url:String = url
        propertyImageUrl = image_url
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let url:NSURL = NSURL(string:image_url)!
            let data:NSData = NSData(contentsOfURL: url)!
            let placeholder = UIImage(data: data)!
            
            // update ui
            dispatch_async(dispatch_get_main_queue()) {
                forImageView.setImage(placeholder)
            }
        }
        
    }


}
