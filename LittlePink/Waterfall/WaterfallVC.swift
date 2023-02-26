//
//  WaterfallVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/30.
//
import UIKit
import CHTCollectionViewWaterfallLayout
import XLPagerTabStrip
import LeanCloud
import SegementSlide

class WaterfallVC: UICollectionViewController,SegementSlideContentScrollViewDelegate {
    
    var channel = ""
    
    lazy var header = MJRefreshNormalHeader()
    
    @objc var scrollView: UIScrollView { collectionView }
    
    //草稿页相关数据
    var isDraft = false
    var draftNotes: [DraftNote] = []
    
    //首页相关数据
    var notes: [LCObject] = []
    
    //个人页相关数据
    var isMyDraft = false//用于判断是否显示我的草稿cell
    var user: LCUser?//可用于判断当前是否在个人页面
    var isMyNote = false//在上面user的基础上,用于判断是否是'笔记'tab页
    var isMyFav = false//在上面user的基础上,用于判断是否是'收藏'tab页
    var isMyselfLike = false//在上面user的基础上,用于判断已登录用户是否在看自己的'赞过'tab页
    var isFromMeVC = false
    var fromMeVCUser: LCUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        config()
        
        if let _ = user { //个人页面
            
            if isMyNote{
                //下拉刷新
                header.setRefreshingTarget(self, refreshingAction: #selector(getMyNotes))
                
            }else if isMyFav{
                //下拉刷新
                header.setRefreshingTarget(self, refreshingAction: #selector(getMyFavNotes))
            }else{
                header.setRefreshingTarget(self, refreshingAction: #selector(getMyLikeNotes))
            }
            //自动刷新
            header.beginRefreshing()
        }else if isDraft{//草稿总页面
            getDraftNotes()
        }else{//首页
            header.setRefreshingTarget(self, refreshingAction: #selector(getNotes))
            //自动刷新
            header.beginRefreshing()
        }
    }
    @IBAction func dismissDraftNotesVC(_ sender: Any) {
        dismiss(animated: true)
    }
    
}


extension WaterfallVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
