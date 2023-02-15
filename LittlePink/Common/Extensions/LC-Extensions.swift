//
//  LC-Extensions.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/15.
//

import Foundation
import LeanCloud

extension LCFile{
    func save(to tabel:LCObject, as record: String){
        //保存头像
        self.save{ result in
            switch result{
            case .success:
                if let value = self.objectId?.value{
                    print("文件保存完成 objectID:\(value)")
                    
                    do {
                        try tabel.set(record, value: self)
                        tabel.save { (result) in
                            switch result {
                            case .success:
                                break
                            case .failure(error: let error):
                                print("保存文件进云端失败:\(error)")
                            }
                        }
                    } catch {
                        print("给字段赋值失败/重复赋值\(error)")
                    }
                }
            case .failure(error: let error):
                //保存失败
                print("保存文件进云端失败:\(error)")
            }
        }
    }
}
