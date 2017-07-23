//
//  BookMark&WishTableViewCell.swift
//  Aggregator
//
//  Created by pukar sharma on 5/31/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

class BookMark_WishTableViewCell: UITableViewCell {

    @IBOutlet var logoImageview: CustomImageView!
    @IBOutlet var courseNameLbl: UILabel!
    @IBAction func deleteItem(_ sender: Any) {
        
    }
    override func awakeFromNib() {
      
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
