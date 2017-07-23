//
//  UserInfo .swift
//  Aggregator
//
//  Created by pukar sharma on 4/3/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class UserInfo : NSObject, NSCoding
{
    
    let username : String
    let access_token : String
    let isFirstTimeLogin : Bool
   
    
    init(userName : String , accessToken : String, isfirstTimeLogin : Bool  ) {
        
        self.username = userName
        self.access_token = accessToken
        self.isFirstTimeLogin  = isfirstTimeLogin
       
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let username = aDecoder.decodeObject(forKey: "userName") as! String
        let access_token = aDecoder.decodeObject(forKey: "accessToken") as! String
        let isFirstTimeLogin = aDecoder.decodeBool(forKey: "isfirstTimeLogin") 
        
        
        self.init(userName : username , accessToken : access_token, isfirstTimeLogin : isFirstTimeLogin )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: "userName")
        aCoder.encode(access_token, forKey: "accessToken")
        aCoder.encode(isFirstTimeLogin, forKey: "isfirstTimeLogin")
    }
    
    
}
