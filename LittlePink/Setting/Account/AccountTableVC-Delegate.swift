//
//  AccountTableVC-Delegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/27.
//

import Foundation

extension AccountTableVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0{
            if row == 0{
                showTextHUD("绑定")
          }else if row == 1{
              if let _ = phoneNumStr{ //performSegue 此方法必须是sb创建Identifier 才可以用不然会抛出异常
                  performSegue(withIdentifier: kShowPasswordTableVCID, sender: nil)
              }else {
                  showTextHUD("需要绑定手机号")
              }
          }//解除绑定
        }else if section == 1{
            switch row{
            case 0:
                showTextHUD("解除支付宝账号")
            case 1:
                showTextHUD("解除Apple账号")
            default:
                break
            }
        }
    }
}
