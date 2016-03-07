//
//  PreApprovalDetailsController.swift
//  LightningRealtor
//
//  Created by Quinton Wall on 3/5/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import Foundation
import WatchKit
import WatchConnectivity  //new for watchOS2

class PreApprovalDetailsController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var propertyImage: WKInterfaceImage!
    @IBOutlet var customerName: WKInterfaceLabel!
    @IBOutlet var creditScore: WKInterfaceLabel!
    @IBOutlet var financeMinCreditScore: WKInterfaceLabel!
    @IBOutlet var approvalStatus: WKInterfaceLabel!
    @IBOutlet var approve: WKInterfaceButton!
    @IBOutlet var reject: WKInterfaceButton!
    
    var preApprovalId: String = ""
    var leadId: String!
    
    
    //used to register the watch and paired phone
    var session : WCSession!
    
    override func awakeWithContext(context: AnyObject?) {
       // precondition(context is Dictionary<String, String> , "Expected class of `context` to be dictionary containing record andid.")
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        
        
        //let row:LeadDetailsRowController = context as! LeadDetailsRowController
        
        //let (recordid, targetobjectid) = context as (String, String)
        let record = context as! Lead
        
        self.leadId = record.leadId
        
        
        self.customerName.setText(record.customerName)
        self.loadImage(record.houseImageUrl, forImageView: propertyImage)
        
        bindToUI(record)
        
    }
    
    func bindToUI(results:Lead) {
        
        self.approvalStatus.setText(results.status.uppercaseString)
        self.creditScore.setText(results.creditScore)
        self.financeMinCreditScore.setText(results.financeMinCreditScore)
        
    }


    func loadImage(url:String, forImageView: WKInterfaceImage) {
        // load image
        let image_url:String = url
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
