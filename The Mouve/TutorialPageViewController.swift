//
//  TutorialPageViewController.swift
//  The Mouve
//
//  Created by Andrew Breckenridge on 3/5/15.
//  Copyright (c) 2015 Andrew Breckenridge. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController {
    let dS = TutorialPageViewControllerDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = dS
        
        let startingViewController = (dS.viewControllerAtIndex(0) as TutorialViewController!)
        let viewControllers = [startingViewController]
        
        self.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        edgesForExtendedLayout = .None


    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
