//
//  AppDelegate.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/1/6.
//

import UIKit
import CoreData
import LeanCloud

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        config()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "LittlePink")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    //主队列上的context存储
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //并发队列上的context存储
    func saveBackgroundContext(){
        //因可以有多个并发队列的context,故每次persistentContainer.viewContext时都会创建个新的,故不能像上面一样.
        //这里需用使用同一个并发队列的context(即常量文件夹中引用的那个)
        if backgroundContext.hasChanges{
            do {
                try backgroundContext.save()
            } catch {
                fatalError("后台存储数据失败(包括增删改):\(error)")
            }
        }
    }

}


extension AppDelegate{
    private func config(){
        // sdk
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = kAMapApiKey
        //UI
        UINavigationBar.appearance().tintColor = .label //设置所有的navigationItem的返回按钮颜色
        
        //初始化leanCloud
        LCApplication.logLevel = .off
        do {
            try LCApplication.default.set(
                id: kLCAppID,
                key: kLCAppKey,
                serverURL: kLCServerURL)
        } catch {
            print(error)
        }
         
    }
}

