//
//  BasicCell.swift
//  page
//
//  Created by Websutra MAC 2 on 7/7/17.
//  Copyright © 2017 Websutra MAC 2. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages

protocol ExpandCellDelegate {
    func moreTapped(cell: BasicCell)
}


class BasicCell: UITableViewCell,UIPopoverPresentationControllerDelegate {
    
    var delegate: ExpandCellDelegate?
    var isExpanded: Bool = false
    var bookmarkArray = [Courses]()
    var selectedIDs = [String]()

    
    @IBOutlet weak var readmoreBtn: UIButton!
    @IBOutlet weak var webView: UIWebView!
   
    @IBOutlet var cNameLabel: UILabel!
    
    @IBAction func ReadmoreActn(_ sender: Any) {
       
                       
        }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setSomething(label: String) {
        cNameLabel.text = label
    }



}
