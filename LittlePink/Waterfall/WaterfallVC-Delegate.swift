//
//  WaterfallVC-Delegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import Foundation
extension WaterfallVC{
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMyDraft{
            let draftNote = draftNotes[indexPath.item]
            
            if let photosData = draftNote.photos,
               let photosDataArr = try? JSONDecoder().decode([Data].self, from: photosData){
                
                let photos = photosDataArr.map { UIImage($0) ?? imagePH }
                //UUID随机标识符
                let videoURL = FileManager.default.save(draftNote.video, to: "video", as: "\(UUID().uuidString).mp4")
                
                let vc = storyboard!.instantiateViewController(identifier: kNoteEditVCID) as! NoteEditVC
                
                vc.draftNote = draftNote
                vc.photos = photos
                vc.videoURL = videoURL
                //闭包传值 NoteEditeVC
                vc.updateDraftNoteFinished = { self.getDraftNotes() }
                
                navigationController?.pushViewController(vc, animated: true)
                
            }else{
                showTextHUD("加载草稿失败")
            }
            
            
        }else{
            
        }
    }
}
