//
//  RecentSearchViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 5/23/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import ISHPullUp
class RecentSearchViewController: UIViewController,ISHPullUpStateDelegate,ISHPullUpSizingDelegate {
    
    
    
    @IBOutlet var topView: UIView!
    @IBOutlet var rootView: UIView!
    
    
    
    
    @IBOutlet var handleView: ISHPullUpHandleView!
    @IBOutlet var recentTableView: UITableView!
    @IBOutlet var topLabel: UILabel!
    
    private var firstAppearanceCompleted = false
    weak var pullUpController: ISHPullUpViewController!

    
     private var halfWayPoint = CGFloat(0)
    
    override func viewDidLoad() {
       
        
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        topView.addGestureRecognizer(tapGesture)
       rootView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "patternBackground"))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstAppearanceCompleted = true;
    }
    
    private dynamic func handleTapGesture(gesture: UITapGestureRecognizer) {
        
        
        pullUpController.toggleState(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ISHPullUpSizingDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, maximumHeightForBottomViewController bottomVC: UIViewController, maximumAvailableHeight: CGFloat) -> CGFloat {
        let totalHeight = rootView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        
      
        halfWayPoint = totalHeight / 2.0
        return totalHeight
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, minimumHeightForBottomViewController bottomVC: UIViewController) -> CGFloat {
        return topView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height;
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, targetHeightForBottomViewController bottomVC: UIViewController, fromCurrentHeight height: CGFloat) -> CGFloat {
        // if around 30pt of the half way point -> snap to it
        if abs(height - halfWayPoint) < 30 {
            return halfWayPoint
        }
        
        // default behaviour
        return height
    }
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forBottomViewController bottomVC: UIViewController) {
        // we update the scroll view's content inset
        // to properly support scrolling in the intermediate states
        recentTableView.contentInset = edgeInsets;
    }
    
    // MARK: ISHPullUpStateDelegate
    
    func pullUpViewController(_ pullUpViewController: ISHPullUpViewController, didChangeTo state: ISHPullUpState) {
        topLabel.text = textForState(state);
        handleView.setState(ISHPullUpHandleView.handleState(for: state), animated: firstAppearanceCompleted)
    }
    
    private func textForState(_ state: ISHPullUpState) -> String {
        switch state {
        case .collapsed:
            return "Recent search"
        case .intermediate:
            return "Pull up"
        case .dragging:
            return "Hold on"
        case .expanded:
            return "Your search history"
        }
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
