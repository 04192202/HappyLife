//
//  NoteDetailVC-Fav.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/18.
//

import Foundation
import LeanCloud

extension NoteDetailVC{
    func fav(){
        if let _ = LCApplication.default.currentUser{
            //UI
            isFav ? (favCount += 1) : (favCount -= 1)
            
            //数据
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(favBtnTappedWhenLogin), object: nil)
            perform(#selector(favBtnTappedWhenLogin), with: nil, afterDelay: 1)
            
        }else{
            showLoginHUD()
        }
    }
    
    @objc private func favBtnTappedWhenLogin(){
        if favCount != currentFavCount{
            let user = LCApplication.default.currentUser!
            let authorObjectId = author?.objectId?.stringValue ?? ""
            
            let offset = isFav ? 1 : -1
            currentFavCount += offset

            // MARK: 云端数据处理
            //1.中间表userFav添加或删除一个记录(record)
            if isFav{//1-1添加
                let userFav = LCObject(className: kUserFavTable)
                try? userFav.set(kUserCol, value: user)
                try? userFav.set(kNoteCol, value: note)
                userFav.save { _ in }
                try? note.increase(kFavCountCol)
                LCObject.userInfo(where: authorObjectId, increase: kFavCountCol)
            }else{
                //1-2.删除--此处这个包没有找到更好的方法,希望以后能增加新API
                let query = LCQuery(className: kUserFavTable)
                query.whereKey(kUserCol, .equalTo(user))
                query.whereKey(kNoteCol, .equalTo(note))
                query.getFirst { res in
                    if case let .success(object: userFav) = res{
                        userFav.delete { _ in }
                    }
                }
                try? note.set(kFavCountCol, value: favCount)
                note.save { _ in }
                LCObject.userInfo(where: authorObjectId, decrease: kFavCountCol, to: favCount)
            }
        }
    }
}
