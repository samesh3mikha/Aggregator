//
//  DataSynchronizer.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 7/30/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

public typealias DataSyncHandler = (Bool, String, JSON) -> Void
public typealias DataSyncedSignal = (Bool, String) -> Void

class DataSynchronizer: NSObject {
    
    // MARK: - Access Token of current User
    static func getAccessToken() -> String {
        let pref = UserDefaults.standard
        var userInfo: UserInfo = UserInfo(userName: "", accessToken: "", isfirstTimeLogin: false)
        if let decoded = pref.object(forKey: "userinfo") {
            userInfo = NSKeyedUnarchiver.unarchiveObject(with: decoded as! Data) as! UserInfo
        }
        return userInfo.access_token
    }
    
    // MARK: - Send data sync request
    static func syncData(params: Parameters, completionBlock: @escaping DataSyncHandler) {
        let accessToken = DataSynchronizer.getAccessToken()
        if accessToken.isBlank {
            return
        }
        let url = baseUrl + "Processdata"
        let accessKey = "bearer " + accessToken
        
        let headers: HTTPHeaders = [
            "Authorization":  accessKey,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            var isRequestSuccessful = false
            var responseMessage = "An unidentified error occured!" 
            switch response.result {
            case .success(let value):                
                let data = JSON(value)
//                print("Data --", data)
                if let responseStatus = data["STATUS"].arrayObject {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let statusMessage = status["STATUS"] as! String
                    responseMessage = statusMessage
                    if statusMessage == "SUCCESS" {
                        isRequestSuccessful = true
                        responseMessage = status["MESSAGE"] as! String //"Data synced successfully!"
                    }
                }
                completionBlock(true, responseMessage, data)
            case .failure(let error):
                responseMessage = error.localizedDescription 
                completionBlock(isRequestSuccessful, responseMessage, JSON.null)
            }
        }
    }
    
}


