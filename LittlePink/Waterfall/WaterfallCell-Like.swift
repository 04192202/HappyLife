//
//  WaterfallCell-Like.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/18.
//

import Foundation
import LeanCloud

extension WaterfallCell{
    @objc func likeBtnTappedWhenLogin(){
        //优化2:暴力点击时间内仅奇数次生效
        //只有当前点赞数量和最早时不一样时才进行云端操作(点偶数次不触发,奇数次才触发)
        //likedCount-负责UI的变化--点击后立刻变化
        //currentLikedCount-存储当前真正的值--隔1秒后经过判断才变化(偶数次不变化,奇数次才变)
        if likeCount != currentLikeCount{
            
            guard let note = note else {return }
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
