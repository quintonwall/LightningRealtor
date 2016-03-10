//
//  HouseListInterfaceController.swift
//  LightningRealtor
//
//  Created by Quinton Wall on 3/10/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class HouseListInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
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
            self.getHouseList()
        }
    }
    
    private func getHouseList() {
        
        let applicationData = ["request-type":"houses-list"]
        
        
        if (WCSession.defaultSession().reachable) {
            session.sendMessage(applicationData, replyHandler: { reply in
                print(reply)
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
        
        resultsTable.setNumberOfRows(results.count, withRowType: "HouseRow")
        
        for (index, record) in results.enumerate() {
            let row = resultsTable.rowControllerAtIndex(index) as! HouseDetailRowController
            
            let s: NSDictionary = record as! NSDictionary
            row.houseid = s["House__c"] as? String
            row.loadImage((s["Default_picture_URL__c"] as? String)!, forImageView: row.propertyImage)
            row.propertyImageUrl = s["Default_picture_URL__c"] as? String
            
            if let cs = s["expr0"] as? Int {
                row.numLikes.setText(String(cs))
            }
            else {
                row.numLikes.setText("0")
            }
   
        }
        
    }
    
    override func contextForSegueWithIdentifier(segueIdentifier: String, inTable table: WKInterfaceTable, rowIndex: Int) -> AnyObject? {
        let row = table.rowControllerAtIndex(rowIndex) as? HouseDetailRowController
        
        var selectedHouse : Dictionary<String, String> = Dictionary()
        selectedHouse["houseid"] = row?.houseid
        
        return selectedHouse

    }
    
    
    override func didDeactivate() {
        //listDocument.closeWithCompletionHandler(nil)
    }
    
    
}


