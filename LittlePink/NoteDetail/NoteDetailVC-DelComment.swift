//
//  NoteDetailVC-DelComment.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

import Foundation
import LeanCloud

extension NoteDetailVC{
    func delComment(_ comment: LCObject, _ section: Int){
        showDelAlert(for: "评论") { _ in
            //云端数据
            comment.delete { _ in }
            try?self.note.increase(kCommentCountCol,by: -1)//包含页面上的评论数变化的UI
            self.note.save{ _ in }
            //内存数据
            self.comments.remove(at: section)
            
            //UI
            self.tableView.reloadData()//和删除草稿笔记一样(BUG!!!out of index)用reloadData会比较方便
            self.commentCount -= 1
        }
    }
}
