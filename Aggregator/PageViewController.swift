//
//  PageViewController.swift
//  page
//
//  Created by Websutra MAC 2 on 7/5/17.
//  Copyright © 2017 Websutra MAC 2. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMessages




//MARK: protocol
class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
        var pageControl = UIPageControl()
        var compareListId = [String]()
        var arrayOfCourses = [BasicComparedatas]()
        let viewControllerIdentifier = "TableViewController"
   
    var titleText : String?
   
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
        dataSource=self
        delegate = self
         compareListId = [compareListId.joined(separator: ",")]
    var tvc = storyboard?.instantiateViewController(withIdentifier: viewControllerIdentifier) as! TableViewController
    tvc.compareListId = self.compareListId
    setViewControllers([tvc], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        for course in self.arrayOfCourses{
            print(course.course_name)
        }
        
         tvc.arrayOfCourses = self.arrayOfCourses
       
            
            let firstVC = self.viewControllerAtIndex(index:0)
                let viewControllers = [firstVC]
        self.didMove(toParentViewController: self)
                self.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        

        }
    
    
    
    private func viewControllerAtIndex(index:Int) -> TableViewController {
        let childVC = storyboard?.instantiateViewController(withIdentifier: "TableViewController") as?TableViewController
        childVC?.pageIndex = index
        childVC?.arrayOfCourses = arrayOfCourses
        
        print(childVC)
        return childVC!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let walkThroughVC = viewController as? TableViewController
        
        var index = walkThroughVC?.pageIndex
        if index == 0 {
            return nil
        }
        index = index! - 1
        return self.viewControllerAtIndex(index: index!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let walkThroughVC = viewController as? TableViewController
        
        var index = walkThroughVC?.pageIndex
        let pageCount = 7
        
        index = index! + 1
        
        if index == pageCount {
            return nil
        }
        return self.viewControllerAtIndex(index: index!)
    }
    
    // MARK: - UIPageViewControllerDelegate Method
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if !completed {
            return
        }
        let childVC = pageViewController.viewControllers?.last as? TableViewController
        pageControl.currentPage = (childVC?.pageIndex)!
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    }







