//
//  LeadDetailsRowController.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 3/3/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit



class LeadDetailsRowController: NSObject {
    
    //use this for setting the step identifier
    @IBOutlet weak var image: WKInterfaceImage!
    //use this for setting step comment from process
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    @IBOutlet var imageGroup: WKInterfaceGroup!
    
    //target object id
    var propertyImageUrl: String!
    
    //process instance id
    var recordid: String!
    
    var customerName: String!  //need to store separately because stupid WKInterfaceLabel doesnt have an accessor!!
    
    var houseId: String!
    
    
    
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