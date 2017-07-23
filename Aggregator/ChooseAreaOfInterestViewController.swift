//
//  ChooseAreaOfInterestViewController.swift
//  Aggregator
//
//  Created by pukar sharma on 4/4/17.
//  Copyright © 2017 Websutra Technologies. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ChooseAreaOfInterestViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
   
    var checked = [Bool]()
    
    @IBOutlet var AOITableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
       // self.view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "patternBackground"))
        
        self.AOITableView.delegate = self
        self.AOITableView.dataSource =  self
        self.AOITableView.tableFooterView = UIView()
        
        self.AOITableView.rowHeight = UITableViewAutomaticDimension
        self.AOITableView.estimatedRowHeight = 44
        
        for  i in  0...areaOfInterestArray.count - 1
        {
           checked.insert(false, at: i)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARD: BUTTON CLICK EVENTS
    
    @IBAction func skipBtnClicked(_ sender: Any) {
    }
    
    @IBAction func continueBtnClicked(_ sender: Any) {
        
        let stringID = selectedIDs.map {
            
            String($0)
        }
        
        
        let IdtoPost = stringID.joined(separator: ",")
        print(IdtoPost)
        
        let headers: HTTPHeaders = [
            "Authorization": "bearer " + userinfo.access_token,
            "Content-Type": "application/json"
        ]
        
        let params : Parameters = [
            
            "actionname": "user_interest_area",
            "data": [
                
                ["flag": "I"],
                ["area_of_interest": IdtoPost],
                
            ]
        ]

        
        Alamofire.request(baseUrl + "ProcessData", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result
            {
                
            case .success(let value):
                let json = JSON(value)
                print(json)
            case .failure(let error):
                print(error)
                
            }
            
            let data = JSON(response.result.value!)
            
            if let responseStatus = data["STATUS"].arrayObject
            {
                let status = responseStatus[0] as! [String: AnyObject]
                let s = status["STATUS"] as! String
                
                if s == "SUCCESS"
                {
                    self.dismiss(animated: false, completion: nil)
                }
                
                else
                {
                    let errorMsg = status["MESSAGE"] as! String
                    
                    let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
            
            
            
        }
        
    }
    
    //MARK: TABLEVIEW DELEGATE AND DATA SOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
       return areaOfInterestArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        
        //CHECK FOR TICK MARK
        if !checked[indexPath.row] {
            cell.accessoryType = .none
        } else if checked[indexPath.row] {
            cell.accessoryType = .checkmark
        }
       
        let interestLabel = cell.viewWithTag(1) as! UILabel
        interestLabel.text = areaOfInterestArray[indexPath.row].facultyName
        
        return cell
    }

    var selectedIDs = [Int]()
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark
            {
                cell.accessoryType = .none
                checked[indexPath.row] = false
                if let index = selectedIDs.index(of: areaOfInterestArray[indexPath.row].facultyId)
                {
                    selectedIDs.remove(at: index)

                }
                
            }
            else{
                cell.accessoryType = .checkmark
                checked[indexPath.row] = true
                selectedIDs.append(areaOfInterestArray[indexPath.row].facultyId)
            }
        }
    }
    
    var shownIndexes : [IndexPath] = []
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (shownIndexes.contains(indexPath) == false) {
            shownIndexes.append(indexPath)
            
            cell.transform = CGAffineTransform(translationX: 0, y: 44)
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 10, height: 10)
            cell.alpha = 0
            
            UIView.beginAnimations("rotation", context: nil)
            UIView.setAnimationDuration(1)
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            cell.alpha = 1
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            UIView.commitAnimations()
        }
    }
    
    
    
}
