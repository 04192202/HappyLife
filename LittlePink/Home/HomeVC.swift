//
//  HomeVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/17.
//

import UIKit
import XLPagerTabStrip

class HomeVC: ButtonBarPagerTabStripViewController {
    
    

    override func viewDidLoad() {
        //selectBar 按钮下面的条
        settings.style.selectedBarBackgroundColor = UIColor(named: "main")!
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemBackgroundColor = .clear
        
        
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let FollowVc = storyboard!.instantiateViewController(identifier: kFollowVCID)
        let NearByVC = storyboard!.instantiateViewController(identifier: kNearByVCID)
        let DiscoverVC = storyboard!.instantiateViewController(identifier: kDiscoverVCID)
        
        return [FollowVc, NearByVC, DiscoverVC]
    }

}
