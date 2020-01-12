//
//  DropBoxTextField.swift
//  DropBoxDemo
//
//  Created by Xujiale on 2020/1/12.
//  Copyright © 2020 xujiale. All rights reserved.
//

/**
 * 一个简单的下拉文本框，将下拉框和文本框结合
 */

import Foundation
import UIKit

class DropBoxTextField: UIView {
    
    fileprivate var textField: UITextField!
    fileprivate var dropBoxView: DropBoxView!
    
    init(textField: UITextField, delegate: DropBoxDelegate) {
        super.init(frame: textField.frame)
        
        self.textField = textField
        self.textField.frame = CGRect(x: 0, y: 0, width: textField.frame.width, height: textField.frame.height)
        let icon = UIButton(frame: CGRect(x: 0, y: 0, width: 21, height: 12.5))
        icon.setImage(UIImage(named: "drop_down"), for: .normal)
        icon.addTarget(self, action: #selector(drop), for: .touchUpInside)
        self.textField.rightView = icon
        self.textField.rightViewMode = .always
        self.addSubview(self.textField)
        
        self.dropBoxView = DropBoxView(frame: CGRect(x: 0, y: textField.frame.maxY, width: textField.frame.width, height: 0), delegate: delegate)
        self.addSubview(dropBoxView)
        
    }
    
    @objc func drop() {
        if(dropBoxView.isDrop) {
            dropBoxView.drawUp()
            UIView.animate(withDuration: 0.5, animations: {
                self.frame.size.height = self.textField.frame.height
            })
        } else {
            dropBoxView.dropDwon()
            UIView.animate(withDuration: 0.5, animations: {
                self.frame.size.height = self.dropBoxView.showHeight + self.textField.frame.height
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
