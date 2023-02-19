//
//  NoteDetailVC-EditNote.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/19.
//

import Foundation
import LeanCloud
import Kingfisher
extension NoteDetailVC{
    func editNote(){
        //从缓存(内存)中获取当前笔记的图片
        var photos: [UIImage] = []
        
        if let coverPhotoPath = (note.get(kCoverPhotoCol) as? LCFile)?.url?.stringValue,
           let coverPhoto = ImageCache.default.retrieveImageInMemoryCache(forKey: coverPhotoPath){
            photos.append(coverPhoto)
        }
        
        if let photoPaths = note.get(kPhotosCol)?.arrayValue as? [String]{
            //之前
            let otherPhotos = photoPaths.compactMap{ ImageCache.default.retrieveImageInMemoryCache(forKey: $0) }
            photos.append(contentsOf: otherPhotos)
        }
        
        let vc = storyboard!.instantiateViewController(identifier: kNoteEditVCID) as! NoteEditVC
        vc.note = note
        vc.photos = photos
        vc.videoURL = nil
        vc.updateNoteFinished = { noteID in
            let query = LCQuery(className: kNoteTable)
            query.get(noteID){ res in
                if case let .success(object: note) = res{
                    self.note = note
                    self.showNote(true)
                }
            }
        }
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
