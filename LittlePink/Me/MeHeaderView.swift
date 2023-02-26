//
//  MeHeaderView.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/23.
//

import UIKit
import LeanCloud
import Kingfisher

class MeHeaderView: UIView {


    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var editOrFollowBtn: UIButton!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var backOrDrawerBtn: UIButton!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var likedAndFavedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var settingOrChatBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editOrFollowBtn.makeCapsule()
        settingOrChatBtn.makeCapsule()
    }
    
    
    var user: LCUser!{
        didSet{
            //头像和昵称
            avatarImageView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avatar))
            nickNameLabel.text = user.getExactStringVal(kNickNameCol)
            
            //性别
            let gender = user.getExactBoolValDefaultF(kGenderCol)
            genderLabel.text = gender ? "♂︎" : "♀︎"
            genderLabel.textColor = gender ? blueColor : mainColor
            
            //悦生活号
            idLabel.text = "\(user.getExactIntVal(kIDCol))"
            
            //个人简介
            let intro = user.getExactStringVal(kIntroCol)
            introLabel.text = intro.isEmpty ? kIntroPH : intro
            
            //获赞和收藏数
            guard let userObjectId =  user.objectId?.stringValue else { return }
            let query = LCQuery(className: kUserInfoTable)
            query.whereKey(kUserObjectIdCol, .equalTo(userObjectId))
            query.getFirst { res in
                if case let .success(object: userInfo) = res{
                    let likeCount = userInfo.getExactIntVal(kLikeCountCol)
                    let favCount = userInfo.getExactIntVal(kFavCountCol)
                    DispatchQueue.main.async {
                        self.likedAndFavedLabel.text = "\(likeCount + favCount)"
                    }
                }
            }
        }
    }

    
}
