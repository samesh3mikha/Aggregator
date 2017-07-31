//
//  WebViewPopMoreController.swift
//  Aggregator
//
//  Created by Websutra MAC 2 on 7/17/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit

class WebViewPopMoreController: UIViewController {   
    @IBOutlet var webview: UIWebView!
    @IBOutlet var crossBtn: UIButton!

    var htmlString: String = ""
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        webview.layer.borderColor = UIColor.gray.cgColor
        webview.layer.borderWidth = 1
        webview.layer.cornerRadius = 8
        webview.layer.masksToBounds = true
        webview.loadHTMLString(htmlString, baseURL: nil)
    }
                
    @IBAction func crossBtnClicked(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
    
    
    
    
       
    

