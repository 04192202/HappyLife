//
//  DiscoverVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/24.
//

import UIKit
import XLPagerTabStrip

class DiscoverVC: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        IndicatorInfo(title: "发现")
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
