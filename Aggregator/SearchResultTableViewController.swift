//
//  SearchResultTableViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 3/28/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SwiftyJSON
import DOFavoriteButton
import SwiftMessages

class SearchResultTableViewController: UIViewController,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate {
    @IBOutlet var bookmarkCountLbl: UILabel!
    @IBOutlet var enquiryCountLbl: UILabel!
    @IBOutlet var wishlistCountLbl: UILabel!
    @IBOutlet var mapImageView: UIImageView!
    @IBOutlet var closeView: UIView!
    @IBOutlet var popViewHolder: UIView!
    @IBOutlet var loginViewBtnHolder: UIView!
    @IBOutlet var heightContraintsofSuggestionTableView: NSLayoutConstraint!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var searchHolderView: UIView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var suggestionTableView: UITableView!
    var searchViewController: SearchViewController?
    var searchbarInstance = UISearchBar()
    let searchController = UISearchController(searchResultsController: nil)

    var viewModel: SearchResultViewModel? = nil
    var detailArray = [SearchDeatils]()
    var data = [String]()
    var reloadMainTable = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        popViewHolder.roundCorners([.topLeft,.topRight], radius: 6)
        loginViewBtnHolder.roundCorners([.topLeft,.topRight], radius: 6)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SearchResultViewModel.init()
        
        self.navigationController?.navigationBar.isHidden = true
        
        courseArray.removeAll()
        
        searchController.searchBar.delegate = self
        searchController.delegate = self
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        
        
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.tintColor = Style.themeColor
        searchController.searchBar.removeBackground()
        
        let txtField = searchController.searchBar.value(forKey: "searchField") as? UITextField
        txtField?.font = UIFont(name: Style.quicksand_medium, size: 14)
        txtField?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        searchController.searchBar.layer.borderColor = Style.themeColor.cgColor
        searchController.searchBar.scopeBarBackgroundImage = UIImage.init(color: UIColor.clear)
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.becomeFirstResponder()
        
        tableView.delegate = self
        tableView.dataSource = self
        suggestionTableView.delegate = self
        suggestionTableView.dataSource = self
        
        
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "patternBackground"))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        
        tableView.tableFooterView = UIView()
        suggestionTableView.tableFooterView = UIView()
        
        searchHolderView.addSubview(searchController.searchBar)
        
        segmentControl.setSegmentStyle()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchResultTableViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        let closeTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchResultTableViewController.closeViewClicked))
        self.closeView.addGestureRecognizer(closeTap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.white//UIColor(patternImage: #imageLiteral(resourceName: "patternBackground"))
        self.searchHolderView.backgroundColor =  UIColor.white// UIColor(patternImage: #imageLiteral(resourceName: "patternBackground"))
        tableView.isHidden = true
        suggestionTableView.isHidden = true
        
        let decodedUserinfo = self.getUserInfo()
        if !decodedUserinfo.access_token.isBlank
        {
            loginViewBtnHolder.isHidden = true
            self.FetchUserInfo(token: decodedUserinfo.access_token)
        }
        else
        {
            loginViewBtnHolder.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
    }
    
    func accessToken() -> String {
        let decodedUserinfo = self.getUserInfo()
        return decodedUserinfo.access_token
    }
    
    //MARK: Search bar delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !(searchText.isBlank) {
            self.reloadMainTable = false
            self.tableView.isHidden = true
            fetchSearchData(searchText: searchBar.text!)
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.mapImageView.alpha = 1.0
            })
            saveButton.isEnabled = false
            courseArray.removeAll()
            self.tableView.isHidden = true
            self.suggestionTableView.isHidden = true
        }
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        
        
        DispatchQueue.main.async {
            
            searchController.searchBar.showsCancelButton = false
            searchController.searchResultsController?.view.isHidden = false
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
        searchController.searchResultsController?.view.isHidden = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        saveButton.isEnabled = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
    
        let searchText = searchBar.text
        if !((searchText?.isBlank)!)
        {
            self.reloadMainTable = false
            self.tableView.isHidden = true
            fetchSearchData(searchText: searchBar.text!)
        }
            
        else
            
        {
            UIView.animate(withDuration: 0.5, animations: {
                self.mapImageView.alpha = 1.0
                
            })
            courseArray.removeAll()
            self.tableView.isHidden = true
            self.suggestionTableView.isHidden = true
        }

    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let searchText = searchController.searchBar.text
        viewModel?.saveSearch(searchword: searchText!, option: currentSearchOption(), accessToken: accessToken())
//        viewModel?.getFavoriteSearch(accessToken: accessToken())
    }
    
    func currentSearchOption() -> SearchOption {
        switch segmentControl.selectedSegmentIndex {
            case SearchOption.All.rawValue:
                return SearchOption.All 
            case SearchOption.Course.rawValue:
                return SearchOption.Course 
            case SearchOption.University.rawValue:
                return SearchOption.University 
            case SearchOption.Location.rawValue:
                return SearchOption.Location 
            default:
                return SearchOption.All 
        }
    }
    
    //MARK: Network
    
    
    func FetchUserInfo(token : String) -> Void {
        SwiftMessages.hideAll()
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .automatic
        con.dimMode = .none
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + token,
            "Content-Type": "application/json"
        ]
        let params : Parameters = [
            "actionname": "user_info_list",
            "data": [
                ["":""]
            ]
        ]
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                
                
                let data = JSON(value)
                
                if let responseStatus = data["STATUS"].arrayObject
                {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String
                    
                    if s == "SUCCESS"
                    {
                        //self.dismiss(animated: false, completion: nil)
                        
                        if let ui = data["USER_INFO"].arrayObject
                        {
                            let userInfo = ui[0] as! [String: AnyObject]
                            let bookmarkCount =  "\(userInfo["bookmark_count"]!)"
                            
                            let enquiryCount = "\(userInfo["enquiry_count"]!)"
                            let wishlistCount = "\(userInfo["wish_count"]!)"
                            
                            self.wishlistCountLbl.text = wishlistCount
                            self.enquiryCountLbl.text = enquiryCount
                            self.bookmarkCountLbl.text = bookmarkCount
                            
                            statusHud.configureContent(title: "", body: "Fetching complete")
                        }
                        
                    }
                        
                    else
                    {
                        if status["MESSAGE"] as! String == "SESSION EXPIRED"
                        {
                        self.catchSessionExpire()
                        statusHud.configureTheme(.error)
                        statusHud.configureContent(title: "", body: status["MESSAGE"] as! String + ". PLEASE LOGIN")
                          self.loginViewBtnHolder.isHidden = false
                        }
                        
                        else
                        {
                            statusHud.configureTheme(.error)
                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String)
                        }
                        
                        
                        
                    }
                }
                
                
            case .failure(let error):
                print(error)
                if let err = error as? URLError, err.code == .notConnectedToInternet{
                    // no internet connection
                    
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                    
                    
                }
                
                
                
            }
            
            SwiftMessages.show(config: con, view: statusHud)
            
            
            
            
        }
        
        
    }

    func fetchSearchData(searchOption: Int, searchText : String) -> Void {
        segmentControl.selectedSegmentIndex = searchOption
        self.reloadMainTable = true
        fetchSearchData(searchText: searchText)
    }
    
    func fetchSearchData(searchText : String) -> Void {
        var token = ""
        let decodedUserinfo = self.getUserInfo()
        if !decodedUserinfo.access_token.isBlank {
            token = "bearer " + decodedUserinfo.access_token
        }
        
        var queryString = ""
        switch segmentControl.selectedSegmentIndex {
            case SearchOption.All.rawValue:
                queryString = searchText
            case SearchOption.Course.rawValue:
                queryString = "course_name:" + searchText
            case SearchOption.University.rawValue:
                queryString = "institute_name:" + searchText
            case SearchOption.Location.rawValue:
                queryString = "country_id:" + searchText
            default:
                queryString =   searchText
        }
        
        let escapedString = queryString.URLEncoded
        let originalString = "getsearchresult?key=" + escapedString + "*"
        
        let headers: HTTPHeaders = [
            "Authorization":  token,
            "Content-Type": "application/json"
        ]
        
        Alamofire.request(baseUrl + originalString, method: .get, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            //        Alamofire.request(baseUrl, method: .get, parameters: nil, encoding: nil, headers: headers)
            //        Alamofire.request(baseUrl + originalString , header : headers).responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    let data = JSON(response.result.value!)
                    if let responseArray = data["SEARCHRESULT"].arrayObject {
                        courseArray.removeAll()
                        autoSuggestionArray.removeAll()
                        allAutosuggestionArray.removeAll()
                        countryAutosuggestionArray.removeAll()
                        
                        let resultDicts = responseArray as! [[String:AnyObject]]
                        for dict in resultDicts {
                            let c =  Courses.init(course_id : dict["institution_course_id"]! as! String  , courseName: dict["course_name"]! as! String, instituteName: dict["institute_name"]! as! String, studyLevel: dict["study_level_name"]! as! String, country: dict["country_id"]! as! String, institutionType: dict["institution_type"]! as! String, image: dict["institution_logo"]! as! String, isWishlisted: dict["is_wished"]! as! Bool,  isEnquired: dict["is_enquired"]! as! Bool, isBookmarked: dict["is_bookmarked"]! as! Bool)
                            courseArray.append(c)
                        }
                        if self.reloadMainTable {
                            self.suggestionTableView.isHidden = true
                            self.sortAndReloadMainTable()
                            if courseArray.count > 0 {
                                //Enable Search button
                                self.saveButton.isEnabled = true
                            }
                        } else {
                            self.sortAndReloadAutoSuggestionTable()
                        }
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    func  sortAndReloadMainTable() -> Void {
        self.tableView.isHidden = false
        self.tableView.reloadData()
    }
    
    func  sortAndReloadAutoSuggestionTable() -> Void {
        if self.segmentControl.selectedSegmentIndex == 0
            
        {
            for i in courseArray
            {
                
                allAutosuggestionArray.append(i.courseName)
                allAutosuggestionArray.append(i.country)
                allAutosuggestionArray.append(i.instituteName)
                
            }
            
            allAutosuggestionArray = allAutosuggestionArray.removeDuplicates()
            self.suggestionTableView.isHidden = false
        }
            
        else if( self.segmentControl.selectedSegmentIndex == 1 || self.segmentControl.selectedSegmentIndex == 2)
            
        {
            if courseArray.count > 4
                
            {
                for i in 0...3
                {
                    autoSuggestionArray.append(courseArray[i])
                }
                self.suggestionTableView.isHidden = false
                
            }
                
            else if courseArray.count == 0
            {
                self.suggestionTableView.isHidden = true
            }
                
            else
                
            {
                
                for i in courseArray
                {
                    autoSuggestionArray.append(i)
                }
                
                self.suggestionTableView.isHidden = false
                
            }
            
            self.tableView.isHidden = true
            
            
        }
            
            
        else
        {
            if courseArray.count > 4
                
            {
                for i in 0...3
                {
                    countryAutosuggestionArray.append(courseArray[i].country)
                }
                self.suggestionTableView.isHidden = false
                
            }
                
            else if courseArray.count == 0
            {
                self.suggestionTableView.isHidden = true
            }
                
            else
                
            {
                
                for i in courseArray
                {
                    countryAutosuggestionArray.append(i.country)
                }
                
                self.suggestionTableView.isHidden = false
                
            }
            
            self.tableView.isHidden = true
        }
        
        countryAutosuggestionArray = countryAutosuggestionArray.removeDuplicates()
        
        
        
        suggestionTableView.reloadData()
        
        UIView.animate(withDuration: 1, animations: {
            self.mapImageView.alpha = 0.2
            
        })
        
        
        self.heightContraintsofSuggestionTableView.constant = self.suggestionTableView.contentSize.height
        
        if self.heightContraintsofSuggestionTableView.constant > 216 {
            
            self.heightContraintsofSuggestionTableView.constant = 218
        }
        
        
    }
    
    
    
    
    // MARK: - UITableViewDataSource
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.tableView
        {
            
            return courseArray.count
        }
            
        else
        {
            reloadMainTable = false
            if segmentControl.selectedSegmentIndex == 0  {
                return allAutosuggestionArray.count
            }
                
            else if(segmentControl.selectedSegmentIndex == 3)
            {
                return countryAutosuggestionArray.count
            }
            else {
                return autoSuggestionArray.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView
        {
            return 7
        }
            
        else{
            return 2
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if tableView == self.tableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCellID")! as! customTableViewCell
            
            cell.mainLbl.text = courseArray[indexPath.section].courseName
            cell.addressLbl.text = courseArray[indexPath.section].country
            
            cell.uniLbl.text = courseArray[indexPath.section].instituteName
            cell.mainImageView.sd_setImage(with: URL.init(string: courseArray[indexPath.row].image), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            
            
            if courseArray[indexPath.section].isBookmarked == true {
                cell.bookmarkBtn.isSelected = true
            }
                
            else
            {
                cell.bookmarkBtn.isSelected = false
            }
            
            if courseArray[indexPath.section].isWishlisted == true {
                cell.wishlistBtn.isSelected = true
            }
                
            else
            {
                cell.wishlistBtn.isSelected = false
            }
            
            
            cell.bookmarkBtn.tag = indexPath.section
            cell.wishlistBtn.tag = indexPath.section
            
            
            
            
            cell.bookmarkBtn.addTarget(self, action: #selector(self.tappedBookmark), for: .touchUpInside)
            cell.wishlistBtn.addTarget(self, action: #selector(self.tappedWishlist), for: .touchUpInside)
            
            
            return cell
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "suggestionTableViewCellID")!
            
            let lbl = cell.viewWithTag(11) as! UILabel
            
            
            switch self.segmentControl.selectedSegmentIndex {
                
                
            case 0:
                
                if allAutosuggestionArray.count > 0
                {
                    lbl.text = allAutosuggestionArray[indexPath.section]
                    
                }
                
            case 1:
                if autoSuggestionArray.count > 0
                {
                    lbl.text = autoSuggestionArray[indexPath.section].courseName
                    
                }
                
            case 2:
                if autoSuggestionArray.count > 0
                {
                    lbl.text = autoSuggestionArray[indexPath.section].instituteName
                    
                }
                
            case 3:
                if countryAutosuggestionArray.count > 0
                {
                    lbl.text = countryAutosuggestionArray[indexPath.section]
                    
                }
                
            default:
                if autoSuggestionArray.count > 0
                {
                    lbl.text = ""
                    
                }
            }
            
            
            return cell
            
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == suggestionTableView
        {
            
            var selectedText = ""
            
            switch self.segmentControl.selectedSegmentIndex {
            case 0:
                
                selectedText = allAutosuggestionArray[indexPath.section]
                
            case 1:
                
                selectedText = autoSuggestionArray[indexPath.section].courseName
            case 2:
                
                selectedText = autoSuggestionArray[indexPath.section].instituteName
            case 3:
                
                selectedText = countryAutosuggestionArray[indexPath.section]
            default:
                selectedText = ""
            }
            
            
            self.searchController.searchBar.text = selectedText
            
            reloadMainTable = true
            self.fetchSearchData(searchText: selectedText)
            
        }
        
        else
        {
            let collegeDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "UniversityViewController") as! UniversityViewController
            
            self.navigationController?.pushViewController(collegeDetailViewController, animated: true)
           data = [courseArray[indexPath.row].course_id]
            print(data)

            collegeDetailViewController.myId = data
            print(data)
            collegeDetailViewController.detailArray = detailArray
            print(detailArray)
            
            
            
        
        }
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
//     func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if segue.identifier == "detail" { // Make sure you name the segue to match
//            
//            let controller = segue.destination as! UniversityViewController
//           
//            controller.myId = data
//        }
//    }
    
    //MARK: BUTTON TAPPED EVENTS
    
    func tappedWishlist(sender: DOFavoriteButton) {
        SwiftMessages.hideAll()
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        var con = SwiftMessages.Config()
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 0.5)
        con.dimMode = .none
                
        let id = String(courseArray[sender.tag].course_id)!
        var token = ""
        let decodedUserinfo = self.getUserInfo()
        if !decodedUserinfo.access_token.isBlank
        {
            token = "bearer " + decodedUserinfo.access_token
        }
        
        let headers: HTTPHeaders = [
            "Authorization":  token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "user_course_wish",
            "data": [
                
                ["flag":"I",
                 "institution_course_id": id
                ]
                
                
            ]
        ]
        
        
        
        
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                
                print(value)
                let data = JSON(response.result.value!)
                
                if let responseStatus = data["STATUS"].arrayObject
                {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String
                    
                    if s == "SUCCESS"
                    {
                        //self.dismiss(animated: false, completion: nil)
                        
                        
                        
                        if let ui = data["WISHCOUNT"].arrayObject
                        {
                            let userInfo = ui[0] as! [String: AnyObject]
                            let wishCount =  "\(userInfo["wish_count"]!)"
                            
                            
                            self.wishlistCountLbl.text = wishCount
                            
                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String)
                            
                            
                            if sender.isSelected {
                                // deselect
                                sender.deselect()
                            } else {
                                // select with animation
                                sender.select()
                            }
                            
                            self.fetchSearchData(searchText: self.searchController.searchBar.text!)
                            SwiftMessages.show(config: con, view: statusHud)
                        }
                        
                        
                        
                    }
                        
                    else
                    {
                        let alertString = "Only members are allowed to use this feature. Login or Signup to continue."
                        var con = SwiftMessages.Config()
                        
                        let alertView = MessageView.viewFromNib(layout: .CardView)
                        
                        
                     
                        
                        alertView.configureTheme(.warning)
                        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                        
                        con.duration = .seconds(seconds: 4)
                        con.dimMode = .none
                        con.interactiveHide = true
                    
                        
                        alertView.configureContent(title: "", body: alertString, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "JOIN NOW", buttonTapHandler: { _ in
                            
                            
                            self.loginClicked(alertView.button!)
                        })
                        
                        SwiftMessages.show(config: con, view: alertView)
                        
                       
                    }
                }
                
                
            case .failure(let error):
                print(error)
                if let err = error as? URLError, err.code == .notConnectedToInternet{
                    // no internet connection
                    
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                    SwiftMessages.show(config: con, view: statusHud)
                }
                
                
            }
            
            
           

            
            
            
        }
        
        
    }
    
    
    func tappedBookmark(sender: DOFavoriteButton) {
        
        SwiftMessages.hideAll()
        
        
        let statusHud = MessageView.viewFromNib(layout: .StatusLine)
        
        statusHud.configureTheme(.success)
        statusHud.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
        con.duration = .seconds(seconds: 0.5)
        con.dimMode = .none
        
        
        let id = String(courseArray[sender.tag].course_id)!
        
        var token = ""
        let decodedUserinfo = self.getUserInfo()
        if !decodedUserinfo.access_token.isBlank
        {
            
            
            
            token = "bearer " + decodedUserinfo.access_token
            
            
            
        }
        let headers: HTTPHeaders = [
            "Authorization":  token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "user_course_bookmark",
            "data": [
                
                ["flag":"I",
                 "institution_course_id":id]
                
                
            ]
        ]
        
        
        
        
        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                
                print(value)
                let data = JSON(response.result.value!)
                
                if let responseStatus = data["STATUS"].arrayObject
                {
                    let status = responseStatus[0] as! [String: AnyObject]
                    let s = status["STATUS"] as! String
                    
                    if s == "SUCCESS"
                    {
                        //self.dismiss(animated: false, completion: nil)
                        
                        
                        
                        if let ui = data["BOOKMARKCOUNT"].arrayObject
                        {
                            let userInfo = ui[0] as! [String: AnyObject]
                            let bookmarkCount =  "\(userInfo["bookmark_count"]!)"
                            
                            
                            self.bookmarkCountLbl.text = bookmarkCount
                            
                            statusHud.configureContent(title: "", body: status["MESSAGE"] as! String)
                            
                            
                            if sender.isSelected {
                                // deselect
                                sender.deselect()
                            } else {
                                // select with animation
                                sender.select()
                            }
                            
                            self.fetchSearchData(searchText: self.searchController.searchBar.text!)
                             SwiftMessages.show(config: con, view: statusHud)
                        }
                        
                        
                        
                    }
                        
                    else
                    {
                        let alertString = "Only members are allowed to use this feature. Login or Signup to continue."
                        var con = SwiftMessages.Config()
                        
                        let alertView = MessageView.viewFromNib(layout: .CardView)
                        
                        
                        
                        alertView.configureTheme(.warning)
                        con.presentationContext = .window(windowLevel: UIWindowLevelStatusBar)
                        
                        con.duration = .seconds(seconds: 4)
                        con.dimMode = .none
                        con.interactiveHide = true
                        
                        
                        alertView.configureContent(title: "", body: alertString, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "JOIN NOW", buttonTapHandler: { _ in
                            
                            
                            self.loginClicked(alertView.button!)
                        })
                        
                        SwiftMessages.show(config: con, view: alertView)
                    }
                }
                
                
            case .failure(let error):
                print(error)
                if let err = error as? URLError, err.code == .notConnectedToInternet{
                    // no internet connection
                    
                    statusHud.configureTheme(.error)
                    statusHud.configureContent(title: "" , body: error.localizedDescription)
                     SwiftMessages.show(config: con, view: statusHud)
                    
                }
                
                
            }
            
            
           
            
           
            
        }
        
        
       
        
        
        
    }
    
    @IBAction func loginClicked(_ sender: UIButton) {
        
        SwiftMessages.hideAll()
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Loginvcid") as! LoginViewController
        
        let navController = UINavigationController(rootViewController: loginViewController)
        self.navigationController?.present(navController, animated: true, completion: nil)
        
        
    }
    
    func closeViewClicked() {
        
        DispatchQueue.main.async {
            
            self.dismissModalStack(animated: true, completion: nil)
        }
        
        
        
        
    }
    
    func dismissKeyboard() {
        
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        searchController.searchBar.resignFirstResponder()
    }
    
    
    
    
    //MARK: POPOVERVIEW EVENTS
    
    var overlay: UIView?
    
    func  showEmptyView(popUpText : String) -> Void {
        
        let emptyView = MessageView.viewFromNib(layout: .TabView)
        emptyView.configureContent(body: "You have not added any item in your " + popUpText + " list. Explore more and add what suits you.")
        emptyView.bodyLabel?.font = UIFont(name: Style.quicksand_regular, size: 14)
        emptyView.button?.isHidden = true
        emptyView.titleLabel?.isHidden = true
        emptyView.configureTheme(.warning)
        emptyView.id = "statusHud"
        
        var con = SwiftMessages.Config()
        
        con.interactiveHide = true
        con.duration = .seconds(seconds: 4)
        con.dimMode = .none
        con.presentationStyle = .bottom
        SwiftMessages.show(config: con, view: emptyView)
        
    }
    
    @IBAction func popBtnTapped(_ sender: UIButton) {
        
        SwiftMessages.hideAll()
        
        switch sender.tag {
        case 1:
            
            
            if self.wishlistCountLbl.text == "0"
            {
                showEmptyView(popUpText: "wish")
                return
            }
            
            
        case 2:
            
            if self.enquiryCountLbl.text == "0/0"
            {
                showEmptyView(popUpText: "enquiry")
                return
            }
            
            
        case 3:
            
            if self.bookmarkCountLbl.text == "0"
            {
                showEmptyView(popUpText: "bookmark")
                return
            }
            
            
        default:
            return
        }
        
        
        
        let popController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pop") as! PopPresentationViewController
        print(sender.tag)
        popController.buttonIndex = sender.tag
        
        // set the presentation style
        popController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        // set up the popover presentation controller
        popController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popController.popoverPresentationController?.delegate = self
        popController.popoverPresentationController?.sourceView = sender // button
        popController.popoverPresentationController?.sourceRect = sender.bounds
        popController.showSearchResultHandlerBlock = { [weak self] (selectedIndex, text) in
            guard let weakself = self else {
                return
            }
            weakself.fetchSearchData(searchOption: selectedIndex, searchText: text)
        }
        
        // present the popover
        self.present(popController, animated: true, completion: nil)
    }
    
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    
    func presentationController(_ presentationController: UIPresentationController, willPresentWithAdaptiveStyle style: UIModalPresentationStyle, transitionCoordinator: UIViewControllerTransitionCoordinator?) {
        // add a semi-transparent view to parent view when presenting the popover
        let parentView = presentationController.presentingViewController.view
        
        let overlay = UIView(frame: (parentView?.bounds)!)
        overlay.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        parentView?.addSubview(overlay)
        
        let views: [String: UIView] = ["parentView": parentView!, "overlay": overlay]
        
        parentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[overlay]|", options: [], metrics: nil, views: views))
        parentView?.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[overlay]|", options: [], metrics: nil, views: views))
        
        overlay.alpha = 0.0
        
        transitionCoordinator?.animate(alongsideTransition: { _ in
            overlay.alpha = 1.0
        }, completion: nil)
        
        self.overlay = overlay
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        guard let overlay = overlay else {
            return
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                overlay.alpha = 0.0
            }, completion: { _ in
                overlay.removeFromSuperview()
            })}
        
    }
    
  
    
}




