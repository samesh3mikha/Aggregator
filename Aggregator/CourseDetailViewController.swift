//
//  CourseDetailViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 6/8/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import MXParallaxHeader

class CourseDetailViewController: UIViewController {
    
//    @IBOutlet var headerView: UIView!
//    
//    @IBOutlet var mainScrollView: MXScrollView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        mainScrollView = MXScrollView()
//        mainScrollView.parallaxHeader.view = headerView
//        mainScrollView.parallaxHeader.height = 230
//        mainScrollView.parallaxHeader.mode = MXParallaxHeaderMode.fill
//        mainScrollView.parallaxHeader.minimumHeight = 120
//        view.addSubview(mainScrollView)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
//        var frame = view.frame
//        
//        mainScrollView.frame = frame
//        mainScrollView.contentSize = frame.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
