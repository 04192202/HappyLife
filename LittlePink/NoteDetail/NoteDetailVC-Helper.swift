//
//  NoteDetailVC-Helper.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/19.
//

import LeanCloud

//评论回复辅助函数
extension NoteDetailVC{
    //用户按下评论按钮(共三处)后,弹出评论用的textView
    func comment(){
        if let _ = LCApplication.default.currentUser{
            showTextView()
        }else{
            showLoginHUD()
        }
    }
    
    //用户按下某个评论或某个评论的回复时,弹出回复用的textView
    func prepareForReply(_ nickName: String, _ section: Int, _ replyToUser: LCUser? = nil){
        //参数1:全局变量isReply(flag)--因共用textview,故在textview后面的'发送'按钮按下时判断究竟是发评论还是回复
        //参数2:textView的placeholder
        //参数3:全局变量replyToUser(flag),若有则表明自己是子回复,写入云端回复表时追加被回复人这一字段
        //都传参进去,每次都处理(reset)
        showTextView(true, "回复 \(nickName)", replyToUser)
        commentSection = section
    }
    
    //弹出textView,可用作评论/回复/子回复
    func showTextView(_ isReply: Bool = false, _ textViewPH: String = kNoteCommentPH, _ replyToUser: LCUser? = nil){
        //reset
        self.isReply = isReply
        textView.placeholder = textViewPH
        self.replyToUser = replyToUser
        
        //UI
        textView.becomeFirstResponder()
        textViewBarView.isHidden = false
    }
    //用户发布评论或者回复后
    func hideAndResetTextView(){
        textView.resignFirstResponder()
        //reset
        textView.text = ""
    }
}

//普通辅助函数
extension NoteDetailVC{
    //删除某个东西之前给用户的alert提示框
    func showDelAlert(for name: String, confirmHandler: ((UIAlertAction) -> ())?){
        let alert = UIAlertController(title: "提示", message: "确认删除此\(name)", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel)
        let action2 = UIAlertAction(title: "确认", style: .default, handler: confirmHandler)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true)
    }

    //1.note表的commentCount字段增减,2.commentCount增减--自动反映到UI
    func updateCommentCount(by offset: Int){
        //云端数据
        //目前LC的increase用法注意(均为自己实践,非官方说明)
        //1.评论数的增减这边,递增递减均需save;2.点赞收藏那边的递增不能save,不然会变成递增2
        try? self.note.increase(kCommentCountCol, by: offset)
        note.save { _ in }
        //UI
        self.commentCount += offset
    }
    
    
    func backToCell(){
        //如果用户是从瀑布流cell过来需要更新cell的点赞去重
        if let cellItem = cellItem{
            delegate?.updateLikeBtn(cellItem: cellItem, isLike: isLike, likeCount: likeCount)
        }
        dismiss(animated: true)
    }
}
