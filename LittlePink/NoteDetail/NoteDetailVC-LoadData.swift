//
//  NoteDetailVC-LoadData.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

import Foundation
import LeanCloud

extension NoteDetailVC{
    func getCommentsAndReplies(){
        showLoadHUD()
        
        let query = LCQuery(className: kCommentTable)
        //获取指定字段的数据:第一个参数为指定的字段名,第二个参数为.selected
        //query.whereKey(kTextCol, .selected)
        //query.whereKey("\(kUserCol).\(kNickNameCol)", .selected)//一对多数据的链式调用(需included)
        query.whereKey(kNoteCol, .equalTo(note))
        query.whereKey(kUserCol, .included)
        query.whereKey(kCreatedAtCol, .descending)
        query.limit = kCommentsOffset
        
        query.find { res in
            self.hideLoadHUD()
            if case let .success(objects: comments) = res{
                self.comments = comments
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                //拿到所有的评论后再去取所有评论下的回复
                //self.getReplies()
            }
        }
    }
}
