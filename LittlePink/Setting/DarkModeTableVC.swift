//
//  DarkModeTableVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/28.
//

import UIKit

class DarkModeTableVC: UITableViewController {

    
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var followSystemSwitch:UISwitch!
    
    //系统协议 - 枚举型 当前app的深浅色模式
    var userInterfaceStyle : UIUserInterfaceStyle { traitCollection.userInterfaceStyle }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkModeSwitch.isOn = userInterfaceStyle == .dark
        //默认跟随系统，系统默认返回0
        followSystemSwitch.isOn = UserDefaults.standard.integer(forKey: kUserInterfaceStyle) == 0
    }
    
    
    @IBAction func toggle(_ sender:Any){
        //设置深浅色模式
        //view.overrideUserInterfaceStyle = .dark  当前view包含子视图
        //self.overrideUserInterfaceStyle = .dark  controller
        followSystemSwitch.setOn(false, animated: true)
        setUserInterfaceStyle() //整个app
    }
    
    @IBAction func followSystem(_ sender:Any){
        if followSystemSwitch.isOn{
            // 跟随系统设定
            view.window?.overrideUserInterfaceStyle = .unspecified
            darkModeSwitch.setOn(userInterfaceStyle == .dark, animated: true)
        }else{
            setUserInterfaceStyle()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if followSystemSwitch.isOn{
            //dismiss 重新赋值
            UserDefaults.standard.set(0, forKey: kUserInterfaceStyle)
        }else{
            UserDefaults.standard.set(darkModeSwitch.isOn ? 2 : 1, forKey: kUserInterfaceStyle)
        }
    }
    
    private func setUserInterfaceStyle(){
        view.window?.overrideUserInterfaceStyle = darkModeSwitch.isOn ? .dark : .light
    }
    
}
