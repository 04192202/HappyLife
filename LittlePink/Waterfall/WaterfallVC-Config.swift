//
//  WaterfallVC-Config.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import CHTCollectionViewWaterfallLayout

extension WaterfallVC{
    func config(){
        
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        
        layout.columnCount = 2
        layout.minimumColumnSpacing = kWaterfallPadding
        layout.minimumInteritemSpacing = kWaterfallPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        
        if isMyDraft{
            navigationItem.title = "本地草稿"
        }
        
    }
}
