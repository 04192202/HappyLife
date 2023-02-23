//
//  MeVC-HeaderView.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/23.
//

import Foundation
import LeanCloud

extension MeVC{
    func setHeaderView() -> UIView{
        let headerView = Bundle.loadView(fromNib: "MeHeaderView", with: MeHeaderView.self)
        //约束
        headerView.translatesAutoresizingMaskIntoConstraints = false
        //此处有小bug:页面往上推的时候会先折叠掉一部分--可能是包的问题,待解决
        headerView.heightAnchor.constraint(equalToConstant: headerView.rootStackView.frame.height + 26).isActive = true
        
        //传值
        headerView.user = user
        
        //左上角按钮的UI和action
        if isFromNote{
            headerView.backOrDrawerBtn.setImage(largeIcon("chevron.left"), for: .normal)
        }
        headerView.backOrDrawerBtn.addTarget(self, action: #selector(backOrDrawer), for: .touchUpInside)
        
        //个人简介,编辑资料/关注,设置/聊天
        if isMySelf{//登录后自己看自己
            headerView.introLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editIntro)))
        }else{//已登录看别人,未登录看自己或别人
            //个人简介label--若空则不显示placeholder,直接隐藏
            if user.getExactStringVal(kIntroCol).isEmpty{
                headerView.introLabel.isHidden = true
            }
            
            //编辑资料转化按钮
            if let _ = LCApplication.default.currentUser{
                //若已登录需要判断是否已经关注此人--此处省略,仍显示关注字样
                headerView.editOrFollowBtn.setTitle("悦生活", for: .normal)
                headerView.editOrFollowBtn.backgroundColor = mainColor
            }else{
                headerView.editOrFollowBtn.setTitle("悦生活", for: .normal)
                headerView.editOrFollowBtn.backgroundColor = mainColor
            }
            
            //聊天按钮
            headerView.settingOrChatBtn.setImage(fontIcon("ellipsis.bubble", fontSize: 13), for: .normal)
        }
        
        headerView.editOrFollowBtn.addTarget(self, action: #selector(editOrFollow), for: .touchUpInside)
        headerView.settingOrChatBtn.addTarget(self, action: #selector(settingOrChat), for: .touchUpInside)
        
        return headerView
    }
}
