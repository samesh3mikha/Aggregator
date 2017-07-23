//
//  EditConfirmationView.swift
//  Aggregator
//
//  Created by pukar sharma on 6/22/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import SwiftMessages

class EditConfirmationView: MessageView {

    
    var cancelAction: (() -> Void)?
    var saveDetailAction: (() -> Void)?
    
    @IBAction func saveDetailsAction(_ sender: Any) {
        
        saveDetailAction?()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        cancelAction?()
    }

}
