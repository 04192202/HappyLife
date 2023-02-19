//
//  LC-Extensions.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/15.
//

import Foundation
import LeanCloud

extension LCFile{
    func save(to tabel:LCObject, as record: String , group :DispatchGroup? = nil){
        group?.enter()
        //保存头像
        self.save{ result in
            switch result{
                
            case .success:
                if let _ = self.objectId?.value{
                   // print("文件保存完成 objectID:\(value)")
                    
                    do {
                        try tabel.set(record, value: self)
                        group?.enter()
                        tabel.save { (result) in
                            switch result {
                            case .success:
                                break
                            case .failure(error: let error):
                                print("保存文件进云端失败:\(error)")
                            }
                            group?.leave()
                        }
                    } catch {
                        print("给字段赋值失败/重复赋值\(error)")
                    }
                }
            case .failure(error: let error):
                //保存失败
                print("保存文件进云端失败:\(error)")
            }
            group?.leave()
        }
    }
}


extension LCObject{
    func getExactStringVal(_ col: String) -> String { get(col)?.stringValue ?? "" }
    func getExactIntVal(_ col: String) -> Int { get(col)?.intValue ?? 0 }
    func getExactDoubelVal(_ col: String) -> Double { get(col)?.doubleValue ?? 1 }//这里取1,方便大多数情况使用
    func getExactBoolVal(_ col: String) -> Bool { get(col)?.boolValue ?? false }//仅少数地方用(如性别)
    
    enum imageType {
        case avater
        case coverPhoto
    }
    
    //从云端的某个file(image类型)字段取出path再变成URL
    func getImageURL(from col: String, _ type: imageType) -> URL{
        if let file = get(col) as? LCFile,
           let path = file.url?.stringValue,
           let url = URL(string: path) {
            return url
        }else{
            switch type{
            case .avater:
                return Bundle.main.url(forResource: "PH1", withExtension: "jpg")!
            case .coverPhoto:
                return Bundle.main.url(forResource: "imagePH", withExtension: "png")!
            }
        }
    }
}


