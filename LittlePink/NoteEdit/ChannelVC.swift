//
//  ChannelVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/2.
//

import UIKit
import XLPagerTabStrip

class ChannelVC:  ButtonBarPagerTabStripViewController {
   //ChannelVCDelegate
    var PVDelegate: ChannelVCDelegate?
    
    
    override func viewDidLoad() {
        
        settings.style.selectedBarHeight = 2
        settings.style.selectedBarBackgroundColor = mainColor
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarItemFont = .systemFont(ofSize: 15)
        
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
      // indices 索引， 因为定义的subChannels是一个嵌套数组
        for i in kChannels.indices{
            let vc = storyboard!.instantiateViewController(identifier: kChannelTableVCID) as! ChannelTableVC
            //待做(之后这两个数据都需从服务端取)
            vc.channel = kChannels[i]
            vc.subChannels = kAllSubChannels[i]
            vcs.append(vc)
        }
        return vcs
    }

}
