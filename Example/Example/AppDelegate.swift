//
//  AppDelegate.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2020 Nathan Tannar. All rights reserved.
//

import UIKit
import BinartSwiftInputBar

//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        BARecordButton.displayMode = .image
        BARecordButton.normalImage = UIImage(named: "record_btn_normal")!
        BARecordButton.highlightImage = UIImage(named: "record_btn_highlight")!
        BARecordButton.missupImage = UIImage(named: "record_btn_missup")!

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: ExampleController())
        window?.makeKeyAndVisible()
                
        return true
    }
    

}
