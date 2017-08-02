//
//  EnquiryDetailsVC.swift
//  Aggregator
//
//  Created by Samesh Swongamikha on 7/30/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import SwiftMessages

class EnquiryDetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var logoImageView: CustomImageView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: EnquiryDetailsVM? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOverlay()
        setupViews()
        fetchEnquiryDetails()
    }
    
    func setupViews() {
        navigationItem.title = "Enquiry Details"
        navigationController?.navigationBar.isHidden = false
        logoImageView.sd_setImage(with: URL.init(string: ""), placeholderImage: #imageLiteral(resourceName: "placeholder"))
    }
    
    func fetchEnquiryDetails() {
        addOverlay()
        showStatusHUD(title: "Fetching details!", details: "Please wait...", theme: .info, duration: .seconds(seconds: 10))
        
        viewModel?.fetchEnquiryDetails(completionBlock: { [weak self] (isFetchSuccess, message) in
            guard let weakself = self else {
                return
            }
            weakself.removeOverlay()
            let hudTheme: Theme = (isFetchSuccess) ? .success : .error
            weakself.showStatusHUD(title: "Data sync", details: message, theme: hudTheme, duration: .seconds(seconds: 10))
            if isFetchSuccess {
                weakself.courseNameLabel.text = weakself.viewModel?.courseName
                weakself.logoImageView.sd_setImage(with: URL.init(string: (weakself.viewModel?.instituteLogoUrl)!), placeholderImage: #imageLiteral(resourceName: "placeholder"))
                weakself.tableView.reloadData()
            }
        })
        

    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "SimpleTableViewCell")! as! SimpleTableViewCell
        cell.titleLabel.text = viewModel?.titleForIndex(index: indexPath.row)
        cell.descriptionLabel.text = viewModel?.dataForIndex(index: indexPath.row)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

