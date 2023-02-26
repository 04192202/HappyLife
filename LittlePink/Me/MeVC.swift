//
//  MeVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/9.
//

import UIKit
import LeanCloud
import SegementSlide

//跳转至此页面的三种情况:
//1.登录后切换childvc进入
//2.登录后点tabbar'我'进来
//3.点用户头像或昵称进入

//看此页面的两种情况(决定UI及action):
//1.本人已登录,看自己的个人页面 --点击个人简介可修改;显示'编辑资料','设置'按钮
//2.[本人已登录,看别的用户的个人页面]或[本人未登录,看别的用户或自己的个人页面] --点击个人简介不可修改;显示'悦生活','聊天'按钮

class MeVC: SegementSlideDefaultViewController {
    
    var user: LCUser
    lazy var meHeaderView = Bundle.loadView(fromNib: "MeHeaderView", with: MeHeaderView.self)
    
    var isFromNote = false
    var isMySelf = false
    
    init?(coder: NSCoder, user: LCUser) {
        self.user = user
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setUI()
    }
    //默认是外层大scrollview刷新
    override var bouncesType: BouncesType { .child }
    //头部视图
    override func segementSlideHeaderView() -> UIView? { setHeaderView() }
    //tab标题
    override var titlesInSwitcher: [String] { ["笔记", "收藏", "赞过"] }
    //tab
    override var switcherConfig: SegementSlideDefaultSwitcherConfig{
        var config = super.switcherConfig
        config.type = .tab
        config.selectedTitleColor = .label
        config.indicatorColor = mainColor
        return config
    }
    //内层滚动视图--用index判断是哪个tab的页面
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        //是否显示草稿cell
        let isMyDraft = (index == 0) && isMySelf && (UserDefaults.standard.integer(forKey: kDraftNoteCount) > 0)
        
        let vc = storyboard!.instantiateViewController(identifier: kWaterfallVCID) as! WaterfallVC
        
        vc.isMyDraft = isMyDraft
        vc.user = user
        vc.isMyNote = index == 0 //我的笔记
        vc.isMyFav = index == 1 //我的收藏
        vc.isMyselfLike = (isMySelf && index == 2)
        vc.isFromMeVC = true
        vc.fromMeVCUser = user
        return vc
    }
    
    
    //    @IBAction func logouttest(_ sender: Any) {
    //        LCUser.logOut()
    //        let loginVC = storyboard!.instantiateViewController(identifier: kLoginVCID)
    //        loginAndMeParentVC.removeChildren()
    //        loginAndMeParentVC.add(child: loginVC)
    //    }
    //
    //    @IBAction func showDraftNotes(_ sender: Any) {
    //
    //        let navi = storyboard!.instantiateViewController(identifier: kDraftNotesNaviID)
    //        navi.modalPresentationStyle = .fullScreen
    //        present(navi, animated: true)
    //    }
    //}
    //
    
}
