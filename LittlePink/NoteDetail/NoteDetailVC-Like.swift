//
//  NoteDetailVC-Like.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/18.
//

import Foundation
import LeanCloud


extension NoteDetailVC{
    func like(){
        if let user = LCApplication.default.currentUser{
            //UI
            isLike ? (likeCount += 1) : (likeCount -= 1)
            //数据
            //优化1:防暴力点击
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(likeBtnTappedWhenLogin), object: nil)
            perform(#selector(likeBtnTappedWhenLogin), with: nil, afterDelay: 1)
            
        }else{
            showTextHUD("请先登录")
        }
    }
    
    @objc private func likeBtnTappedWhenLogin(){
        if likeCount != currentLikeCount{
            let user = LCApplication.default.currentUser!
            
            let offset = isLike ? 1 : -1
            currentLikeCount += offset
            
            if isLike{
                // userLike 中间表
                let userLike = LCObject(className: kUserLikeTable )
                try?userLike.set(kUserCol, value: user)
                try?userLike.set(kNoteCol, value: note)
                userLike.save { _ in }
                
                //点赞数
                try? note.increase(kLikeCountCol)
                
            }else{
                // userLike 中间表
                let query = LCQuery( className: kUserLikeTable)
                query.whereKey(kUserCol, .equalTo(user))
                query.whereKey(kNoteCol, .equalTo(note))
                query.getFirst { res in
                    if case let .success(object: userlike ) = res {
                        userlike.delete{ _ in }
                    }
                }
                //点赞数
                try? note.set(kLikeCountCol, value: likeCount)
                note.save { _ in }
                
            }
        }
    }
}
    
    
    
