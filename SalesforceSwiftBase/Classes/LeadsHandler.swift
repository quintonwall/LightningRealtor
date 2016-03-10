//
//  Leads.swift
//  SalesforceWatch

// handle interactions with leads that have been raised from the HouseSwiper app.
//
//  Created by Quinton Wall on 3/2/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchConnectivity
import SalesforceSDKCore
import SalesforceRestAPI
import SwiftyJSON

class LeadsHandler: NSObject, WCSessionDelegate {
    
    var session: WCSession!
    
    
    func register() {
        
        
        if (WCSession.isSupported()) {
            session = WCSession.defaultSession()
            session.delegate = self;
            session.activateSession()
        }
    }
    
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("heard a request from the watch")
        
        //make sure we are logged in
        if( !SFAuthenticationManager.sharedManager().haveValidSession) {
            print("not logged in")
            replyHandler(["error": "not logged in"])
        } else {
            print("prep request")
            let sharedInstance = SFRestAPI.sharedInstance()
            
            let reqType = message["request-type"] as! String
            
            if(reqType == "property-leads") {
                let query = String("select Name, FirstName, LastName, House__c, House__r.Default_picture_URL__c, Id From Lead where LeadSource = 'Mobile App' order by LastModifiedDate")
                
                sharedInstance.performSOQLQuery(query, failBlock: { error in
                    replyHandler(["error": error])
                    }) { response in  //success
                        //watchos2 only lets us pass primitive types. We need to convert
                        //the dictionary response from salesforce into a json string to pass to
                        //the watch, and then recreate it on the other side..
                        let json = JSON(response)
                        replyHandler(["success": json.rawString()!])
                }
                
                
            }
            else if(reqType == "pre-approval-details") {
                
                let leadid = message["id"] as! String
                
                let query = String("select Id, Applicant__c, Credit_Score__c, Finance__r.Minimum_Salary__c, Status__c from PreApproval__c where Applicant__c =  '"+leadid+"'")
                
                sharedInstance.performSOQLQuery(query, failBlock: { error in
                    replyHandler(["error": error])
                    }) { response in  //success
                        //watchos2 only lets us pass primitive types. We need to convert
                        //the dictionary response from salesforce into a json string to pass to
                        //the watch, and then recreate it on the other side..
                        let json = JSON(response)
                        replyHandler(["success": json.rawString()!])
                }
                
            }
            else if(reqType == "houses-list") {
                
                let query = String("select count(id), house__c, house__r.Default_picture_URL__c from Lead where LeadSource = 'Mobile App' group by house__r.Default_picture_URL__c, house__c order by count(id) DESC")
                
                sharedInstance.performSOQLQuery(query, failBlock: { error in
                    replyHandler(["error": error])
                    }) { response in  //success
                        //watchos2 only lets us pass primitive types. We need to convert
                        //the dictionary response from salesforce into a json string to pass to
                        //the watch, and then recreate it on the other side..
                        let json = JSON(response)
                        replyHandler(["success": json.rawString()!])
                }
                
            }
            else if(reqType == "leads-for-house") {
                
                let houseid = message["id"] as! String
                
                let query = String("select Name, FirstName, LastName, House__c, House__r.Default_picture_URL__c, Id From Lead where House__c = '"+houseid+"'")
                
                sharedInstance.performSOQLQuery(query, failBlock: { error in
                    replyHandler(["error": error])
                    }) { response in  //success
                        //watchos2 only lets us pass primitive types. We need to convert
                        //the dictionary response from salesforce into a json string to pass to
                        //the watch, and then recreate it on the other side..
                        let json = JSON(response)
                        replyHandler(["success": json.rawString()!])
                }
            }
            
        }
    }
    
   }