//
//  MeVC-SettingOrChat.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/23.
//

import Foundation
import LeanCloud

extension MeVC{
    @objc func settingOrChat(){
        if isMySelf{//设置
            
            
            
            
        }else{
            if let _ = LCApplication.default.currentUser{
                showTextHUD("私信功能")
            }else{
                showLoginHUD()
            }
        }
    }
}
