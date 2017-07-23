//
//  TableViewController.swift
//  page
//
//  Created by Websutra MAC 2 on 7/5/17.
//  Copyright © 2017 Websutra MAC 2. All rights reserved.
//

import UIKit
import Alamofire
import SwiftMessages
import SwiftyJSON

let appGreenColor = UIColor(red: 9.0/255.0, green: 156/255.0, blue: 78.0/255.0, alpha: 1.0)

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate
{
   
      var svc: UIViewController = WebViewPopMoreController()
      var compareListId = [String]()
      var arrayOfCourses = [BasicComparedatas]()
      var section  = ["ENTRY REQUIREMENTS"]
      var pageIndex:Int! = 0    
    
    @IBOutlet weak var tableView: UITableView!
   
    @IBOutlet weak var pageControl: UIPageControl!
   
   @IBOutlet weak var closeView: UIView!
    
    @IBOutlet weak var compareingNumLbl: UILabel!
    
   
    
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//       self.tableView?.reloadData()
        
        self.navigationController?.navigationBar.isHidden = true
        let closeTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TableViewController.closeViewClicked))
         self.closeView.addGestureRecognizer(closeTap)
        
        for course in self.arrayOfCourses{
            print(course.course_name)
        }
        compareListId = [compareListId.joined(separator: ",")]
        
             
//        tableView.delegate = self
//        tableView.dataSource = self
       
       tableView.separatorColor = nil
   
        
        
    }
    
    
  
    
    func closeViewClicked() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "TabViewController")
        self.present(newVC, animated: false, completion: nil)
     //   _ = navigationController?.popViewController(animated: true)
        
    }
    
    
            
            
        

    
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.compareingNumLbl.text = "Comparing \(self.arrayOfCourses.count) Courses."
    }
    
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.compareingNumLbl.text = "Comparing \(self.arrayOfCourses.count) Courses."
        
        return self.arrayOfCourses.count
        
    }



    func numberOfSections(in tableView: UITableView) -> Int {
        
      return 1
        
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
        
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 50))
        
        header.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 50)
        
        
        
        
        let headerFrameLbl =  UILabel(frame: CGRect(x: 50, y: 3, width: self.tableView.frame.size.width, height: 20))
        
        
        
        headerFrameLbl.text = "Entry Requirements"
        
        header.backgroundColor = appGreenColor
        headerFrameLbl.textColor = UIColor.white //make the text black
        headerFrameLbl.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightLight)
        header.addSubview(headerFrameLbl)
        
        return header
           }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell") as! BasicCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
//        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! BasicCell

        // Configure the cell...
        
        let name = arrayOfCourses[indexPath.row].course_name
        print("Course name == ", name)
        cell.cNameLabel.text = name
        cell.setSomething(label: name)

        cell.webView.tag = indexPath.row
       cell.webView.isUserInteractionEnabled = true
        cell.webView.backgroundColor = UIColor.white
        
        cell.webView.delegate = self as UIWebViewDelegate
        let cdetail = arrayOfCourses[indexPath.row].entry_requirements
        print("cdetail === ", cdetail)
//        cell.webView.reload()
        cell.webView.loadHTMLString("about:blank", baseURL: nil)        
        cell.webView.loadHTMLString(cdetail, baseURL: nil)
        cell.webView.stopLoading()
        cell.selectionStyle = .none
       
         cell.readmoreBtn.tag = indexPath.row
        cell.readmoreBtn.addTarget(self, action: #selector(TableViewController.ReadmoreActn(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func ReadmoreActn(_ sender: Any) {
        
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          let newVC = storyboard.instantiateViewController(withIdentifier: "ReadmoreVC") as! WebViewPopMoreController
      
                newVC.isWebContent = true
        newVC.compareListId = compareListId
        newVC.arrayOfCourses = arrayOfCourses
             svc = newVC
         self.present(newVC, animated: true, completion: nil)
        
        func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            
            if (navigationType == UIWebViewNavigationType.formSubmitted) {
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReadmoreVC") as? WebViewPopMoreController
                
                let navigationController = UINavigationController(rootViewController: VC!)
                self.navigationController?.present(navigationController, animated: true, completion:nil)
                
                
            }
            return true
        }

    }
    
    
    

    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
     
        let numberOfCount = compareListId.count
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 1)
        con.dimMode = .none
        
        
        let heightOfVC = self.tableView.frame.height
      
        let heightOfRow = heightOfVC / CGFloat(self.arrayOfCourses.count) - 10
        
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



     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
              
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


    
    
  

    



  
