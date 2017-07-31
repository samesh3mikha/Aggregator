//
//  EnquiryDetailsVM.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 7/31/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class EnquiryDetailsVM: NSObject {
    var enquiryID: String! = ""
    var enquiryDetailsModel: EnquiryDetailsModel? = nil
    var fetchEnquiryDetailsCallback: DataSyncedSignal? = nil
    
    init(enquiryID: String) {
        self.enquiryID = enquiryID
    }

    // MARK: DATA DOWNLOAD
    func fetchEnquiryDetails(completionBlock: @escaping DataSyncedSignal) {
        if enquiryID.isBlank {
            completionBlock(false, "Invalid Enquiry Id provided!")
            return
        }
        let params : Parameters = [
            "actionname": "enquiry_reply ",
            "data": [
                ["enquiry_id": enquiryID],
                ["flag": "S"]
            ]
        ]
        DataSynchronizer.syncData(params: params, completionBlock: { [weak self] (isRequestASuccess, message, data) in
            guard let weakself = self else {
                return
            }
            if isRequestASuccess {
                let responseKey = "rto-form"
                if let responseArray = data[responseKey].arrayObject as? [[String:AnyObject]] {
                    weakself.parseData(data: responseArray[0])
                }
            }
            completionBlock(isRequestASuccess, message)
        })
    }
    
    // MARK: DATA PARSER
    func parseData(data: [String: AnyObject]) {
        enquiryDetailsModel = EnquiryDetailsModel(
            firstName: dataForKey(key: "first_name", data: data), 
            lastName: dataForKey(key: "last_name", data: data), 
            phone: dataForKey(key: "phone_number", data: data), 
            email_address: dataForKey(key: "email_address", data: data), 
            comment: dataForKey(key: "comments", data: data), 
            reply: dataForKey(key: "enquiry_reply_date", data: data), 
            courseName: dataForKey(key: "course_name", data: data), 
            instituteLogoUrl: dataForKey(key: "institute_logo", data: data)
        )
    }
    
    func dataForKey(key: String, data: [String: AnyObject]) -> String {
        if let data = data[key] as? String {
            return data
        }
        return ""
    }

    // MARK: DATA PROVIDER
    func titleForIndex(index: Int) -> String {
        switch index {
        case 0:
            return "Full Name"
        case 1:
            return "Email"
        case 2:
            return "Phone Number"
        case 3:
            return "ENQUIRY COMMENT/QUESTION"
        case 4:
            return "Reply"
        default:
            return ""
        }
    }
    
    func dataForIndex(index: Int) -> String {
        if enquiryDetailsModel == nil {
            return ""
        }
        switch index {
        case 0:
            return (enquiryDetailsModel?.full_name)!
        case 1:
            return (enquiryDetailsModel?.email_address)!
        case 2:
            return (enquiryDetailsModel?.phone)!
        case 3:
            return (enquiryDetailsModel?.comment)!
        case 4:
            return (enquiryDetailsModel?.reply)!
        default:
            return ""
        }
    }
    
    var courseName: String {
        if enquiryDetailsModel == nil {
            return ""
        }
        return (enquiryDetailsModel?.course_name)!
    }
    
    var instituteLogoUrl: String {
        if enquiryDetailsModel == nil {
            return ""
        }
        return (enquiryDetailsModel?.institute_logo_url)!
    }
    

}
