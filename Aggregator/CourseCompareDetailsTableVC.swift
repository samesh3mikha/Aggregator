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
    var svc: UIViewController = WebViewPopMoreController()
    var courses = [BasicComparedatas]()
//    var section  = ["ENTRY REQUIREMENTS"]
    var pageIndex:Int! = 0  
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var compareingNumLbl: UILabel!
    

    override func viewDidLoad() {        
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        viewModel = CourseCompareDetailsModel.init(courses: courses, page: pageIndex)
        
        self.compareingNumLbl.text = "Comparing \(self.courses.count) Courses."
        tableView.separatorColor = nil
        
        self.navigationController?.navigationBar.isHidden = true
        let closeTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CourseCompareDetailsTableVC.closeViewClicked))
         self.closeView.addGestureRecognizer(closeTap)
    }

    func closeViewClicked() {
            _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courses.count
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
        svc = newVC
        let cdetail = viewModel?.detailsForSection(section: sender.tag)
        newVC.htmlString = cdetail!
        newVC.modalPresentationStyle = .overCurrentContext
        self.present(newVC, animated: true, completion: nil)
//        self.pre
        
        
//        func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//            
//            if (navigationType == UIWebViewNavigationType.formSubmitted) {
//                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReadmoreVC") as? WebViewPopMoreController
//                
//                let navigationController = UINavigationController(rootViewController: VC!)
//                self.navigationController?.present(navigationController, animated: true, completion:nil)
//                
//                
//            }
//            return true
//        }

    }
    
    
    

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 1)
        con.dimMode = .none
        
        
        let heightOfVC = self.tableView.frame.height
      
        let heightOfRow = heightOfVC / CGFloat(self.courses.count) - 20
        
        return heightOfRow
   
    }
    

    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        
//        var header = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as! BasicCell
//       
//    //And populate the header with the name of the account
//       
//        header.textLabel?.textColor = UIColor.black
//        header.contentView.backgroundColor = UIColor.white
//        return header
//    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = courses[indexPath.row].course_name
        print("name --- ", name)
        print("....................")
    }
     
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
        

     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let appGreenColor = UIColor(red: 9.0/255.0, green: 156/255.0, blue: 78.0/255.0, alpha: 1.0)
        
    }
//    
//     func tableView(tableView: UITableView, ViewForHeaderInSection section: Int) -> UIView? {
//        tableView.backgroundColor = UIColor.white
//        return tableView
//    }
    
    
    
       
    
    
    
    

}


    
    
  

    



  
