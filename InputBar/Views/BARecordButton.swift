
import UIKit


//================================================
// MARK: Usage
//================================================

//BARecordButton.displayMode = .image
//BARecordButton.normalImage = UIImage(named: "record_btn_normal")!
//BARecordButton.highlightImage = UIImage(named: "record_btn_highlight")!
//BARecordButton.missupImage = UIImage(named: "record_btn_missup")!
//
//BARecordButton.displayMode = .overlay

//================================================
// MARK: Delegate
//================================================

/// The delegate protocol of LongPressRecordButton.
@objc public protocol BARecordButtonDelegate {
    /// .inside
    func onPressStart()
    
    /// .none
    func onPressStop()
    
    /// .inside
    func onPressFocus()
    
    /// .outsize
    func onPressMiss()
    
    /// .none
    func onPressCancel()
    
    /// Tells the delegate that a tool tip should be presented when a short press occured.
    @objc optional func longPressRecordButtonShouldShowToolTip() -> Bool
    
    /// Tells the delegate that a short press has occured and therefore a tooltip is shown.
    @objc optional func longPressRecordButtonDidShowToolTip()
}

//================================================
// MARK: RecordButton
//================================================

public enum BARecordButtonState {
    case none // 没有按住
    case inside // 按住了，且在有效区域内
    case outside // 按住了，且不在有效区域内
}

public enum BARecordButtonMode {
    case overlay
    case image
}

/// The LongPressRecordButton class.
@IBDesignable open class BARecordButton : UIControl {
    
    public static var displayMode: BARecordButtonMode = .overlay
    private var recordState: BARecordButtonState = .none
    
    /// The delegate of the LongPressRecordButton instance.
    open weak var delegate : BARecordButtonDelegate?
    
    /// The minmal duration, that the record button is supposed
    /// to stay in the 'selected' state, once the long press has
    /// started.
    @IBInspectable open var minPressDuration : Float = 1.0
    
    /// Determines if the record button is enabled.
    override open var isEnabled: Bool {
        didSet {
            let state : UIControl.State = isEnabled ? UIControl.State() : .disabled
            
            switch BARecordButton.displayMode {
            case .overlay:
                circleLayer.fillColor = circleColorForState(state)?.cgColor
                ringLayer.strokeColor = ringColorForState(state)?.cgColor
            default:
                print("")
            }
        }
    }
    
    // MARK: Image 模式
    
    public static var normalImage: UIImage = UIImage()
    public static var highlightImage: UIImage = UIImage()
    public static var missupImage: UIImage = UIImage()
    
    private var imageView: UIImageView!
    
    // MARK: = Overlay 模式

    @IBInspectable open var ringWidth : CGFloat = 4.0 {
        didSet { redraw() }
    }
    @IBInspectable open var ringColor : UIColor? = UIColor.white {
        didSet { redraw() }
    }
    @IBInspectable open var circleMargin : CGFloat = 0.0 {
        didSet { redraw() }
    }
    @IBInspectable open var circleColor : UIColor? = UIColor.red {
        didSet { redraw() }
    }
    
    // MARK: = 提示框
    
    /// The text that the tooltip is supposed to display,
    /// if the user did short-press the button.
    open lazy var toolTipText : String = {
        return "Tap and Hold"
    }()
    
    /// The font of the tooltip text.
    open var toolTipFont : UIFont = {
        return UIFont.systemFont(ofSize: 12.0)
    }()
    
    /// The background color of the tooltip.
    open var toolTipColor : UIColor = {
        return UIColor.white
    }()
    
    /// The text color of the tooltip.
    open var toolTipTextColor : UIColor = {
        return UIColor(white: 0.0, alpha: 0.8)
    }()
    
    // MARK: Initializers
    
    /// Initializer
    override init (frame : CGRect) {
        super.init(frame : frame)
        commonInit()
    }
    
    /// Initializer
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    /// Initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    // MARK: Private
    
    fileprivate var longPressRecognizer : UILongPressGestureRecognizer!
    fileprivate var touchesStarted : CFTimeInterval?
    fileprivate var touchesEnded : Bool = false
    fileprivate var shouldShowTooltip : Bool = true
    
    fileprivate var ringLayer : CAShapeLayer!
    fileprivate var circleLayer : CAShapeLayer!
    
    fileprivate var outerRect : CGRect {
        return CGRect(x: ringWidth/2, y: ringWidth/2, width: bounds.size.width-ringWidth, height: bounds.size.height-ringWidth)
    }
    
    fileprivate var innerRect : CGRect {
        let innerX = outerRect.origin.x + (ringWidth/2) + circleMargin
        let innerY = outerRect.origin.y + (ringWidth/2) + circleMargin
        let innerWidth = outerRect.size.width - ringWidth - (circleMargin * 2)
        let innerHeight = outerRect.size.height - ringWidth - (circleMargin * 2)
        return CGRect(x: innerX, y: innerY, width: innerWidth, height: innerHeight)
    }
    
    fileprivate func commonInit() {
        backgroundColor = UIColor.clear
        
        recordState = .none
        
        switch BARecordButton.displayMode {
        case .overlay:
            ringLayer = CAShapeLayer()
            ringLayer.fillColor = UIColor.clear.cgColor
            ringLayer.frame = bounds
            layer.addSublayer(ringLayer)
            
            circleLayer = CAShapeLayer()
            circleLayer.frame = bounds
            layer.addSublayer(circleLayer)
            
            redraw()
        default:
            imageView = UIImageView(image: BARecordButton.normalImage)
            
            addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                NSLayoutConstraint.init(item: imageView!, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: imageView!, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: imageView!, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
                NSLayoutConstraint.init(item: imageView!, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0),
            ])
        }
        
        // 手势处理，初始化
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(BARecordButton.handleLongPress(_:)))
        longPressRecognizer.cancelsTouchesInView = false
        longPressRecognizer.minimumPressDuration = 0.3
        self.addGestureRecognizer(longPressRecognizer)
        
//        addTarget(self, action: #selector(BARecordButton.handleShortPress(_:)), for: UIControl.Event.touchUpInside)
    }
    
    fileprivate func redraw() {
        switch BARecordButton.displayMode {
        case .overlay:
            ringLayer.lineWidth = ringWidth
            ringLayer.strokeColor = ringColor?.cgColor
            ringLayer.path = UIBezierPath(ovalIn: outerRect).cgPath
            ringLayer.setNeedsDisplay()
            
            circleLayer.fillColor = circleColor?.cgColor
            circleLayer.path = UIBezierPath(ovalIn: innerRect).cgPath
            circleLayer.setNeedsDisplay()
        default:
            print("")
        }
        
    }
    
    /// Sublayer layouting
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        switch BARecordButton.displayMode {
        case .overlay:
            ringLayer.frame = bounds
            circleLayer.frame = bounds
            redraw()
        default:
            print("")
        }
        
        
    }
    
    @objc fileprivate func handleLongPressMoved(_ recognizer: UILongPressGestureRecognizer) {
        
    }
    
    @objc fileprivate func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        if (recognizer.state == .began) {
            buttonPressed()
        } else if (recognizer.state == .ended) {
            buttonReleased()
        } else if (recognizer.state == .changed) {
            let point = recognizer.location(ofTouch: 0, in: self)

            if point.x < 0 || point.x > self.frame.width || point.y < 0 || point.y > self.frame.height {
                buttonMissed(true)
            } else {
                buttonMissed(false)
            }
        }
    }
    
//    @objc fileprivate func handleShortPress(_ sender: AnyObject?) {
//        if shouldShowTooltip {
//            if isTooltipVisible() == false {
//                if let delegate = delegate , delegate.longPressRecordButtonShouldShowToolTip?() == false {
//                    return
//                }
//                let tooltip = ToolTip(title: toolTipText, foregroundColor: toolTipTextColor, backgroundColor: toolTipColor, font: toolTipFont, recordButton: self)
//                tooltip.show()
//                delegate?.longPressRecordButtonDidShowToolTip?()
//            }
//        }
//        shouldShowTooltip = true
//    }
    
//    fileprivate func isTooltipVisible() -> Bool {
//        return layer.sublayers?.filter({ $0.isKind(of: ToolTip.self) }).first != nil
//    }
    
    public func buttonForceStop() {
        recordState = .none
        
        switch BARecordButton.displayMode {
        case .overlay:
            circleLayer.fillColor = circleColor?.cgColor
        default:
            changeImage()
        }
    }

    fileprivate func buttonPressed() {
        if touchesStarted == nil {
            
            recordState = .inside
            
            switch BARecordButton.displayMode {
            case .overlay:
                circleLayer.fillColor = circleColor?.darkerColor().cgColor
                setNeedsDisplay()
            default:
                changeImage()
            }
            
            touchesStarted = CACurrentMediaTime()
            touchesEnded = false
            shouldShowTooltip = false
            
            let delayTime = DispatchTime.now() + Double(Int64(Double(minPressDuration) * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime) { [weak self] in
                if let strongSelf = self {
                    if strongSelf.touchesEnded { strongSelf.buttonReleased() }
                }
            }
            
            delegate?.onPressStart()
        }
    }
    
    fileprivate func buttonReleased() {
        if let touchesStarted = touchesStarted , (CACurrentMediaTime() - touchesStarted) >= Double(minPressDuration) {
            self.touchesStarted = nil
            
            if recordState == .outside {
                delegate?.onPressCancel()
            } else {
                delegate?.onPressStop()
            }
            
            recordState = .none
            
            switch BARecordButton.displayMode {
            case .overlay:
                circleLayer.fillColor = circleColor?.cgColor
            default:
                changeImage()
            }
        } else {
            touchesEnded = true
        }
    }
    
    fileprivate func buttonMissed(_ indeed: Bool) {
        if (recordState == .inside || recordState == .outside) {
            recordState = indeed ? .outside : .inside
            
            if (recordState == .outside) {
                delegate?.onPressMiss()
            } else {
                delegate?.onPressFocus()
            }
            
            switch BARecordButton.displayMode {
            case .image:
                changeImage()
            default: break
            }
        }
    }
    
    fileprivate func changeImage() {
        UIView.transition(with: imageView, duration: 0.2, options: .transitionCrossDissolve, animations: {
            switch self.recordState {
            case .none:
                self.imageView.image = BARecordButton.normalImage
            case .inside:
                self.imageView.image = BARecordButton.highlightImage
            case .outside:
                self.imageView.image = BARecordButton.missupImage
            }
        }, completion: nil)
    }
    
    fileprivate func ringColorForState(_ state : UIControl.State) -> UIColor? {
        switch state {
        case UIControl.State(): return ringColor
        case UIControl.State.highlighted: return ringColor
        case UIControl.State.disabled: return ringColor?.withAlphaComponent(0.5)
        case UIControl.State.selected: return ringColor
        default: return nil
        }
    }
    
    fileprivate func circleColorForState(_ state: UIControl.State) -> UIColor? {
        switch state {
        case UIControl.State(): return circleColor
        case UIControl.State.highlighted: return circleColor?.darkerColor()
        case UIControl.State.disabled: return circleColor?.withAlphaComponent(0.5)
        case UIControl.State.selected: return circleColor?.darkerColor()
        default: return nil
        }
    }
    
    /// @IBDesignable support
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        backgroundColor = UIColor.clear
    }
}

//================================================
// MARK: Extensions
//================================================

private extension NSAttributedString {
    func sizeToFit(_ maxSize: CGSize) -> CGSize {
        return boundingRect(with: maxSize, options:(NSStringDrawingOptions.usesLineFragmentOrigin), context:nil).size
    }
}

private extension Int {
    var radians : CGFloat {
        return CGFloat(self) * CGFloat(Double.pi) / 180.0
    }
}

private extension UIColor {
    func darkerColor() -> UIColor {
        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a){
            return UIColor(red: max(r - 0.2, 0.0), green: max(g - 0.2, 0.0), blue: max(b - 0.2, 0.0), alpha: a)
        }
        return UIColor()
    }
}
