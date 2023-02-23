//
//  NoteDetailVC-DelReply.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/22.
//

import Foundation
import LeanCloud

extension NoteDetailVC{
    func delReply(_ reply: LCObject, _ indexPath: IndexPath){
        showDelAlert(for: "回复") { _ in
            //云端数据
            reply.delete { _ in }
            self.updateCommentCount(by: -1)//包含页面上的评论数变化的UI
            
            //内存数据
            self.replies[indexPath.section].replies.remove(at: indexPath.row)
            
            //UI
            self.tableView.reloadData()
        }
    }
}
