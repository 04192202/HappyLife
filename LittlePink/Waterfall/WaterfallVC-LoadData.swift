//
//  WaterfallVC-LoadData.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import CoreData

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
}
