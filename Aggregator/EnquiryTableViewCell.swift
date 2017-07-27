//
//  EnquiryTableViewCell.swift
//  Aggregator
//
//  Created by pukar sharma on 5/31/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

public typealias DeleteItemHandler = () -> Void

class EnquiryTableViewCell: UITableViewCell {

    @IBOutlet var shortCommentsLbl: UILabel!
    @IBOutlet var logoImageView: CustomImageView!
    @IBOutlet var enquiryDetail: UILabel!
    @IBOutlet var courseNameLbl: UILabel!

    var itemID: String = "0"
    var deleteItemHandlerBlock: DeleteItemHandler?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        if deleteItemHandlerBlock !=  nil{
            deleteItemHandlerBlock!()
        }
    }
}
