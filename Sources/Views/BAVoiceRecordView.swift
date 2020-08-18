//
//  BAVoiceRecordView.swift
//  BinartSwiftInputBar
//
//  Created by Seven on 2020/8/17.
//

import Foundation

public class BAVoiceRecordView: UIView {
    
    // 按钮
    private var recordBtn: UIButton!
    
    // 左右声浪
    private var waveView: UIView!
    
    // 中间提示语
    // 按住说话
    // 上滑取消
    // 10'结束将自动发送
    // 释放取消
    private var tipLabel: UILabel!
    
    // MARK: = 初始化
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDefault()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDefault() {
        self.backgroundColor = .clear

        // 按钮完全居中
        
        
        // 声浪在按钮和top的中间，高度为 27
        
        
        // 提示语覆盖在声浪上，且居中
    }
    
    
    // MARK: = 控制
    
    
}
