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
            
            let navi = storyboard!.instantiateViewController(identifier: kEditProfileNaviID) as! UINavigationController
            navi.modalPresentationStyle = .fullScreen
            
            navi.heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .pull(direction: .right))
            
            let editProfileTableVC = navi.topViewController as! EditProfileTableVC
            editProfileTableVC.user = user
            editProfileTableVC.delegate = self
            present(navi, animated: true)
            
            
        }else{
            if let _ = LCApplication.default.currentUser{
                showTextHUD("悦生活待开发")
            }else{
                showLoginHUD()
            }
        }
    }
}
