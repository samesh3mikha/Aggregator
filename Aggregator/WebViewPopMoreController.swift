//
//  WebViewPopMoreController.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/17/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

class WebViewPopMoreController: UIViewController {
   
        @IBOutlet weak var heightConstraint: NSLayoutConstraint!
        @IBOutlet var popupView: UIView!
        @IBOutlet var webview: UIWebView!
         var isWebContent: Bool!
        var arrayOfCourses = [BasicComparedatas]()
         var compareListId = [String]()
    
        @IBOutlet var crossBtn: UIButton!
        
        
        override func viewDidLoad() {
            
            
            super.viewDidLoad()
            
            
            webview.scrollView.isScrollEnabled=false
            heightConstraint.constant = webview.scrollView.contentSize.height

            
           // let cdetail = arrayOfCourses[indexPath.section].entry_requirements
           
            
            popupView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.70)
            
                self.navigationController?.navigationBar.isHidden = true
                webview.isHidden = false
                
                let imageview = UIImageView(frame: CGRect(x: webview.frame.origin.x, y: webview.frame.origin.y, width: webview.frame.size.width, height: webview.frame.size.height))
                
                imageview.contentMode = .scaleAspectFill
                
                self.view.addSubview(imageview)
                
                let defaults = UserDefaults.standard
                 
            
         
            

        
                
            
            }
    
    func loadWebView(request : NSURLRequest) {
    webview.loadRequest(request as URLRequest)
    }
            
            
    
        
        
        @IBAction func crossBtnClicked(_ sender: AnyObject)
        {
           
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "TableViewController") as! TableViewController
            
           // self.present(vc, animated: false, completion: nil)
            DispatchQueue.main.async() {
                self.navigationController?.dismiss(animated: false, completion: nil)
                
            }
            vc.arrayOfCourses = self.arrayOfCourses
            vc.compareListId = self.compareListId
            
            }
            
            
                }
    
    
    
    
       
    

