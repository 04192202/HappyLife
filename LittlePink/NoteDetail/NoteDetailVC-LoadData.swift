//
//  NoteDetailVC-LoadData.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

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
                //拿到所有的评论后再去取所有评论下的回复
                self.getReplies()
            }
        }
    }
    
    func getReplies(){
        //希望最后得到的顺序: [["回复对象","回复对象"], [], ["回复对象"]]
        var repliesDic: [Int: [LCObject]] = [:]
        let group = DispatchGroup()
        for (index, comment) in comments.enumerated(){
            //1.若查询失败(getExactBoolValDefaultT返回true),不知道这条评论下究竟有没有回复,需去云端继续查询回复
            //2.查询成功且为true,表明这条评论下有回复,需去云端继续查询回复
            if comment.getExactBoolValDefaultT(kHasReplyCol){
                group.enter()
                let query = LCQuery(className: kReplyTable)
                query.whereKey(kCommentCol, .equalTo(comment))
                query.whereKey(kUserCol, .included)
                query.whereKey(kReplyToUserCol, .included)
                //被回复的数据
                query.whereKey(kCreatedAtCol, .ascending)
                
                query.find { res in
                    if case let .success(objects: replies) = res{
                        //若这条评论下的回复都被删光时(情况较少),需把这条评论的hasReply字段设为false,方便下一次回复的查询
                        if replies.isEmpty{
                            try? comment.set(kHasReplyCol, value: false)
                            comment.save{ _ in }
                        }
                        repliesDic[index] = replies
                    }else{
                        repliesDic[index] = []
                    }
                    group.leave()
                }
            }else{//3.查询成功且为false,表明这条评论下没有回复,无需去云端继续查询
                repliesDic[index] = []
            }
        }
        
        group.notify(queue: .main) {
            //因这次的字典里面的value是数组类型,数组并为遵循Comparable协议,故不能直接用'by: <'这种用法
            //repliesDic:  [3: ["回复对象"], 2: [], 1: ["回复对象","回复对象"]]
            //sorted时:  [(key: 3, value: ["回复对象"]), (key: 2, value: []), (key: 1, value: ["回复对象","回复对象"])]
            //sorted后:  [(key: 1, value: ["回复对象","回复对象"]), (key: 2, value: []), (key: 3, value: ["回复对象"]),]
            //map后:  ["可展开回复对象", "可展开回复对象", "可展开回复对象"]
            self.replies = repliesDic.sorted{ $0.key < $1.key }.map{ ExpandableReplies(replies: $0.value) }
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    func getFav(){
        if let user = LCApplication.default.currentUser{
            let query = LCQuery(className: kUserFavTable)
            query.whereKey(kUserCol, .equalTo(user))
            query.whereKey(kNoteCol, .equalTo(note))
            query.getFirst { res in
                if case .success = res{
                    DispatchQueue.main.async {
                        self.favBtn.setSelected(selected: true, animated: false)
                    }
                }
            }
        }
    }
}
