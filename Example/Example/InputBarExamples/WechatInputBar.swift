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
        self.inputTextView.backgroundColor = .red
        self.middleContentViewPadding = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)

        // MARK: = 输入框
        
        // We can change the container insets if we want
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        // MARK: = 表情扩展
        BAStickerConfig.shared.deleteImageNormal = UIImage.init(named: "delete-emoji") ?? UIImage()
        BAStickerConfig.shared.previewImage = UIImage.init(named: "emoji-preview-bg") ?? UIImage()
        BAStickerConfig.shared.toggleEmoji = UIImage.init(named: "toggle_emoji") ?? UIImage()
        BAStickerConfig.shared.toggleKeyboard = UIImage.init(named: "toggle_keyboard") ?? UIImage()
        BAStickerConfig.shared.configFile = "ExampleSticker.plist";
        BAStickerConfig.shared.config()
        
        // 固定表情键盘高度
        let emoticonView = PPStickerKeyboard()
        emoticonView.frame = CGRect(x: 0, y: 0, width: 0, height: 200)
        
        let emoticonItem = InputBarButtonItem()
            .configure {
                $0.image = UIImage(named: "ic_emotion_normal")?.withRenderingMode(.alwaysTemplate)
                $0.tintColor = .darkGray
                $0.setSize(CGSize(width: 30, height: 30), animated: false)
            }.onSelected {
                self.emoticonExtended = !self.emoticonExtended
                
                $0.image = self.emoticonExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_emotion_normal")?.withRenderingMode(.alwaysTemplate)
                
                if self.emoticonExtended {
                    self.setInputBoardView(view: emoticonView)
                } else {
                    self.setInputBoardView(view: nil)
                }
            }
        
        // MARK: = 功能扩展区域
        let items = [
            makeButton(named: "ic_camera").configure({ (item) in
                item.title = "照片"
            }).onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
            }.onSelected {
                    $0.tintColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
            },
            makeButton(named: "ic_library")
                .configure({ (item) in
                    item.title = "照片"
                })
                .onSelected {
                    $0.tintColor = UIColor(red: 15/255, green: 135/255, blue: 255/255, alpha: 1.0)
                    let imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .photoLibrary
                    (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.present(imagePicker, animated: true, completion: nil)
            },
        ]
        items.forEach { $0.tintColor = .lightGray }
        
        let extItem = InputBarButtonItem()
        .configure {
            $0.image = UIImage(named: "ic_ext_normal")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .darkGray
            $0.setSize(CGSize(width: 30, height: 30), animated: false)
        }.onSelected {
            self.extExtended = !self.extExtended
            
            $0.image = self.extExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_ext_normal")?.withRenderingMode(.alwaysTemplate)
            
            if self.extExtended {
                self.setStackViewItems(items, forStack: .bottom, animated: true)
            } else {
                self.setInputBoardView(view: nil)
            }
        }
        
        setStackViewItems([emoticonItem, extItem], forStack: .right, animated: false)
        setRightStackViewWidthConstant(to: 60, animated: false)
        
        // MARK: = 语音录制
        let bottomRecordView = BAVoiceRecordView()
        bottomRecordView.frame = CGRect(x: 0, y: 0, width: 0, height: 160)
        
        let voiceItem = InputBarButtonItem()
        .configure {
            $0.image = UIImage(named: "ic_voice_normal")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .darkGray
            $0.setSize(CGSize(width: 30, height: 30), animated: false)
        }.onSelected {
            self.voiceExtended = !self.voiceExtended
            
            $0.image = self.voiceExtended ? UIImage(named: "ic_keyboard_normal")?.withRenderingMode(.alwaysTemplate) : UIImage(named: "ic_voice_normal")?.withRenderingMode(.alwaysTemplate)
            
            if self.voiceExtended {
                self.setInputBoardView(view: bottomRecordView)
                
                let delayTime = DispatchTime.now() + Double(Int64(Double(5) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime) {
                    bottomRecordView.setRecordComplete()
                }
            } else {
                self.setInputBoardView(view: nil)
            }
        }
        
        setStackViewItems([voiceItem], forStack: .left, animated: false)
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
//    private func makeInputView () -> UIView {
//
//    }
    
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
