//
//  ViewController.swift
//  DropBoxDemo
//
//  Created by Xujiale on 2020/1/12.
//  Copyright © 2020 xujiale. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DropBoxDelegate {
    
    var strs: [String] = ["第一个item", "第二个item", "第三个item", "第四个item","第五个item","第六个item","第七个item"]
    
    @IBOutlet weak var textField: UITextField!  // 从StoryBoard拖拽的文本框
    var textField2: UITextField!    // 代码创建的文本框
    var dropBoxMenu: DropBoxView!   // 下拉菜单

    // MARK: 直接在 Controller 实现 DropBoxDelegate 代理
    
    func count() -> Int {
        return strs.count
    }
    
    func setItem(_ forItem: Int) -> [String: Any?] {
        return ["text": strs[forItem], "img": UIImage(named: "user")]
    }
    
    func didSelectItemAt(_ forItem: Int) {
        textField.text = strs[forItem]
    }
    
    func heightForItem(_ forItem: Int) -> CGFloat {
        return 40
    }
    
    // MARK: 样式
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 下拉文本框1
        textField.placeholder = "通过storyboard拖拽的TextField"
        let dropBoxTextField = DropBoxTextField(textField: textField, delegate: self)
        self.view.addSubview(dropBoxTextField)
        
        // 下拉文本框2，可以自定义一些样式
        textField2 = UITextField(frame: CGRect(x: 80, y: 150, width: 250, height: 35))
        textField2.placeholder = "这是代码创建的TextField"
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: textField2.frame.height - borderWidth,
                              width:  textField2.frame.width,
                              height: textField2.frame.height)
        border.borderWidth = borderWidth
        textField2.layer.addSublayer(border)
        textField2.layer.masksToBounds = true
        // 这里为简单，使用同一个delegate，下面的菜单同理
        let dropBoxTextField2 = DropBoxTextField(textField: textField2, delegate: self)
        self.view.addSubview(dropBoxTextField2)
        
        // 下拉菜单
        setMenu()
    }
    
    func setMenu() {
        let rightTop = CGRect(x: self.view.frame.width - 205,
                              y: (self.navigationController?.navigationBar.frame.height)! + 50,
                              width: 200, height: 0)
        dropBoxMenu = DropBoxView(frame: rightTop, delegate: self)
        self.view.addSubview(dropBoxMenu)
    }
    
    // 菜单 button 点击展开/收起
    @IBAction func dropMenu(_ sender: Any) {
        if(dropBoxMenu.isDrop) {
            dropBoxMenu.drawUp()
        } else {
            dropBoxMenu.dropDwon()
        }
    }
    
}
