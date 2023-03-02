//
//  NoteDetailVC-PostReply.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

import Foundation
import LeanCloud

extension NoteDetailVC{
    func postReply(){
        let user = LCApplication.default.currentUser!
        do{
            let comment = comments[commentSection]
            
            //云端数据
            //1.reply表
            let reply = LCObject(className: kReplyTable)
            try reply.set(kTextCol, value: textView.unwrappedText)
            try reply.set(kUserCol, value: user)
            try reply.set(kCommentCol, value: comment)
            if let replyToUser = replyToUser{
                try reply.set(kReplyToUserCol, value: replyToUser)
            }
            reply.save { res in
                if case .success = res{
                    //2.hasReply若已为true则不重复写入,即:hasReply查询成功但为false时才写入
                    if let hasReply = comment.get(kHasReplyCol)?.boolValue, hasReply != true{
                        //1.hasReply字段写入true,表明这条评论下有回复,方便之后优化查询这条评论下的回复
                        try? comment.set(kHasReplyCol, value: true)
                        comment.save{ _ in }
                    }
                }
                
            }
            //2.note表
            self.updateCommentCount(by: 1)//包含页面上的评论数变化的UI
            
            //内存数据
            //当用户点击某条评论,准备回复的时候,会给全局变量commentSection赋一个当前的section值,利用这个值找到对应的内层数组
            replies[commentSection].replies.append(reply)
            
            //UI
            //如果当前是展开状态
            if replies[commentSection].isExpanded{
                tableView.performBatchUpdates {
                    //row:先利用commentSection找到当前section中一共就几个回复,减去1之后就得出插入的新row的索引
                    tableView.insertRows(
                        at: [IndexPath(row: replies[commentSection].replies.count - 1, section: commentSection)],
                        with: .automatic
                    )
                }
            
            }else{//如果不是展开状态找到当前第一个cell
                let cell = tableView.cellForRow(at: IndexPath(row: 0, section: commentSection)) as! ReplyCell
                cell.showAllReplyBtn.setTitle("展示 \(replies[commentSection].replies.count - 1) 条回复", for: .normal)
            }
        }catch{
            print("给Reply表的字段赋值失败: \(error)")
        }
    }
}
