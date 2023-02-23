//
//  LoginAndMeParentVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/15.
//

import UIKit
import LeanCloud

//强引用子视图构建
var loginAndMeParentVC = UIViewController()

class LoginAndMeParentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = LCApplication.default.currentUser {
            let meVC = storyboard!.instantiateViewController(identifier: kMeVCID) { coder in
                MeVC(coder: coder, user: user)
            }
            add(child: meVC)
        } else {
            let loginVC = storyboard!.instantiateViewController(identifier: kLoginVCID)
            add(child: loginVC)
        }
        
        loginAndMeParentVC = self//用一个强引用保存当前这个父vc,方便在登录和退出时找到正确的父vc
    }

}
