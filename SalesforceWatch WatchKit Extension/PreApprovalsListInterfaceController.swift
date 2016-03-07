//
//  PreApprovalsListInterfaceController.swift
//  LightningRealtor
//
//  Created by Quinton Wall on 3/7/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity  //new for watchOS2

class PreApprovalsListInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    @IBOutlet weak var resultsTable: WKInterfaceTable!
    @IBOutlet var newPreApprovalButton: WKInterfaceButton!
    
    var lead : Lead!
    
    @IBOutlet var headerImage: WKInterfaceImage!
    @IBOutlet var customerName: WKInterfaceLabel!
    
    //used to register the watch and paired phone
    var session : WCSession!
    
    //if app starts from the glance
    override func handleUserActivity(userInfo: [NSObject : AnyObject]!) {
        
        if let results = userInfo["results"] as? NSArray {
            loadTableData(results)
        }
    }
    
    //if context comes from a prepareForSeque call
    override func awakeWithContext(context: AnyObject?) {
        
        
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
            
            self.lead = context as! Lead
            self.customerName.setText(lead.customerName)
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let url:NSURL = NSURL(string:self.lead.houseImageUrl)!
                let data:NSData = NSData(contentsOfURL: url)!
                let placeholder = UIImage(data: data)!
                
                // update ui
                dispatch_async(dispatch_get_main_queue()) {
                    self.headerImage.setImage(placeholder)
                }
            }
            
            self.getPreApprovals()
        }
    }
    
    
    private func getPreApprovals() {
        
        let applicationData = ["request-type" : "pre-approval-details", "id" : self.lead.leadId]
        
        if (WCSession.defaultSession().reachable) {
            session.sendMessage(applicationData, replyHandler: { reply in
                //handle iphone response here
                if(reply["success"] != nil) {
                    let x:String = reply["success"] as! String
                    
                    
                    let res = SalesforceObjectType.convertStringToDictionary(x)
                    //print(res!["records"])
                    self.loadTableData(res!["records"] as! NSArray)
                }
                },
                errorHandler: {(error ) -> Void in
                    // catch any errors here
                    print("Something went wrong: \(error)")
            })
        }
        
    }
    
    private func loadTableData(results: NSArray) {
        
        //withRowType needs to be the identifier you give the table in your storyboard
        
        resultsTable.setNumberOfRows(results.count, withRowType: "PreApprovals")
        
        for (index, record) in results.enumerate() {
            let row = resultsTable.rowControllerAtIndex(index) as! PreApprovalRowController
           //  print(record)
            let s: NSDictionary = record as! NSDictionary
            
             row.id = s["Id"] as? String
            row.leadid = s["Applicant__c"] as? String
            let upStatus = s["Status__c"] as? String
            row.status.setText(upStatus!.uppercaseString)
            
        
            //credit score is stored as an int in salesforce and may be nil depending on the 
            //status of the pre-approval.
            if let cs = s["Credit_Score__c"] as? Int {
                row.creditScore = String(cs)
            }
            else {
                row.creditScore = ""
            }
            
            if let f = s["Finance__r"]?["Minimum_Salary__c"] as? Int {
                row.minCreditScore = String(f)
            }
            else {
                row.minCreditScore = ""
            }
            
            
          
            //row.minCreditScore = s["Finance__r"]?["Minimum_Salary__c"] as? String
            row.approvalStatus = s["Status__c"] as? String  //store sep as watchos has no getter on labels :(
            
        }
        
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        let row = table.rowControllerAtIndex(rowIndex) as? PreApprovalRowController
        
        var creditScore = ""
        if let a = row?.creditScore {
            creditScore = a
        }
        
        var minCreditScore = ""
        if let a = row?.minCreditScore {
            minCreditScore = a
        }
        
        
        let selectedRecord = Lead(leadid: (row?.leadid)!, imageurl: self.lead.houseImageUrl , houseid: self.lead.houseId, customerName: self.lead.customerName, preapprovalid : (row?.id)!, status : (row?.approvalStatus)!, creditscore: creditScore, mincredit: minCreditScore)
        
        return selectedRecord
    }
    
    
    @IBAction func newPreApprovalTapped() {
        
    }
    
    override func didDeactivate() {
        //listDocument.closeWithCompletionHandler(nil)
    }

}














