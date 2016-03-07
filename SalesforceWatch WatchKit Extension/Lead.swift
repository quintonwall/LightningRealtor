//
//  Lead.swift
//  LightningRealtor
//
//  Created by Quinton Wall on 3/7/16.
//  Copyright © 2016 Salesforce, Inc. All rights reserved.
//

import Foundation
import WatchKit


class Lead : NSObject {
    var leadId : String
    var houseImageUrl : String
    
    var houseId : String
    var customerName : String
    var preapprovalid : String
    var status : String
    var creditScore : String
    var financeMinCreditScore : String
    
    init(leadid : String, imageurl : String, houseid : String, customerName : String, preapprovalid : String, status : String, creditscore : String, mincredit : String) {
        self.leadId = leadid
        self.houseImageUrl = imageurl
        self.houseId = houseid
        self.customerName = customerName
        self.preapprovalid = preapprovalid
        self.status = status
        self.creditScore = creditscore
        self.financeMinCreditScore = mincredit
    }
    
}
