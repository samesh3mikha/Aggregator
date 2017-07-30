//
//  EnquiryDetailsVC.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 7/30/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages

class EnquiryDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var instituteNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var enquiryID: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlay()
        setupViews()
        fetchEnquiryDetails()
    }
    
    func setupViews() {
        logoImageView.layer.shadowOffset = CGSize.zero
        logoImageView.layer.shadowOpacity = 1.0
        logoImageView.layer.cornerRadius = 5
        logoImageView.sd_setImage(with: URL.init(string: "dsa"), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    // MARK: DATA DOWNLOAD
    func fetchEnquiryDetails() {
        if enquiryID.isBlank {
            return
        }
        showStatusHUD(title: "Fetching details.", details: "Please wait...", theme: .info, duration: .automatic)
        addOverlay()
        
        let params : Parameters = [
            "actionname": "enquiry_reply ",
            "data": [
                ["enquiry_id": enquiryID],
                ["flag": "S"]
            ]
        ]
        DataSynchronizer.syncData(params: params, completionBlock: { [weak self] (isRequestASuccess, message, data) in
            guard let weakself = self else {
                return
            }
            weakself.removeOverlay()
            let hudTheme: Theme = (isRequestASuccess) ? .success : .error
            weakself.showStatusHUD(title: "Data sync", details: message, theme: hudTheme, duration: .seconds(seconds: 10))
            if isRequestASuccess {
                let responseKey = "rto-form"
                if let responseArray = data[responseKey].arrayObject as? [[String:AnyObject]] {
                    print("responseArray ==> ", responseArray)
                }
            }
        })
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SimpleTableViewCell")! as! SimpleTableViewCell
        cell.titleLabel.text = "Title"
        cell.descriptionLabel.text = "Description"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

