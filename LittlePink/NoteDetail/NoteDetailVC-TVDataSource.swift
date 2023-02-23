//
//  NoteDetailVC-TVDataSource.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

import LeanCloud

extension NoteDetailVC: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let replyCount = replies[section].replies.count
        //可展开回复对象=ExpandableReplies,内置两个属性,1:回复是否已展开-isExpanded;2.这段里的所有回复-replies
        //这个可展开回复对象代表的就是每一段里的回复信息(包括isExpanded的flag和这段的所有回复),可通过replies[section]找到
        //默认isExpanded为false,即replies[section].isExpanded为false(也就是到详情页时回复为不展开状态)
        if replyCount > 1 && !replies[section].isExpanded{
            return 1
        }else{
            return replyCount
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kReplyCellID, for: indexPath) as! ReplyCell
        
        //单个回复对象
        let reply = replies[indexPath.section].replies[indexPath.row]
        //回复人对象
        let replyAuthor = reply.get(kUserCol) as? LCUser
        
        //传到回复cell里去,用于展示评论下面的回复
        cell.reply = reply
        
        //判断回复人是否是笔记作者
        if let replyAuthor = replyAuthor, let noteAuthor = author, replyAuthor == noteAuthor{
            cell.authorLabel.isHidden = false
        }else{
            cell.authorLabel.isHidden = true
        }
        
        //轻触回复人头像或昵称
        let avatarTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        avatarTap.passObj = replyAuthor
        cell.avatarImageView.addGestureRecognizer(avatarTap)
        let nickNameTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        nickNameTap.passObj = replyAuthor
        cell.nickNameLabel.addGestureRecognizer(nickNameTap)
        
        //展开x条回复按钮
        let replyCount = replies[indexPath.section].replies.count
        if replyCount > 1, !replies[indexPath.section].isExpanded{
            cell.showAllReplyBtn.isHidden = false
            cell.showAllReplyBtn.setTitle("展示 \(replyCount - 1) 条回复", for: .normal)
            cell.showAllReplyBtn.tag = indexPath.section
            cell.showAllReplyBtn.addTarget(self, action: #selector(showAllReply), for: .touchUpInside)
        }else{
            cell.showAllReplyBtn.isHidden = true
        }
        
        return cell
    }
}

extension NoteDetailVC{
    @objc private func showAllReply(sender: UIButton){
        let section = sender.tag
        //把这一段里的回复信息的isExpanded变为true,表明这些回复已展开
        replies[section].isExpanded = true
        //reloadSections后进numberOfRowsInSection判断,返回真正的行数,从而展示这段的所有回复
        tableView.performBatchUpdates {
            tableView.reloadSections(IndexSet(integer: section), with: .automatic)
        }

    }
}
