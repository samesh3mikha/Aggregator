//
//  SimpleTableViewCell.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 7/30/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
