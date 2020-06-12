//
//  ViewController.swift
//  DropBoxDemo
//
//  Created by Xujiale on 2020/1/12.
//  Copyright © 2020 xujiale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var titles: [(String, UIImage?)] = [
        ("第一个 item", UIImage(named: "user")),
        ("第二个 item", UIImage(named: "user")),
        ("第三个 item", UIImage(named: "user"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFirst()
        setupSecond()
    }
    
    /// 示例一
    private func setupFirst() {
        let label = UILabel(frame: CGRect(x: 10, y: 50, width: 200, height: 30))
        label.text = "自动回收,不带图标 :"
        label.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(label)
        
        let bounds = view.bounds;
        let width = bounds.width - 20;
        
        let mTextField = UITextField()
        mTextField.placeholder = "Type Something..."
        let textField = DropBoxTextField(frame: CGRect(x: 10, y: 90, width: width, height: 44), customTextField: mTextField)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        /// 设置选项内容
        textField.count = titles.count
        textField.itemForRowAt = { [weak self] (index) -> (String, UIImage?) in
            guard let title = self?.titles[index].0 else {
                return ("", nil)
            }
            return (title, nil);
        }
        textField.didSelectedAt = { (index, title, textField) in
            print("选中第 \(index) 行，标题 \(title)")
            textField.drawUp()
        }
        view.addSubview(textField)
    }
    
    /// 示例二
    private func setupSecond() {
        let label = UILabel(frame: CGRect(x: 10, y: 150, width: 200, height: 30))
        label.text = "不自动回收,带图标 :"
        label.font = UIFont.systemFont(ofSize: 13)
        view.addSubview(label)
        
        let bounds = view.bounds;
        let width = bounds.width - 20;
        
        let mTextField = UITextField()
        mTextField.placeholder = "Type Something..."
        let textField = DropBoxTextField(frame: CGRect(x: 10, y: 190, width: width, height: 44), customTextField: mTextField)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        /// 设置选项内容
        textField.count = titles.count
        textField.itemForRowAt = { [weak self] (index) -> (String, UIImage?) in
            guard let title = self?.titles[index].0, let img = self?.titles[index].1 else {
                return ("", nil)
            }
            return (title, img)
        }
        textField.didSelectedAt = { (index, title, textField) in
            print("选中第 \(index) 行，标题 \(title)")
        }
        view.addSubview(textField)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        /// 点击空白处回收键盘
        view.endEditing(false);
    }
}

