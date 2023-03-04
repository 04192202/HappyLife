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
       // MARK: -  selectBar 按钮下面的条
        settings.style.selectedBarBackgroundColor = mainColor
        settings.style.selectedBarHeight = 3
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 16)
        settings.style.buttonBarItemLeftRightMargin = 0
        
        super.viewDidLoad()
        
        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }

    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
//        let FollowVC = storyboard!.instantiateViewController(identifier: kFollowVCID)
//        let NearByVC = storyboard!.instantiateViewController(identifier: kNearByVCID)
        let DiscoverVC = storyboard!.instantiateViewController(identifier: kDiscoverVCID)
        
        
        //return [DiscoverVC,FollowVC,NearByVC,]
        return [DiscoverVC]
    }

}
