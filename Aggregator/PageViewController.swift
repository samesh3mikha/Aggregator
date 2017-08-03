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

public typealias CurrentPageUpdater = (Int) -> Void

//MARK: protocol
class PageViewController: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    let viewControllerIdentifier = "CourseCompareDetailsTableVC"

    var arrayOfCourses = [BasicComparedatas]()
    var currentPageUpdaterBlock: CurrentPageUpdater?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.tabBarController?.tabBar.isHidden = true
        self.hidesBottomBarWhenPushed = true
        self.view.backgroundColor = .white
        
        dataSource = self
        delegate = self
        reloadPages()
    }

    private(set) lazy var orderedViewControllers: [UIViewController] = {
        var courseCompareDetailsTables: [UIViewController] = []
        for index in 0...5 {
            courseCompareDetailsTables.append(self.viewControllerAtIndex(index: index))
        }
        return courseCompareDetailsTables
    }()
    
    
    func reloadPages() {
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    
    // PAGE CONTROLLER DELEGATE
    private func viewControllerAtIndex(index:Int) -> CourseCompareDetailsTableVC {
        let childVC = storyboard?.instantiateViewController(withIdentifier: "CourseCompareDetails") as? CourseCompareDetailsTableVC
        childVC?.pageIndex = index
        childVC?.courses = arrayOfCourses        
        return childVC!
    }
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    // MARK: - UIPageViewControllerDelegate Method
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if !completed {
            return
        }
        let childVC = pageViewController.viewControllers?.last as? CourseCompareDetailsTableVC
        if currentPageUpdaterBlock !=  nil{
            currentPageUpdaterBlock!((childVC?.pageIndex)!)
        }
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
