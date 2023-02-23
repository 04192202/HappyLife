//
//  NoteDetailVC-TVDelegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

import Foundation
import LeanCloud

extension NoteDetailVC: UITableViewDelegate{
    //sectionHeader
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let commentView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kCommentViewID) as! CommentView
        //单个的评论对象
        let comment = comments[section]
        //评论人对象
        let commentAuthor = comment.get(kUserCol) as? LCUser
        
        //传到评论view里去,用于展示评论
        commentView.comment = comment
        
        //判断评论人是否是笔记作者
        if let commentAuthor = commentAuthor, let noteAuthor = author, commentAuthor == noteAuthor{
            commentView.authorLabel.isHidden = false
        }else{
            commentView.authorLabel.isHidden = true
        }
        
        //轻触评论
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(commentTapped))
        commentView.tag = section
        commentView.addGestureRecognizer(commentTap)
        
        //轻触评论人头像或昵称
        //1.子视图手势优先执行
        //2.手势的#selector函数传值:搞一个手势的子类,在子类中加个属性即可
        //3.一个手势识别器只可用于一个视图--文档不全,可以从他的view属性得以窥见.(而一个视图可以添加多个手势)
        
        let avatarTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        avatarTap.passObj = commentAuthor
        commentView.avatarImageView.addGestureRecognizer(avatarTap)
        
        let nickNameTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        nickNameTap.passObj = commentAuthor
        commentView.nickNameLabel.addGestureRecognizer(nickNameTap)


        return commentView
    }
    //sectionFooter
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorLine = tableView.dequeueReusableHeaderFooterView(withIdentifier: kCommentSectionFooterViewID)
        return separatorLine
    }
    //用户按下评论的回复cell后,对这个回复进行复制或删除或再回复
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = LCApplication.default.currentUser{
            let reply = replies[indexPath.section].replies[indexPath.row]
            
            guard let replyAuthor = reply.get(kUserCol) as? LCUser else { return }
            //回复被回复人
            let replyAuthorNickName = replyAuthor.getExactStringVal(kNickNameCol)

            //当前登录用户点击自己发布的回复
            if user == replyAuthor {
                let replyText = reply.getExactStringVal(kTextCol)
                
                let alert = UIAlertController(title: nil, message: "你的回复: \(replyText)", preferredStyle: .actionSheet)
                let subReplyAction = UIAlertAction(title: "回复", style: .default) { _ in
                    self.prepareForReply(replyAuthorNickName, indexPath.section, replyAuthor)
                }
                let copyAction = UIAlertAction(title: "复制", style: .default) { _ in
                    UIPasteboard.general.string = replyText
                }
                let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
                    self.delReply(reply, indexPath)
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                alert.addAction(subReplyAction)
                alert.addAction(copyAction)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true)
            }else{//当前登录用户点击别人发布的回复--回复这个回复
                self.prepareForReply(replyAuthorNickName, indexPath.section, replyAuthor)
            }
        }else{
            showLoginHUD()
        }
    }
}
//监听
extension NoteDetailVC{
    //用户按下笔记的评论后,对这个评论进行复制或删除或回复
    @objc private func commentTapped(_ tap: UITapGestureRecognizer){
        if let user = LCApplication.default.currentUser{
            guard let section = tap.view?.tag else { return }
            let comment = comments[section]
            guard let commentAuthor = comment.get(kUserCol) as? LCUser else { return }
            let commentAuthorNickName = commentAuthor.getExactStringVal(kNickNameCol)
            
            //当前登录用户点击自己发布的评论
            if user == commentAuthor{
                
                let commentText = comment.getExactStringVal(kTextCol)
                
                let alert = UIAlertController(title: nil, message: "你的评论: \(commentText)", preferredStyle: .actionSheet)
                let replyAction = UIAlertAction(title: "回复", style: .default) { _ in
                    self.prepareForReply(commentAuthorNickName, section)
                }
                let copyAction = UIAlertAction(title: "复制", style: .default) { _ in
                    UIPasteboard.general.string = commentText
                }
                let deleteAction = UIAlertAction(title: "删除", style: .destructive) { _ in
                    self.delComment(comment, section)
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                
                alert.addAction(replyAction)
                alert.addAction(copyAction)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                
                present(alert, animated: true)
                
            }else{//当前登录用户点击别人发布的评论--回复评论
                prepareForReply(commentAuthorNickName, section)
            }
        }else{
            showLoginHUD()
        }
    }
}
