//
//  Global-Functions.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/3/2.
//

import Foundation

// MARK: - 全局函数

func largeIcon(_ iconName:String , with color: UIColor = .label)-> UIImage {
    let config = UIImage.SymbolConfiguration(scale: .large)
    let icon = UIImage(systemName: iconName,withConfiguration: config)!
    
    return icon.withTintColor(color)
}

func fontIcon(_ iconName: String, fontSize: CGFloat, with color: UIColor = .label) -> UIImage{
    let config = UIImage.SymbolConfiguration(font: .systemFont(ofSize: fontSize))
    let icon = UIImage(systemName: iconName, withConfiguration: config)!
    return icon.withTintColor(color)
}


func showGlobalTextHUD(_ title: String){
    let window = UIApplication.shared.windows.last!
    let hud = MBProgressHUD.showAdded(to: window, animated: true)
    hud.mode = .text //不指定的话显示菊花和配置的文本
    hud.label.text = title
    hud.hide(animated: true, afterDelay: 2)
}

func jumpToSetting(){
    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
}
