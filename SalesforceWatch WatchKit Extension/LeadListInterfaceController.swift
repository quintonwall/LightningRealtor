//
//  LeadListInterfaceController.swift
//  SalesforceWatch
//
//  Created by Quinton Wall on 3/3/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity  //new for watchOS2

class LeadListInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    @IBOutlet weak var resultsTable: WKInterfaceTable!
    // MARK: Interface Life Cycle
    
    
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
            self.getLeadList()
        }
    }
    
    private func getLeadList() {
        
        let applicationData = ["request-type":"property-leads"]
        
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
       
        resultsTable.setNumberOfRows(results.count, withRowType: "LeadRows")
        
        for (index, record) in results.enumerate() {
            let row = resultsTable.rowControllerAtIndex(index) as! LeadDetailsRowController
            
            let s: NSDictionary = record as! NSDictionary
           
            let url = s["House__r"]!["Default_picture_URL__c"] as? String

            row.loadImage(url!, forImageView: row.image)
            //row.propertyImageUrl = s["House__r"]!["Default_picture_URL__c"] as? String
            row.recordid = s["Id"] as? String
            row.nameLabel.setText(s["Name"] as? String)
            row.customerName = s["Name"] as? String
            row.houseId = s["House__c"] as? String
        }
        
    }

    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        let row = table.rowControllerAtIndex(rowIndex) as? LeadDetailsRowController
       
        let selectedRecord = Lead(leadid: (row?.recordid)!, imageurl: (row?.propertyImageUrl)!, houseid: (row?.houseId)!, customerName: (row?.customerName)!, preapprovalid: "", status: "", creditscore: "", mincredit: "")
        
        return selectedRecord
    }
    
    
    override func didDeactivate() {
        //listDocument.closeWithCompletionHandler(nil)
    }

    
}
