//
//  WaterfallCell.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/30.
//

import UIKit
import LeanCloud
import Kingfisher

class WaterfallCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var isMyselfLike = false
    
    var likeCount = 0 {
        didSet{
            likeBtn.setTitle(likeCount.formattedStr, for: .normal)
        }
    }
    
    var currentLikeCount = 0//用于判断用户在规定时间内,对点赞按钮奇数次点击还是偶数次点击

    var isLike: Bool { likeBtn.isSelected }
    
    var note: LCObject?{
        didSet{
            guard let note = note, let author = note.get(kAuthorCol) as? LCUser else { return }
            
            //加载远程图片(笔记封面)
            let coverPhotoURL = note.getImageURL(from: kCoverPhotoCol, .coverPhoto)
            imageView.kf.setImage(with: coverPhotoURL, options: [.transition(.fade(0.2))])
            
            //加载远程图片(作者头像)
            let avatarURL = author.getImageURL(from: kAvatarCol, .avatar)
            avatarImageView.kf.setImage(with: avatarURL)
            
            //笔记标题
            titleLabel.text = note.getExactStringVal(kTitleCol)
            
            //笔记作者
            nickNameLabel.text = author.getExactStringVal(kNickNameCol)
            
            //笔记被赞数
            likeCount = note.getExactIntVal(kLikeCountCol)
            currentLikeCount = likeCount
            
            //判断是否已点赞
            if isMyselfLike{
                likeBtn.isSelected = true
            }else{
                if let user = LCApplication.default.currentUser{
                    let query = LCQuery(className: kUserLikeTable)
                    query.whereKey(kUserCol, .equalTo(user))
                    query.whereKey(kNoteCol, .equalTo(note))
                    query.getFirst { res in
                        if case .success = res{
                            DispatchQueue.main.async {
                                self.likeBtn.isSelected = true
                            }
                        }
                    }
                }
            }
        }
    }
    // 浏览爱心 外框颜色
    override func awakeFromNib() {
        super.awakeFromNib()
        //配置点赞按钮被选中时的样式
        let icon = UIImage(systemName: "heart.fill")?.withTintColor(mainColor, renderingMode: .alwaysOriginal)
        likeBtn.setImage(icon, for: .selected)
        
    }
    
    @IBAction func like(_ sender: Any) {
        if let _ = LCApplication.default.currentUser{
            //UI
            likeBtn.isSelected.toggle()
            isLike ? (likeCount += 1) : (likeCount -= 1 )
            //数据
            //优化1:防暴力点击
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(likeBtnTappedWhenLogin), object: nil)
            perform(#selector(likeBtnTappedWhenLogin), with: nil, afterDelay: 1)
            
        }else{
            showGlobalTextHUD("请先登录")
        }
    }
}

