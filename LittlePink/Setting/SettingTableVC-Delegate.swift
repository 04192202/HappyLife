//
//  SettingTableVC-Delegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/27.
//

import Foundation
import Kingfisher
import LeanCloud

extension SettingTableVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 1, row == 1{//清除缓存
            ImageCache.default.clearCache{
                self.showTextHUD("清除缓存成功")
                self.cacheSizeLabel.text = kNoCachePH
            }
        }else if section == 3{
            //let appID = "待上架"
            //let path = "https://itunes.apple.com/app/id\(appID)"
            //let path = "https://itunes.apple.com/app/id\(appID)?action=write-review"
            //如果是设置 tag： 1.问题反馈
            //               2.评价一下 ：如果是评价的话要上线再说 先放在这里 ⬆️
            let path = "https://04192202.github.io/index.html"
            guard let url = URL(string: path), UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }else if section == 4{
            
           dismiss(animated: true)
            
           LCUser.logOut()
           let loginVC = storyboard!.instantiateViewController(identifier: kLoginVCID)
           loginAndMeParentVC.removeChildren()
           loginAndMeParentVC.add(child: loginVC)
        }
    }
}
