//
//  EnquiryTableViewCell.swift
//  Aggregator
//
//  Created by pukar sharma on 5/31/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

class EnquiryTableViewCell: UITableViewCell {

    @IBOutlet var shortCommentsLbl: UILabel!
    
    @IBOutlet var logoImageView: CustomImageView!
    @IBOutlet var enquiryDetail: UILabel!
    @IBAction func closeBtnClicked(_ sender: Any) {
    }
    @IBOutlet var courseNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
