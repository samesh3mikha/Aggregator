//
//  File.swift
//  Aggregator
//
//  Created by pukar sharma on 6/1/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import Foundation

class PopupViewData: NSObject{
    
    var itemID : String = ""
    var title : String = ""
    var details : String = ""
    var imageUrl : String = ""
   
    init(itemID : String , title : String, details : String, imageUrl : String ) {
        self.itemID = itemID
        self.title = title
        self.details = details
        self.imageUrl = imageUrl
                
        super.init()
    }

}
