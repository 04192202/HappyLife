//
//  NoteDetailVC-PostComment.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

import LeanCloud

extension NoteDetailVC{
    func postComment(){
        let user = LCApplication.default.currentUser!
        do {
            //云端数据
            //1.comment表
            let comment = LCObject(className: kCommentTable)
            try comment.set(kTextCol, value: textView.unwrappedText)
            try comment.set(kUserCol, value: user)
            try comment.set(kNoteCol, value: note)
            comment.save { _ in }
            //2.note表
            self.updateCommentCount(by: 1)//包含页面上的评论数变化的UI
            
            //内存数据
            comments.insert(comment, at: 0)
            
            //UI
            tableView.performBatchUpdates {
                tableView.insertSections(IndexSet(integer: 0), with: .automatic)
            }
        } catch {
            print("给Comment表的字段赋值失败: \(error)")
        }
    }
}
