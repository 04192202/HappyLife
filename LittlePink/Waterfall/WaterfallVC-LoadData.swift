//
//  WaterfallVC-LoadData.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import CoreData
import LeanCloud
//云端加载数据
extension WaterfallVC{
    func getDraftNotes(){

        let request = DraftNote.fetchRequest() as NSFetchRequest<DraftNote>
        //分页(上拉加载)
        //request.fetchOffset = 0 // 0-20 从第1开始请求到20 依次循环下去
        //request.fetchLimit = 20 //偏移量：每次抓取20
        
        // MARK: - 排序 数组排序 ascending 正向排序  选择false倒叙 距离编辑最近的放在最前面
        let sortDescriptor1 = NSSortDescriptor(key: "updatedAt", ascending: false)
        //let sortDescriptor2 = NSSortDescriptor(key: "title", ascending: true) //文本的话按汉字的UNICODE编码或英文字母
        request.sortDescriptors = [sortDescriptor1]
        //数组中谁在前谁优先
        //request.sortDescriptors = [sortDescriptor1,sortDescriptor2]
        
        // MARK: - Fault--只在需要时加载数据(类似懒加载)--提高性能 (fault is fired)
        //request.returnsObjectsAsFaults = true //默认true
        //一开始只加载draftNotes的metadata(放入内存)
        //等实际访问到某个draftNote下面的某个属性的时候才加载此draftNote所有属性到内存--触发Fault
        
        //指定字段--提高性能
        //访问的某个draftNote下面的属性若已在propertiesToFetch中指定,则访问此属性不会触发Fault,访问其他属性会触发Fault
        request.propertiesToFetch = ["coverPhoto", "title", "updatedAt", "isVideo"]
        
        showLoadHUD()
        
        backgroundContext.perform {
            if let draftNotes = try? backgroundContext.fetch(request){
                self.draftNotes = draftNotes
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            self.hideLoadHUD()
        }
    }
    
    @objc func getNotes(){
        let query = LCQuery(className: kNoteTable)
        
        query.whereKey(kChannelCol, .equalTo(channel))//条件查询
        query.whereKey(kAuthorCol, .included)//同时查询出作者对象
        query.whereKey(kUpdatedAtCol, .descending)//排序 - 降序
        query.limit = kNotesOffset//上拉加载的分页
        
        query.find { result in
            if case let .success(objects: notes) = result{
                self.notes = notes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.header.endRefreshing()
            }
        }
    }
    
    @objc func getMyNotes(){
        let query = LCQuery(className: kNoteTable)
        
        query.whereKey(kAuthorCol, .equalTo(user!))//条件查询
        query.whereKey(kAuthorCol, .included)//同时查询出作者对象
        query.whereKey(kUpdatedAtCol, .descending)//排序 - 降序
        query.limit = kNotesOffset//上拉加载的分页
        
        query.find { result in
            if case let .success(objects: notes) = result{
                self.notes = notes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.header.endRefreshing()
            }
        }
    }
    
    @objc func getMyFavNotes(){
        getFavOrLike(kUserFavTable)
    }
    
    @objc func getMyLikeNotes(){
        getFavOrLike(kUserLikeTable)
    }
    
    private func getFavOrLike(_ className: String){
        let query = LCQuery(className: className)
        query.whereKey(kUserCol, .equalTo(user!))
        query.whereKey(kNoteCol, .selected)
        query.whereKey(kNoteCol, .included)
        query.whereKey("\(kNoteCol).\(kAuthorCol)", .included)
        query.whereKey(kUpdatedAtCol, .descending)//排序 - 降序
        query.limit = kNotesOffset
        query.find{res in
            if case let .success(objects: userFavOrLikes) = res{
                self.notes = userFavOrLikes.compactMap{ $0.get(kNoteCol) as? LCObject }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            DispatchQueue.main.async {
                self.header.endRefreshing()
            }
        }
    }
}
