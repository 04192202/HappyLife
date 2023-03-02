//
//  WaterfallVC-Delegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import Foundation
extension WaterfallVC{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMyDraft , indexPath.item == 0{
            let navi = storyboard!.instantiateViewController(identifier: kDraftNotesNaviID) as! UINavigationController
            navi.modalPresentationStyle = .fullScreen
            ((navi.topViewController) as! WaterfallVC).isDraft = true
            present(navi, animated: true)
            
        }else if isDraft{
            let draftNote = draftNotes[indexPath.item]
            
            if let photosData = draftNote.photos,
               let photosDataArr = try? JSONDecoder().decode([Data].self, from: photosData){
                
                let photos = photosDataArr.map { UIImage($0) ?? imagePH }
                
                //UUID随机标识符 编辑或者取消编辑完后需要删除，放止temp文件容量过大
                let videoURL = FileManager.default.save(draftNote.video, to: "video", as: "\(UUID().uuidString).mp4")
                
                let vc = storyboard!.instantiateViewController(identifier: kNoteEditVCID) as! NoteEditVC
                
                vc.draftNote = draftNote
                vc.photos = photos
                vc.videoURL = videoURL
                //闭包传值 NoteEditeVC
                //更新草稿后刷新所有的草稿
                vc.updateDraftNoteFinished = { self.getDraftNotes() }
                //发布草稿后刷新到所有草稿
                vc.postDraftNoteFinished = {self.getDraftNotes() }
                
                navigationController?.pushViewController(vc, animated: true)
                
            }else{
                showTextHUD("加载草稿失败")
            }
            
            
        }else{
            let offset = isMyDraft ? 1 : 0
            let item = indexPath.item - offset
            //依赖注入
            let detailVC = storyboard!.instantiateViewController(identifier: kNoteDetailVCID){coder in
                NoteDetailVC(coder: coder , note : self.notes[item])
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? WaterfallCell{
                detailVC.isLikeFromWaterfallCell = cell.isLike
            }
            
            detailVC.modalPresentationStyle = .fullScreen
            detailVC.delegate = self
            
            //删除笔记后回到首页后刷新首页
            detailVC.delNoteFinished = {
                self.notes.remove(at:item)
                collectionView.performBatchUpdates{
                    collectionView.deleteItems(at: [indexPath])
                }
            }
            detailVC.isFromMeVC = isFromMeVC
            detailVC.fromMeVCUser = fromMeVCUser
            detailVC.cellItem = indexPath.item
            detailVC.noteHeroID = "noteHeroID\(indexPath.item)"
            
            present(detailVC, animated: true)
        }
    }
}

extension WaterfallVC: NoteDetailVCDelegate{
    func updateLikeBtn(cellItem: Int, isLike: Bool, likeCount: Int) {
       if let cell = collectionView.cellForItem(at: IndexPath(item: cellItem, section: 0)) as? WaterfallCell{
           cell.likeBtn.isSelected = isLike
           cell.likeCount = likeCount
           cell.currentLikeCount = likeCount
        }
    }
}

