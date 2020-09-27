//
//  InputBarStyle.swift
//  Example
//
//  Created by Nathan Tannar on 8/18/17.
//  Copyright © 2017-2020 Nathan Tannar. All rights reserved.
//

import Foundation
import BinartSwiftInputBar

enum InputBarStyle: String, CaseIterable {
    
    case wechat = "微信"
    
    func generate() -> InputBarAccessoryView {
        switch self {
        case .wechat: return WechatInputBar()
        }
    }
}
