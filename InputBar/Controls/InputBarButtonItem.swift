//
//  InputBarButtonItem.swift
//  InputBarAccessoryView
//
//  Copyright © 2017-2020 Nathan Tannar.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Created by Nathan Tannar on 8/18/17.
//

import UIKit

open class InputBarButtonItem: UIButton, InputItem {
    
    /// The spacing properties of the InputBarButtonItem
    ///
    /// - fixed: The spacing is fixed
    /// - flexible: The spacing is flexible
    /// - none: There is no spacing
    public enum Spacing {
        case fixed(CGFloat)
        case flexible
        case none
    }
    
    public typealias InputBarButtonItemAction = ((InputBarButtonItem) -> Void)
    
    // MARK: - Properties
    
    /// A weak reference to the InputBarAccessoryView that the InputBarButtonItem used in
    open weak var inputBarAccessoryView: InputBarAccessoryView?
    
    /// The spacing property of the InputBarButtonItem that determines the contentHuggingPriority and any
    /// additional space to the intrinsicContentSize
    open var spacing: Spacing = .none {
        didSet {
            switch spacing {
            case .flexible:
                setContentHuggingPriority(UILayoutPriority(rawValue: 1), for: .horizontal)
            case .fixed:
                setContentHuggingPriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
            case .none:
                setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
            }
        }
    }
    
    /// When not nil this size overrides the intrinsicContentSize
    private var size: CGSize? = CGSize(width: 20, height: 20) {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        var contentSize = size ?? super.intrinsicContentSize
        switch spacing {
        case .fixed(let width):
            contentSize.width += width
        case .flexible, .none:
            break
        }
        return contentSize
    }
    
    /// A reference to the stack view position that the InputBarButtonItem is held in
    open var parentStackViewPosition: InputBarAccessoryView.StackItemPosition?
    
    /// The title for the UIControlState.normal
    open var title: String? {
        get {
            return title(for: .normal)
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
    /// The image for the UIControlState.normal
    open var image: UIImage? {
        get {
            return image(for: .normal)
        }
        set {
            setImage(newValue, for: .normal)
        }
    }
    
    /// Calls the onSelectedAction or onDeselectedAction when set
    open override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            guard newValue != isHighlighted else { return }
            super.isHighlighted = newValue
            if newValue {
                onSelectedAction?(self)
            } else {
                onDeselectedAction?(self)
            }

        }
    }

    /// Calls the onEnabledAction or onDisabledAction when set
    open override var isEnabled: Bool {
        didSet {
            if isEnabled {
                onEnabledAction?(self)
            } else {
                onDisabledAction?(self)
            }
        }
    }
    
    // MARK: - Reactive Hooks
    
    private var onTouchUpInsideAction: InputBarButtonItemAction?
    private var onKeyboardEditingBeginsAction: InputBarButtonItemAction?
    private var onKeyboardEditingEndsAction: InputBarButtonItemAction?
    private var onKeyboardSwipeGestureAction: ((InputBarButtonItem, UISwipeGestureRecognizer) -> Void)?
    private var onTextViewDidChangeAction: ((InputBarButtonItem, InputTextView) -> Void)?
    private var onSelectedAction: InputBarButtonItemAction?
    private var onDeselectedAction: InputBarButtonItemAction?
    private var onEnabledAction: InputBarButtonItemAction?
    private var onDisabledAction: InputBarButtonItemAction?
    
    // MARK: - Initialization
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    /// Sets up the default properties
    open func setup() {
        contentVerticalAlignment = .center
        contentHorizontalAlignment = .center
        
        imageView?.contentMode = .scaleAspectFit
        setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .vertical)
        setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), for: .normal)
        setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.3), for: .highlighted)
        setTitleColor(.lightGray, for: .disabled)
        adjustsImageWhenHighlighted = false
        addTarget(self, action: #selector(InputBarButtonItem.touchUpInsideAction), for: .touchUpInside)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        arrangeImageTitle()
    }
    
    func arrangeImageTitle () {
        // 有title的时候，设置图片在上，title在下，水平中间对齐
        if let _ = title, let _ = image {
            imagePosition(style: .top, spacing: 10)
        }
    }
    
    // MARK: - Size Adjustment
    
    /// Sets the size of the InputBarButtonItem which overrides the intrinsicContentSize. When set to nil
    /// the default intrinsicContentSize is used. The new size will be laid out in the UIStackView that
    /// the InputBarButtonItem is held in
    ///
    /// - Parameters:
    ///   - newValue: The new size
    ///   - animated: If the layout should be animated
    open func setSize(_ newValue: CGSize?, animated: Bool) {
        size = newValue
        if animated, let position = parentStackViewPosition {
            inputBarAccessoryView?.performLayout(animated) { [weak self] in
                self?.inputBarAccessoryView?.layoutStackViews([position])
            }
        }
    }
    
    // MARK: - Hook Setup Methods
    
    /// Used to setup your own initial properties
    ///
    /// - Parameter item: A reference to Self
    /// - Returns: Self
    @discardableResult
    open func configure(_ item: InputBarButtonItemAction) -> Self {
        item(self)
        return self
    }
    
    /// Sets the onKeyboardEditingBeginsAction
    ///
    /// - Parameter action: The new onKeyboardEditingBeginsAction
    /// - Returns: Self
    @discardableResult
    open func onKeyboardEditingBegins(_ action: @escaping InputBarButtonItemAction) -> Self {
        onKeyboardEditingBeginsAction = action
        return self
    }
    
    /// Sets the onKeyboardEditingEndsAction
    ///
    /// - Parameter action: The new onKeyboardEditingEndsAction
    /// - Returns: Self
    @discardableResult
    open func onKeyboardEditingEnds(_ action: @escaping InputBarButtonItemAction) -> Self {
        onKeyboardEditingEndsAction = action
        return self
    }
    
    
    /// Sets the onKeyboardSwipeGestureAction
    ///
    /// - Parameter action: The new onKeyboardSwipeGestureAction
    /// - Returns: Self
    @discardableResult
    open func onKeyboardSwipeGesture(_ action: @escaping (_ item: InputBarButtonItem, _ gesture: UISwipeGestureRecognizer) -> Void) -> Self {
        onKeyboardSwipeGestureAction = action
        return self
    }
    
    /// Sets the onTextViewDidChangeAction
    ///
    /// - Parameter action: The new onTextViewDidChangeAction
    /// - Returns: Self
    @discardableResult
    open func onTextViewDidChange(_ action: @escaping (_ item: InputBarButtonItem, _ textView: InputTextView) -> Void) -> Self {
        onTextViewDidChangeAction = action
        return self
    }
    
    /// Sets the onTouchUpInsideAction
    ///
    /// - Parameter action: The new onTouchUpInsideAction
    /// - Returns: Self
    @discardableResult
    open func onTouchUpInside(_ action: @escaping InputBarButtonItemAction) -> Self {
        onTouchUpInsideAction = action
        return self
    }
    
    /// Sets the onSelectedAction
    @discardableResult
    open func onSelected(_ action: @escaping InputBarButtonItemAction) -> Self {
        onSelectedAction = action
        return self
    }
    
    /// Sets the onDeselectedAction
    ///
    /// - Parameter action: The new onDeselectedAction
    /// - Returns: Self
    @discardableResult
    open func onDeselected(_ action: @escaping InputBarButtonItemAction) -> Self {
        onDeselectedAction = action
        return self
    }
    
    /// Sets the onEnabledAction
    ///
    /// - Parameter action: The new onEnabledAction
    /// - Returns: Self
    @discardableResult
    open func onEnabled(_ action: @escaping InputBarButtonItemAction) -> Self {
        onEnabledAction = action
        return self
    }
    
    /// Sets the onDisabledAction
    ///
    /// - Parameter action: The new onDisabledAction
    /// - Returns: Self
    @discardableResult
    open func onDisabled(_ action: @escaping InputBarButtonItemAction) -> Self {
        onDisabledAction = action
        return self
    }
    
    // MARK: - InputItem Protocol
    
    /// Executes the onTextViewDidChangeAction with the given textView
    ///
    /// - Parameter textView: A reference to the InputTextView
    open func textViewDidChangeAction(with textView: InputTextView) {
        onTextViewDidChangeAction?(self, textView)
    }
    
    /// Executes the onKeyboardSwipeGestureAction with the given gesture
    ///
    /// - Parameter gesture: A reference to the gesture that was recognized
    open func keyboardSwipeGestureAction(with gesture: UISwipeGestureRecognizer) {
        onKeyboardSwipeGestureAction?(self, gesture)
    }
    
    /// Executes the onKeyboardEditingEndsAction
    open func keyboardEditingEndsAction() {
        onKeyboardEditingEndsAction?(self)
    }
    
    /// Executes the onKeyboardEditingBeginsAction
    open func keyboardEditingBeginsAction() {
        onKeyboardEditingBeginsAction?(self)
    }
    
    /// Executes the onTouchUpInsideAction
    @objc
    open func touchUpInsideAction() {
        onTouchUpInsideAction?(self)
    }
    
    // MARK: - Static Spacers
    
    /// An InputBarButtonItem that's spacing property is set to be .flexible
    public static var flexibleSpace: InputBarButtonItem {
        let item = InputBarButtonItem()
        item.setSize(.zero, animated: false)
        item.spacing = .flexible
        return item
    }
    
    /// An InputBarButtonItem that's spacing property is set to be .fixed with the width arguement
    public static func fixedSpace(_ width: CGFloat) -> InputBarButtonItem {
        let item = InputBarButtonItem()
        item.setSize(.zero, animated: false)
        item.spacing = .fixed(width)
        return item
    }
    
    // MARK: - UIButton Extention

    enum BAButtonImagePosition {
            case top          //图片在上，文字在下，垂直居中对齐
            case bottom       //图片在下，文字在上，垂直居中对齐
            case left         //图片在左，文字在右，水平居中对齐
            case right        //图片在右，文字在左，水平居中对齐
    }

    
    /// - Description 设置Button图片的位置
    /// - Parameters:
    ///   - style: 图片位置
    ///   - spacing: 按钮图片与文字之间的间隔
    func imagePosition(style: BAButtonImagePosition, spacing: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-spacing/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-spacing/2, right: 0)
            break;
            
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -spacing/2, bottom: 0, right: spacing)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: spacing/2, bottom: 0, right: -spacing/2)
            break;
            
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-spacing/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-spacing/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
            
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+spacing/2, bottom: 0, right: -labelWidth-spacing/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-spacing/2, bottom: 0, right: imageWidth!+spacing/2)
            break;
            
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
}
