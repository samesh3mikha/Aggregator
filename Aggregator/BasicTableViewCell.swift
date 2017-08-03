//
//  BasicTableViewCell.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 8/3/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

public typealias DeleteItemHandler = () -> Void

class BasicTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    var itemID: String = ""
    var deleteItemHandlerBlock: DeleteItemHandler?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        if deleteItemHandlerBlock !=  nil{
            deleteItemHandlerBlock!()
        }
    }
}
