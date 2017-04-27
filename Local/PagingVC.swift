//
//  PagingVC.swift
//  Local
//
//  Created by Jude Joseph on 1/21/17.
//  Copyright © 2017 Jude Joseph. All rights reserved.
//

import UIKit

class PagingVC: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var header: UIView!
    
    // The UIPageViewController
    var pageContainer: UIPageViewController!
    
    // The pages it contains
    var pages = [UIViewController]()
    
    // Track the current index
    var currentIndex: Int?
    private var pendingIndex: Int?
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the pages
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let page1: UIViewController! = storyboard.instantiateViewController(withIdentifier: "UserProfileVC")
        let page2: UIViewController! = storyboard.instantiateViewController(withIdentifier: "EventVC")
        let page3: UIViewController! = storyboard.instantiateViewController(withIdentifier: "AttendingVC")
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        // Create the page container
        pageContainer = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageContainer.delegate = self
        pageContainer.dataSource = self
        pageContainer.setViewControllers([page2], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        
        // Add it to the view
        view.addSubview(pageContainer.view)
        view.bringSubview(toFront: header)
        
        /* Configure our custom pageControl
        view.bringSubviewToFront(pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        */
    }
    
    // MARK: - UIPageViewController delegates
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % pages.count)
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = pages.index(of: viewController)!
        if currentIndex == pages.count-1 {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % pages.count)
        return pages[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = pages.index(of: pendingViewControllers.first!)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
               // pageControl.currentPage = index
            }
        }
    }
    
    
    
    @IBAction func goingBtnPressed(_ sender: Any) {
        pageContainer.setViewControllers([pages[2]], direction: .reverse, animated: true, completion: nil)
    }

    @IBAction func profileBtnPressed(_ sender: Any) {
        pageContainer.setViewControllers([pages[0]], direction: .forward, animated: true, completion:nil)
    }
}
