//
//  MeVC-UI.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/23.
//

import Foundation
import SegementSlide

extension MeVC{
    func setUI(){
        scrollView.backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground
        switcherView.backgroundColor = .systemBackground
        
        let statusBarOverlayView = UIView(frame: CGRect(x: 0, y: 0, width: screenRect.width, height: kStatusBarH))
        statusBarOverlayView.backgroundColor = .systemBackground
        view.addSubview(statusBarOverlayView)
        
        defaultSelectedIndex = 0
        reloadData()
    }
}
