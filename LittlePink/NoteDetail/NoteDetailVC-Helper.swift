//
//  NoteDetailVC-Helper.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/19.
//

import Foundation
import LeanCloud
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
    
    func comment(){
        if let _ = LCApplication.default.currentUser{
            showTextView()
        }else{
            showTextHUD("请先登录")
        }
    }
    func showTextView(_ isReply:Bool = false, _ textViewPH: String = kNoteCommentPH ){
        //reset
        self.isReply = isReply
        textView.placeholder = textViewPH
        //UI
        textView.becomeFirstResponder()
        textViewBarView.isHidden = false
    }
    
    func hideAndResetTextView(){
        textView.resignFirstResponder()
        textView.text = ""
    }
    
}
