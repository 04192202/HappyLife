//
//  MeVC-BackOrDrawer.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/23.
//

import Foundation

extension MeVC{
    @objc func backOrDrawer(_ sender: UIButton){
        if isFromNote{
            dismiss(animated: true)
        }else{
            //抽屉菜单
        }
    }
}
