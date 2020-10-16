//
//  main.swift
//  Example
//
//  Created by Seven on 2020/10/13.
//  Copyright © 2020 Nathan Tannar. All rights reserved.
//

import Foundation
import UIKit

private let pointer = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
UIApplicationMain(CommandLine.argc, pointer, NSStringFromClass(App.self), NSStringFromClass(AppDelegate.self))
