//
//  Login-Extensions.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/15.
//

import Foundation
import LeanCloud

extension UIViewController{
    func configAfterLogin(_ user:LCUser,_ nickName:String){
        if let _ = user.get(kNickNameCol){
        }else{
            //首次登陆，放入随机头像
            let randomAvatar = UIImage(named: "PH\(Int.random(in: 1...4))")!
            if let avatarData = randomAvatar.pngData(){
                let avatarFile = LCFile(payload: .data(data: avatarData))
                avatarFile.mimeType = "image/jpeg"
                
                avatarFile.save(to: user, as: kAvatarCol)
            }
                //判断用户是否是首次登录
            do {
                try user.set(kNickNameCol, value: nickName)
            }catch{ //对赋值的错误提示
                print("给字段赋值失败/重复赋值\(error)")
                return
            }
                user.save{(result)in
                    if case .success = result{
                }
            }
        }
    }
}
