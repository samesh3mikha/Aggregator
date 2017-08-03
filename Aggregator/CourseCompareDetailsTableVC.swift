//
//  CourseCompareDetailsTableVC.swift
//  page
//
//  Created by Websutra MAC 2 on 7/5/17.
//  Copyright © 2017 Websutra MAC 2 Rekha bohara. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages
import SwiftyJSON

//let appGreenColor = UIColor(red: 9.0/255.0, green: 156/255.0, blue: 78.0/255.0, alpha: 1.0)
let appGreenColor = UIColor(red: 40.0/255.0, green: 182/255.0, blue: 122.0/255.0, alpha: 1.0)

class CourseCompareDetailsTableVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate
{
    var viewModel: CourseCompareDetailsModel? = nil
    var courses = [BasicComparedatas]()
    var pageIndex:Int! = 0  
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {        
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        viewModel = CourseCompareDetailsModel.init(courses: courses, page: pageIndex)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = nil
    }

    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {        
        let headerFrameLbl =  UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 45))
        headerFrameLbl.text = viewModel?.titleForPage()
        headerFrameLbl.textColor = UIColor.white //make the text black
        headerFrameLbl.font = UIFont.boldSystemFont(ofSize: 16)
        headerFrameLbl.textAlignment = .center
        headerFrameLbl.textColor = UIColor.darkGray
        
        return headerFrameLbl
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heightOfVC = self.tableView.frame.height
        let heightOfRow = (heightOfVC - 45)/CGFloat(self.courses.count)
        return heightOfRow
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell

        // Configure the cell...
        let name = courses[indexPath.row].course_name
        cell.cNameLabel.text = name
        cell.setSomething(label: name)

        cell.webView.tag = indexPath.row
        cell.webView.isUserInteractionEnabled = true
        cell.webView.backgroundColor = UIColor.white
        cell.webView.delegate = self as UIWebViewDelegate
        let cdetail = viewModel?.detailsForSection(section: indexPath.row)
        cell.webView.loadHTMLString(cdetail!, baseURL: nil)
        cell.selectionStyle = .none
       
        cell.readmoreBtn.isEnabled = false
        cell.readmoreBtn.tag = indexPath.row
        cell.readmoreBtn.addTarget(self, action: #selector(CourseCompareDetailsTableVC.ReadmoreActn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: webView.tag, section: 0)) as? BasicCell {
            if webView.scrollView.contentSize.height > webView.frame.size.height {
                cell.readmoreBtn.isEnabled = true
            }
        }
    }
    
    func ReadmoreActn(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "ReadmoreVC") as! WebViewPopMoreController
        let cdetail = viewModel?.detailsForSection(section: sender.tag)
        newVC.htmlString = cdetail!
        newVC.modalPresentationStyle = .overCurrentContext
        self.present(newVC, animated: true, completion: nil)
    }
    
}

