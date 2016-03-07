//
//  PreApprovalRowController.swift
//  LightningRealtor
//
//  Created by Quinton Wall on 3/7/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit



class PreApprovalRowController: NSObject {

    var id : String!
    var leadid : String!
    var creditScore : String!
    var minCreditScore : String!
    var approvalStatus : String!
    
    
    @IBOutlet var status: WKInterfaceLabel!
}
