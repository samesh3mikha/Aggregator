//
//  customTableViewCell.swift
//  Aggregator
//
//  Created by pukar sharma on 3/24/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import DOFavoriteButton

class customTableViewCell: UITableViewCell {

    @IBOutlet var bookmarkBtn: DOFavoriteButton!
    
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var mainLbl: UILabel!
    
    
    @IBOutlet var addressLbl: UILabel!
    
    @IBOutlet var uniLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
