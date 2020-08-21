//
//  BAVoiceRecordView.swift
//  BinartSwiftInputBar
//
//  Created by Seven on 2020/8/17.
//

import Foundation
import BinartOCPlotView
import BinartOCLayout

// MARK: - 事件协议

public protocol BAVoiceRecordViewDelegate {
    /// .inside
    func onPressStart()
    
    /// .none
    func onPressStop()
    
    /// .outsize
    func onPressCancel()
}

// MARK: - 语音录制视图

open class BAVoiceRecordView: UIView, InputItem {
    // 按钮
    private var recordBtn: BARecordButton!
    
    // 左右声浪
    private var leftWaveView: BABarAudioPlot!
    private var rightWaveView: BABarAudioPlot!
    
    // 中间提示语
    // 按住说话
    // 上滑取消
    // 10'结束将自动发送
    // 释放取消
    private var tipLabel: UILabel!
    
    public var delegate: BAVoiceRecordViewDelegate?
    
    // MARK: = 初始化
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDefault()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefault() {
        kBAPlotEnableMockMode = true // 模拟音频发生器，也可以接入真是音频，但是需要依赖AudioBox框架，暂不考虑
    
        self.backgroundColor = .clear

        // 按钮完全居中
        BARecordButton.displayMode = .image
        
        recordBtn = BARecordButton()
        recordBtn.delegate = self
        
        addSubview(recordBtn)
        recordBtn.whc_CenterX(0)?.whc_CenterY(10)
            .whc_Width(96)
            .whc_Height(96);
        
        
        // 声浪在按钮和top的中间，高度为 27
        leftWaveView = BABarAudioPlot()
        leftWaveView.padding = 0.2
        leftWaveView.backgroundColor = UIColor.clear
        
        
        addSubview(leftWaveView)
        leftWaveView.whc_Width(50)?.whc_Height(36)?.whc_TopSpace(-20)?.whc_CenterX(-80)
        
        rightWaveView = BABarAudioPlot()
        rightWaveView.padding = leftWaveView.padding
        rightWaveView.backgroundColor = UIColor.clear
        addSubview(rightWaveView)
        rightWaveView.whc_Width(50)?.whc_Height(36)?.whc_TopSpace(-20)?.whc_CenterX(80)
        
        // 提示语覆盖在声浪上，且居中
        tipLabel = UILabel()
        tipLabel.text = "按住开始说话"
//        tipLabel.text = "10\"结束将自动发送"
        tipLabel.font = .systemFont(ofSize: 12)
        tipLabel.textColor = .lightGray
        tipLabel.textAlignment = .center
        tipLabel.backgroundColor = .clear
        
        addSubview(tipLabel)
        tipLabel.whc_CenterX(0)?.whc_Height(36)?.whc_TopSpace(-20).whc_Width(120)
    }
    
    
    // MARK: = 控制
    
    public func setTipProgress(value: Int32) {
        tipLabel.text = "\(value)\"结束将自动发送"
    }
    
    /// 由于外部提供时钟，需要提供主动关闭操作
    public func setRecordComplete() {
        recordBtn.buttonForceStop()
        
        tipLabel.text = "按住开始说话"
    }
    
    // MARK: - InputItem Protocol
    
    open weak var inputBarAccessoryView: InputBarAccessoryView?
    
    open var parentStackViewPosition: InputBarAccessoryView.StackItemPosition?
    
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

// MARK: - 实现录音按钮的协议

extension BAVoiceRecordView: BARecordButtonDelegate {
    
    public func onPressStart() {
        tipLabel.text = "上滑取消"
        
        delegate?.onPressStart()
    }
    
    public func onPressStop() {
        tipLabel.text = "按住开始说话"
        
        delegate?.onPressStop()
    }
    
    public func onPressCancel() {
        tipLabel.text = "按住开始说话"
        
        delegate?.onPressCancel()
    }
    
    public func onPressFocus() {
        tipLabel.text = "上滑取消"
    }
    
    public func onPressMiss() {
        tipLabel.text = "释放取消"
    }
}

