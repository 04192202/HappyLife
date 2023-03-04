//
//  EditProfileTableVC-UI.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/27.
//

import Foundation
import Kingfisher

extension EditProfileTableVC{
    func setUI(){
        avatarImageView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avatar))
        
        nickName = user.getExactStringVal(kNickNameCol)
        
        gender = user.getExactBoolValDefaultF(kGenderCol)
        
        birth = user.get(kBirthCol)?.dateValue
        
        intro = user.getExactStringVal(kIntroCol)
    }
}
