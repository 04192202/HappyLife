//
//  MeVC-EditOrFollow.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/23.
//

import Foundation
import LeanCloud

extension MeVC{
    @objc func editOrFollow(){
        if isMySelf{//编辑资料
            
            
            
            
        }else{
            if let _ = LCApplication.default.currentUser{
                print("悦生活待开发")
            }else{
                showLoginHUD()
            }
        }
    }
}
