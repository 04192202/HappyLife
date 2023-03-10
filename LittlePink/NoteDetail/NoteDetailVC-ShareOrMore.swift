//
//  NoteDetailVC-ShareOrMore.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/19.
//

import Foundation

extension NoteDetailVC{
    func shareOrMore(){
        if isReadMyNote{
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let shareAction = UIAlertAction(title: "分享", style: .default) { _ in
                //分享
            }
            let editAction = UIAlertAction(title: "编辑", style: .default) { _ in self.editNote() }
            let delAction = UIAlertAction(title: "删除", style: .destructive) { _ in self.delNote() }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel)
            
            alert.addAction(shareAction)
            alert.addAction(editAction)
            alert.addAction(delAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
            
        }else{
            
        }
    }
}
