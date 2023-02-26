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
        
        //约束
        meHeaderView.translatesAutoresizingMaskIntoConstraints = false
        //此处有小bug:页面往上推的时候会先折叠掉一部分--可能是包的问题,待解决
        meHeaderView.heightAnchor.constraint(equalToConstant: meHeaderView.rootStackView.frame.height + 26).isActive = true
        
        //传值
        meHeaderView.user = user
        
        //左上角按钮的UI和action
        if isFromNote{
            meHeaderView.backOrDrawerBtn.setImage(largeIcon("chevron.left"), for: .normal)
        }
        meHeaderView.backOrDrawerBtn.addTarget(self, action: #selector(backOrDrawer), for: .touchUpInside)
        
        //个人简介,编辑资料/关注,设置/聊天
        if isMySelf{//登录后自己看自己
            meHeaderView.introLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editIntro)))
        }else{//已登录看别人,未登录看自己或别人
            //个人简介label--若空则不显示placeholder,直接隐藏
            if user.getExactStringVal(kIntroCol).isEmpty{
                meHeaderView.introLabel.isHidden = true
            }
            
            //编辑资料转化按钮
            if let _ = LCApplication.default.currentUser{
                //若已登录需要判断是否已经关注此人--此处省略,仍显示关注字样
                meHeaderView.editOrFollowBtn.setTitle("悦生活", for: .normal)
                meHeaderView.editOrFollowBtn.backgroundColor = mainColor
            }else{
                meHeaderView.editOrFollowBtn.setTitle("悦生活", for: .normal)
                meHeaderView.editOrFollowBtn.backgroundColor = mainColor
            }
            
            //聊天按钮
            meHeaderView.settingOrChatBtn.setImage(fontIcon("ellipsis.bubble", fontSize: 13), for: .normal)
        }
        
        meHeaderView.editOrFollowBtn.addTarget(self, action: #selector(editOrFollow), for: .touchUpInside)
        meHeaderView.settingOrChatBtn.addTarget(self, action: #selector(settingOrChat), for: .touchUpInside)
        
        return meHeaderView
    }
}
