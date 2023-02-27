//
//  MeVC-Delegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/27.
//

import Foundation
import LeanCloud

extension MeVC: EditProfileTableVCDelegate{
    func updateUser(_ avatar: UIImage?, _ nickName: String, _ gender: Bool, _ birth: Date?, _ intro: String) {
        //数据
        if let avatar = avatar, let data = avatar.jpeg(.medium){
            let avaterFile = LCFile(payload: .data(data: data))
            avaterFile.save(to: user, as: kAvatarCol)
        //UI
            meHeaderView.avatarImageView.image = avatar
        }
        try? user.set(kNickNameCol, value:nickName)
        meHeaderView.nickNameLabel.text = nickName
        
        try? user.set(kGenderCol, value: gender)
        meHeaderView.genderLabel.text = gender ? "♂" : "♀"
        meHeaderView.genderLabel.textColor = gender ? blueColor : mainColor
        
        try? user.set(kBirthCol, value: birth)
        
        try? user.set(kIntroCol, value: intro)
        meHeaderView.introLabel.text = intro.isEmpty ? kIntroPH : intro
        
        user.save{ _ in }
    }
}
