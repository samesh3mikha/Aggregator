//
//  DataParser.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 7/31/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class DataParser: NSObject {
    
    var dataDictionary: [String: AnyObject] = [:]
    
    init(dataDictionary: [String: AnyObject]) {
        self.dataDictionary = dataDictionary
    }
    
    func boolFor(key: String) -> Bool {
        if let data = dataDictionary[key] as? Bool {
            return data
        }
        return true
    }
    
    func intFor(key: String) -> Int {
        if let data = dataDictionary[key] as? Int {
            return data
        }
        return 0
    }
    
    func stringFor(key: String) -> String {
        if let data = dataDictionary[key] as? String {
            return data
        }
        return ""
    }

}
