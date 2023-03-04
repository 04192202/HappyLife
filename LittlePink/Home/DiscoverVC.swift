//
//  DiscoverVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/24.
//

import UIKit
import XLPagerTabStrip

class DiscoverVC: ButtonBarPagerTabStripViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        
        settings.style.selectedBarHeight = 0
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 14)
        
        
        super.viewDidLoad()

        containerView.bounces = false
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }

            oldCell?.label.textColor = .secondaryLabel
            newCell?.label.textColor = .label
        }
        
        
        
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        var vcs: [UIViewController] = []
        for channel in kChannels {
            let vc = storyboard!.instantiateViewController(identifier: kWaterfallVCID) as! WaterfallVC
            vc.channel = channel
            vcs.append(vc)
        }
        return vcs
    }
    
    
        func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
            IndicatorInfo(title: "悦享好生活")
        }

}
