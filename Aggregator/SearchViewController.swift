//
//  SearchViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 3/21/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import HorizontalPicker
import ISHPullUp

//let baseUrl = "http://192.168.1.11:8089/api/main/"  //private
// let baseUrl = "http://192.168.1.11:8081/api/main/" //public
 
// let baseUrl = "http://202.129.251.174:8081/api/main/" //public


var courseArray = [Courses]()
var autoSuggestionArray = [Courses]()
var allAutosuggestionArray = [String]()
var countryAutosuggestionArray = [String]()


class SearchViewController: ISHPullUpViewController,UIGestureRecognizerDelegate,HorizontalPickerViewDataSource,HorizontalPickerViewDelegate,ISHPullUpContentDelegate,UIPopoverPresentationControllerDelegate{
    
  
    
   
    @IBOutlet var pickerView: HorizontalPickerView!
   
    

    
    @IBOutlet var viewWithSearch: roundView!
    
    lazy var dataSource: Array<String> = {
        let dataSource = ["All","Course","University","Location"]
        return dataSource
    }()
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    private func commonInit() {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let bottomVC = storyBoard.instantiateViewController(withIdentifier: "recentSearchVC") as! RecentSearchViewController
        
        
        bottomViewController = bottomVC
        bottomVC.pullUpController = self
        
        sizingDelegate = bottomVC
        stateDelegate = bottomVC 
    }

    
//     MARK: ISHPullUpContentDelegate
    
    func pullUpViewController(_ vc: ISHPullUpViewController, update edgeInsets: UIEdgeInsets, forContentViewController _: UIViewController) {
        // update edgeInsets
      self.view.layoutMargins = edgeInsets
        
        // call layoutIfNeeded right away to participate in animations
        // this method may be called from within animation blocks
        self.view.layoutIfNeeded()
    }
    
    
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
      //  self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "patternBackground"))
         self.navigationController?.navigationBar.isHidden = true
        pickerView.dataSource = self
        pickerView.delegate = self
        
       
        self.extendedLayoutIncludesOpaqueBars = false
        definesPresentationContext = true
        
     
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.gotoSearchView(_:)))
        
        viewWithSearch.isUserInteractionEnabled = true
        viewWithSearch.addGestureRecognizer(tap)
        
       

        
        
    }
    
    func gotoSearchView(_ sender: UITapGestureRecognizer) {
        
         let resultsController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "searchResultTVC")
            as? SearchResultTableViewController 
        
          let navController = UINavigationController(rootViewController: resultsController!)
        self.navigationController?.present(navController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        
        
    }
    
  
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        
//        if (searchText.characters.count % 3 == 0 ) {
//            
//            let s = searchText.replacingOccurrences(of: " ", with: "+")
//            fetchServerData(searchText: s)
//            
//        }
//    }
    
        
       
    // MARK: - HorizontalPickerViewProvider
    
    func numberOfRowsInHorizontalPickerView(_ pickerView: HorizontalPickerView) -> Int {
        return dataSource.count
    }
    
    func horizontalPickerView(_ pickerView: HorizontalPickerView, titleForRow row: Int) -> String {
        return "\(dataSource[row])"
    }
    
    func horizontalPickerView(_ pickerView: HorizontalPickerView, didSelectRow row: Int) {
        
        self.view.resignFirstResponder()
      //  label.text = "\(row)"
        selectedCategoryIndex = row
        
    }
    
    func textColorForHorizontalPickerView(_ pickerView: HorizontalPickerView) -> UIColor {
        return UIColor.lightGray
    }
    
    func textFontForHorizontalPickerView(_ pickerView: HorizontalPickerView) -> UIFont {
        
        
       
        return UIFont(name: Style.quicksand_medium, size: 20)!
    }
   
    
    // MARK: - Touch Events
    
    @IBAction func moreInfoBtnClicked(_ sender: UIButton) {
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pop")
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender // button
        popController.popoverPresentationController?.sourceRect = sender.bounds
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}








