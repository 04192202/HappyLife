//
//  NotificationTableVC.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/27.
//

import UIKit

class NotificationTableVC: UITableViewController {

    var isNoteDetermined = false
    
    @IBOutlet weak var toggleAllowNotificationSwitch:UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @IBAction func toggleAllowNotification(_ sender:UISwitch){
        if sender.isOn, isNoteDetermined{
           
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted , error) in
                
                if !granted{//若用户拒绝授权，关闭开关
                    self.setSwitch(false)
                }
            }//reset处理：用户可能在拒绝授权后重新授权
            isNoteDetermined = false
        }else{ // 默认打开 再点击关闭
            jumpToSetting()
        }
    }
        
}

extension NotificationTableVC{
    private func setUI(){
        UNUserNotificationCenter.current().getNotificationSettings{ settings in
            switch settings.authorizationStatus{
                
            case .notDetermined:
                self.setSwitch(false)
                self.isNoteDetermined = true //从未请求授权
            case.denied:
                self.setSwitch(false)
            default:
                self.setSwitch(true)
            }
        }
    }
    
    
    private func setSwitch(_ on:Bool){
            DispatchQueue.main.async {
                self.toggleAllowNotificationSwitch.setOn(on, animated: true)
        }
    }
    
    @objc private func willEnterForeground(){
        //监听app回到前台
        setUI()
    }
}



    


