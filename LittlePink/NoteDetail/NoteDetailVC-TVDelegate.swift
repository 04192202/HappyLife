//
//  NoteDetailVC-TVDelegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/20.
//

import Foundation
import LeanCloud

extension NoteDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let commentView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kCommentViewID) as! CommentView
        let comment = comments[section]
        commentView.comment =  comment
        
        if let commentAuthor = comment.get(kUserCol) as? LCUser, let noteAuthor = author, commentAuthor == noteAuthor {
            commentView.authorLabel.isHidden = false
        }
    
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(commentTapped))
        commentView.tag  = section
        commentView.addGestureRecognizer(commentTap)
        return commentView
    }
}
// 监听
extension NoteDetailVC{
    @objc private func commentTapped(_ tap:UITapGestureRecognizer){
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
                    self.prePareForReply(commentAuthorNickName , section)
                }
                //改变alert回复的颜色
                replyAction.setTitleColor(mainColor)
                let copyAction = UIAlertAction(title: "复制", style: .default) { _ in //复制
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
                
                

            }else{
                //当前登录用户点击别人发布的评论--回复评论
                prePareForReply(commentAuthorNickName , section)
            }
           
            
        }else{
            showTextHUD("请先登录")
        }
    }
}

extension NoteDetailVC{
    private func prePareForReply(_ commentAuthorNickName:String , _ section: Int){
        
        showTextView(true, "回复 @\(commentAuthorNickName)")
        commentSection = section
    }
}
