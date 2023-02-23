//
//  WaterfallVC-DataSource.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import Foundation
//数量配置
extension WaterfallVC{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMyDraft{
            return draftNotes.count
        }else{
            return notes.count
        }
    }
//数据配置
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isMyDraft{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftNoteWaterfallCellID, for: indexPath) as! DraftNoteWaterfallCell
            
            cell.draftNote = draftNotes[indexPath.item]
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallCell
            
            cell.note = notes[indexPath.item]
            return cell
        }
    }
}

// MARK: - 删除草稿箱
extension WaterfallVC{
    private func deleteDraftNote(_ index: Int){
        
        backgroundContext.perform {
            let draftNote = self.draftNotes[index]
            //数据1:本地CoreData里的
            backgroundContext.delete(draftNote)
            appDelegate.saveBackgroundContext()
            //数据2:内存中的
            self.draftNotes.remove(at: index)
            
            UserDefaults.decrease(kDraftNoteCount)
            
            //UI
            DispatchQueue.main.async {
                //用deleteItems会出现'index out of range'的错误,因为DataSource里面的index没有更新过来,故直接使用reloadData
                self.collectionView.reloadData()
                self.showTextHUD("删除草稿成功")
            }
        }
    }
}

// MARK: - 监听  删除弹出框
extension WaterfallVC{
    @objc private func showAlert(_ sender: UIButton){
        
        let index = sender.tag
        
        let alert = UIAlertController(title: "提示", message: "确认删除该草稿吗?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel)
        //destructive 删除不可恢复
        let action2 = UIAlertAction(title: "确定", style: .destructive) { _ in self.deleteDraftNote(index) }
        
        alert.addAction(action1)
        alert.addAction(action2)
        
        present(alert, animated: true)
    }
}
