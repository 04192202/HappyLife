//
//  FollowVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/24.
//

import UIKit
import XLPagerTabStrip

class FollowVC: UIViewController, IndicatorInfoProvider {
    
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        IndicatorInfo(title: "关注")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
