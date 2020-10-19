//
//  SlackInputBar.swift
//  Example
//
//  Created by Nathan Tannar on 2018-06-06.
//  Copyright © 2018 Nathan Tannar. All rights reserved.
//

import UIKit
import BinartSwiftInputBar
import BinartOCStickerKeyboard

class WechatInputBar: InputBarAccessoryView {
    
    var emoticonExtended: Bool = false
    var voiceExtended: Bool = false
    var extExtended: Bool = false
    
    var audioBtn: InputBarButtonItem!
    var stickerBtn: InputBarButtonItem!
    var extBtn: InputBarButtonItem!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStickerKeyboard () {
        
    }
    
    func setupPlotView () {
        
    }
    
    func setupRecordView () {
        
    }
    
    func setupInputBar () {
        
    }
    
    func configure() {
        inputHelper.textView.backgroundColor = .red
        self.middleContentViewPadding = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)

        // MARK: = 输入框
        
        // We can change the container insets if we want
        inputHelper.textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        inputHelper.textView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        // MARK: = 表情扩展
        BAInputConfig.shared.deleteImageNormal = UIImage.init(named: "delete-emoji") ?? UIImage()
        BAInputConfig.shared.previewImage = UIImage.init(named: "emoji-preview-bg") ?? UIImage()
        BAInputConfig.shared.toggleEmoji = UIImage.init(named: "toggle_emoji") ?? UIImage()
        BAInputConfig.shared.toggleKeyboard = UIImage.init(named: "toggle_keyboard") ?? UIImage()
        BAInputConfig.shared.configFile = "ExampleSticker.plist";
        BAInputConfig.shared.config()
        
        // 固定表情键盘高度
        let emoticonView = inputHelper.stickerKeyboard//PPStickerKeyboard()
        emoticonView.frame = CGRect(x: 0, y: 0, width: 0, height: 200)
        
        stickerBtn = InputBarButtonItem()
            .configure {
                $0.image = UIImage(named: "ic_emotion_normal")?.withRenderingMode(.alwaysTemplate)
                $0.tintColor = .darkGray
                $0.setSize(CGSize(width: 30, height: 30), animated: false)
            }.onSelected { [weak self] in
                if let self = self {
                    self.emoticonExtended = !(self.emoticonExtended)
                    
                    $0.image = self.emoticonExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_emotion_normal")?.withRenderingMode(.alwaysTemplate)
                    
                    if self.emoticonExtended {
                        self.resetExtState()
                        self.resetAudioState()
                        
                        self.setInputBoardView(view: emoticonView)
                    } else {
                        self.setInputBoardView(view: nil)
                    }
                }
            }
        
        // MARK: = 功能扩展区域
        var extItems: [BAInputExtItem] = []
        
        var item = BAInputExtItem()
        item.iconImage = UIImage(named: "ic_camera")!
        item.tag = 1
        item.title = "照片"
        item.iconOverlayBackgroundColor = UIColor(red: 42.0/255, green: 43.0/255, blue: 44.0/255, alpha: 1.0)
        extItems.append(item)
        
        item = BAInputExtItem()
        item.iconImage = UIImage(named: "ic_library")!
        item.tag = 1
        item.title = "照片"
        item.iconOverlayBackgroundColor = UIColor(red: 42.0/255, green: 43.0/255, blue: 44.0/255, alpha: 1.0)
        extItems.append(item)
        
        let extView = BAHorizontalPageView.inputExtContainerView(with: extItems, safeAreaSpacing: UIDevice.kBottomSafeHeight) { (item) in
            print(String(item.title)+" Item Tapped")
        }
        
        extBtn = InputBarButtonItem()
        .configure {
            $0.image = UIImage(named: "ic_ext_normal")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .darkGray
            $0.setSize(CGSize(width: 30, height: 30), animated: false)
        }.onSelected { [weak self] in
            
            if let self = self {
                self.extExtended = !self.extExtended
                
                $0.image = self.extExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_ext_normal")?.withRenderingMode(.alwaysTemplate)
                
                if self.extExtended {
                    self.resetStickerState()
                    self.resetAudioState()
                    self.setInputBoardView(view: extView)
                } else {
                    self.setInputBoardView(view: nil)
                }
            }
        }
        
        setStackViewItems([stickerBtn, extBtn], forStack: .right, animated: false)
        setRightStackViewWidthConstant(to: 60, animated: false)
        
        // MARK: = 语音录制
        let bottomRecordView = BAVoiceRecordView()
        bottomRecordView.frame = CGRect(x: 0, y: 0, width: 0, height: 160)
        
        audioBtn = InputBarButtonItem()
        .configure {
            $0.image = UIImage(named: "ic_voice_normal")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .darkGray
            $0.setSize(CGSize(width: 30, height: 30), animated: false)
        }.onSelected { [weak self] in
            
            if let self = self {
                self.voiceExtended = !self.voiceExtended
                
                $0.image = self.voiceExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_voice_normal")?.withRenderingMode(.alwaysTemplate)
                
                if self.voiceExtended {
                    self.resetExtState()
                    self.resetStickerState()
                    
                    self.setInputBoardView(view: bottomRecordView)
                    
                    let delayTime = DispatchTime.now() + Double(Int64(Double(5) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        bottomRecordView.setRecordComplete()
                    }
                } else {
                    self.setInputBoardView(view: nil)
                }
            }
        }
        
        setStackViewItems([audioBtn], forStack: .left, animated: false)
        setLeftStackViewWidthConstant(to: 25, animated: false)
    }
    
    private func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: false)
            }.onSelected {
                $0.tintColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }
    
    // 创建bottom操作面板
    private func resetStickerState () {
        if self.emoticonExtended {
            self.emoticonExtended = false
            stickerBtn.image = self.emoticonExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_emotion_normal")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private func resetExtState () {
        if self.extExtended {
            self.extExtended = false
            extBtn.image = self.extExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_ext_normal")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    private func resetAudioState () {
        if self.voiceExtended {
            self.voiceExtended = false
            
            audioBtn.image = self.voiceExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_voice_normal")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
}

extension WechatInputBar: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        picker.dismiss(animated: true, completion: {
            if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
                self.inputPlugins.forEach { _ = $0.handleInput(of: pickedImage) }
            }
        })
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
