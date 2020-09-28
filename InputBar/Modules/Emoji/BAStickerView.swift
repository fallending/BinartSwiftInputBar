//
//  BAStickerView.swift
//  BinartSwiftInputBar
//
//  Created by Seven on 2020/8/24.
//

import Foundation
import BinartOCStickerKeyboard

struct PPStickerKeyboardKey {
    static var inputBarAccessoryViewKey: Bool = false
    static var parentStackViewPosition: Bool = false
}

extension PPStickerKeyboard: InputItem {
    // MARK: - InputItem Protocol
        
    open weak var inputBarAccessoryView: InputBarAccessoryView? {
        get {
            return objc_getAssociatedObject(self, &PPStickerKeyboardKey.inputBarAccessoryViewKey) as?InputBarAccessoryView
        }
        
        set {
            objc_setAssociatedObject(self, &PPStickerKeyboardKey.inputBarAccessoryViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
        
    open var parentStackViewPosition: InputBarAccessoryView.StackItemPosition? {
        get {
            return objc_getAssociatedObject(self, &PPStickerKeyboardKey.parentStackViewPosition) as?InputBarAccessoryView.StackItemPosition
        }
        set {
            objc_setAssociatedObject(self, &PPStickerKeyboardKey.parentStackViewPosition, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Executes the onTextViewDidChangeAction with the given textView
    ///
    /// - Parameter textView: A reference to the InputTextView
    open func textViewDidChangeAction(with textView: InputTextView) {
//        onTextViewDidChangeAction?(self, textView)
    }

    /// Executes the onKeyboardSwipeGestureAction with the given gesture
    ///
    /// - Parameter gesture: A reference to the gesture that was recognized
    open func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
//        onKeyboardSwipeGestureAction?(self, gesture)
    }

    /// Executes the onKeyboardEditingEndsAction
    open func keyboardEditingEndsAction() {
//        onKeyboardEditingEndsAction?(self)
    }

    /// Executes the onKeyboardEditingBeginsAction
    open func keyboardEditingBeginsAction() {
//        onKeyboardEditingBeginsAction?(self)
    }
}
