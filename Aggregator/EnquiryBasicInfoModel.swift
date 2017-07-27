//
//  EnquiryBasicInfoModel.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/27/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class UserEnquiryDetails : NSObject
{
    
    let first_name : String
    let last_name : String
    let phone : String
    let email_address : String

    init(firstName : String , lastName : String, phone : String, email_address : String)

 {
    
    self.first_name = firstName
    self.last_name = lastName
    self.email_address = email_address
    self.phone = phone
}
}
