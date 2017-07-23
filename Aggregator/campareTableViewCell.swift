//
//  campareTableViewCell.swift
//  Aggregator
//
//  Created by pukar sharma on 7/3/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

class campareTableViewCell: UITableViewCell {
    
    @IBOutlet var uniLogoImageview: CustomImageView!
    
    
    @IBOutlet var tickImage: UIImageView!
    
    @IBOutlet var courseName: UILabel!
    
    @IBOutlet var uniName: UILabel!
    
    @IBOutlet var locationName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
