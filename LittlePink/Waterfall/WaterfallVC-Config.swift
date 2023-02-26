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
        var inset: UIEdgeInsets = .zero
        if let _ = user{
            inset = UIEdgeInsets(top: 10, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }else{
            inset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }
        layout.sectionInset = inset
        
//        if isDraft{
//            layout.sectionInset = UIEdgeInsets(top: 44, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
//        }
        
        if isDraft{
            navigationItem.title = "本地草稿"
        }
        
        //注册'我的草稿cell'
        collectionView.register(UINib(nibName: "MyDraftNoteWaterfallCell", bundle: nil), forCellWithReuseIdentifier: kMyDraftNoteWaterfallCellID)
        
        collectionView.mj_header = header
        
    }
}


