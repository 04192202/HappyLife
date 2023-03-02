//
//  NoteEditVC-Note.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/16.
//

import LeanCloud

extension NoteEditVC{
    func createNote(){
        do {
            let noteGroup = DispatchGroup()
            
            let note = LCObject(className: kNoteTable)
            
            // MARK: 单个文件的存储
            if let videoURL = self.videoURL{
                let video = LCFile(payload: .fileURL(fileURL: videoURL))
                video.save(to: note, as: kVideoCol, group: noteGroup)
            }
            if let coverPhotoData = photos[0].jpeg(.high){
                let coverPhoto = LCFile(payload: .data(data: coverPhotoData))
                //coverPhoto.mimeType = "image/jpeg"
                coverPhoto.save(to: note, as: kCoverPhotoCol, group: noteGroup)
            }
            
            // MARK: 多个文件的存储
            //存为[LCFile]类型最后会变成[Pointer]类型(里面无path,不方便之后的取操作),需存为以下类型:
            //["https://1.jpg", "https://2.jpg", "https://3.jpg"]
            
            let photoGroup = DispatchGroup()
            //1.把所有文件存进云端
            var photoPaths: [Int: String] = [:]
            for (index, eachPhoto) in photos.enumerated(){
                if let eachPhotoData = eachPhoto.jpeg(.high){
                    let photo = LCFile(payload: .data(data: eachPhotoData))
                    photoGroup.enter()
                    photo.save { res in
                        //print("photo文件保存成功/失败")
                        if case .success = res, let path = photo.url?.stringValue{
                            photoPaths[index] = path
                        }
                        photoGroup.leave()
                    }
                }
            }
            //photoPaths(无序): [0: "https://1.jpg", 1: "https://2.jpg", 2: "https://3.jpg", ...]
            
            
            //2.得到所有的path后进行排序并把path数组存入表中对应的字段里
            noteGroup.enter()
            photoGroup.notify(queue: .main) {
                //var dic = [1: "aa", 3: "cc", 2: "bb", 4: "dd"]
                //let sortedDic = dic.sorted(by: <)//通过排序变成元祖数组
                //print(sortedDic)
                //[(key: 1, value: "aa"), (key: 2, value: "bb"), (key: 3, value: "cc"), (key: 4, value: "dd")]
                let photoPathsArr = photoPaths.sorted(by: <).map{ $0.value }
                
                do{
                    try note.set(kPhotosCol, value: photoPathsArr)
                    note.save { _ in
                        //print("存储photos字段成功/失败")
                        noteGroup.leave()
                    }
                }catch{
                    print("字段赋值失败: \(error)")
                }
            }
            
            
            // MARK: 一般类型的存储
            //封面图宽高比
            let coverPhotoSize = photos[0].size
            let coverPhotoRatio = Double(coverPhotoSize.height / coverPhotoSize.width)
            
            try note.set(kCoverPhotoRatioCol, value: coverPhotoRatio)
            try note.set(kTitleCol, value: titleTextField.exactText)
            try note.set(kTextCol, value: textView.exactText)
            try note.set(kChannelCol, value: channel.isEmpty ? "推荐" : channel)
            try note.set(kSubChannelCol, value: subChannel)
            try note.set(kPOINameCol, value: poiName)
            try note.set(kLikeCountCol, value: 0)
            try note.set(kFavCountCol, value: 0)
            try note.set(kCommentCountCol, value: 0)
            
            //笔记的作者
            let author = LCApplication.default.currentUser!
            try note.set(kAuthorCol, value: author)
            
            noteGroup.enter()
            note.save { _ in
                //print("存储一般数据字段成功/失败")
                noteGroup.leave()
            }
            
            
            noteGroup.notify(queue: .main) {
                //print("笔记内容全部存储结束")
                
// MARK: -请求通知授权
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
        if let error = error {  print("请求通知授权出错\(error)")    }
    }
    //用户经一定的操作后，判断用户对通知的授权状态，若发布2篇以上的笔记请求权限，取消授权弹出自定义请求权限框（ios系统只弹出一次）
    let noteCount = author.getExactIntVal(kNoteCountCol)
    if noteCount != 0 , noteCount % 3 == 0{ self.showAllowPushAlert() }
                
    //用户表的noteCount + 1
    try? author.increase(kNoteCountCol)
    author.save{ _ in }
                
    self.showTextHUD("发布笔记成功", false)
}
            
            if draftNote != nil{
                navigationController?.popViewController(animated: true)
            }else{
                dismiss(animated: true)
            }
            
        } catch {
            print("字段赋值失败: \(error)")
        }
    }
    
    func postDraftNote(_ draftNote: DraftNote){
        createNote()
        
        //发布草稿笔记时需删掉这个草稿
        backgroundContext.perform {
            backgroundContext.delete(draftNote)
            appDelegate.saveBackgroundContext()
            
            //UI
            DispatchQueue.main.async {
                self.postDraftNoteFinished?()
            }
        }
    }
    
    func updateNote(_ note: LCObject){
        do {
            let noteGroup = DispatchGroup()
            
            if !isVideo{
                if let coverPhotoData = photos[0].jpeg(.high){
                    let coverPhoto = LCFile(payload: .data(data: coverPhotoData))
                    //coverPhoto.mimeType = "image/jpeg"
                    coverPhoto.save(to: note, as: kCoverPhotoCol, group: noteGroup)
                }
                
                let photoGroup = DispatchGroup()
                var photoPaths: [Int: String] = [:]
                for (index, eachPhoto) in photos.enumerated(){
                    if let eachPhotoData = eachPhoto.jpeg(.high){
                        let photo = LCFile(payload: .data(data: eachPhotoData))
                        photoGroup.enter()
                        photo.save { res in
                            //print("photo文件保存成功/失败")
                            if case .success = res, let path = photo.url?.stringValue{
                                photoPaths[index] = path
                            }
                            photoGroup.leave()
                        }
                    }
                }
                noteGroup.enter()
                photoGroup.notify(queue: .main) {
                    let photoPathsArr = photoPaths.sorted(by: <).map{ $0.value }
                    
                    do{
                        try note.set(kPhotosCol, value: photoPathsArr)
                        note.save { _ in
                            //print("存储photos字段成功/失败")
                            noteGroup.leave()
                        }
                    }catch{
                        print("字段赋值失败: \(error)")
                    }
                }
            }
            
            //封面图宽高比
            let coverPhotoSize = photos[0].size
            let coverPhotoRatio = Double(coverPhotoSize.height / coverPhotoSize.width)
            
            try note.set(kCoverPhotoRatioCol, value: coverPhotoRatio)
            try note.set(kTitleCol, value: titleTextField.exactText)
            try note.set(kTextCol, value: textView.exactText)
            try note.set(kChannelCol, value: channel.isEmpty ? "推荐" : channel)
            try note.set(kSubChannelCol, value: subChannel)
            try note.set(kPOINameCol, value: poiName)
            
            try note.set(kHasEditCol, value: true)
            
            noteGroup.enter()
            note.save { _ in
                //print("存储一般数据字段成功/失败")
                noteGroup.leave()
            }
            
            
            noteGroup.notify(queue: .main) {
                //print("笔记内容全部存储结束")
                self.updateNoteFinished?(note.objectId!.stringValue!)
                self.showTextHUD("更新笔记成功", false)
            }
            
            dismiss(animated: true)
        } catch {
            print("字段赋值失败: \(error)")
        }
    }
}
