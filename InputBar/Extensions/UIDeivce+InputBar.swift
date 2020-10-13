//
//  UIDeivce+InputBar.swift
//  BinartSwiftInputBar
//
//  Created by Seven on 2020/10/10.
//

import Foundation
import UIKit

public extension UIDevice {
    static var isFullScreen: Bool {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                  return false
              }
              
              if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
//                  print(unwrapedWindow.safeAreaInsets)
                
//                以下分别是竖屏与横屏的时候,safeAreaInsets打印的值
//
//                UIEdgeInsets(top: 44.0, left: 0.0, bottom: 34.0, right: 0.0)
//                UIEdgeInsets(top: 0.0, left: 44.0, bottom: 21.0, right: 44.0)

                  return true
              }
        }
        return false
    }
    
    static var kNavigationBarHeight: CGFloat {
       //return UIApplication.shared.statusBarFrame.height == 44 ? 88 : 64
       return isFullScreen ? 88 : 64
    }
        
    static var kBottomSafeHeight: CGFloat {
       //return UIApplication.shared.statusBarFrame.height == 44 ? 34 : 0
       return isFullScreen ? 34 : 0
    }
}
