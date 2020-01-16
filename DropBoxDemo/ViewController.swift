//
//  ViewController.swift
//  DropBoxDemo
//
//  Created by Xujiale on 2020/1/12.
//  Copyright © 2020 xujiale. All rights reserved.
//

/**
 * 下拉框使用样例，糅合了三个使用样例，请仔细区分
 */


import UIKit

class ViewController: UIViewController, DropBoxDelegate {
    
    var strs: [String] = ["第一个item", "第二个item", "第三个item"]
    
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
        setTextField1()
        setTextField2()
        setMenu()
    }
    
    // MARK: 下拉文本框1样例
    
    func setTextField1() {
        textField.placeholder = "通过storyboard拖拽的TextField"
        let dropBoxTextField = DropBoxTextField(textField: textField, delegate: self)
        self.view.addSubview(dropBoxTextField)
    }
    
    // MARK: 下拉文本框2样例
    
    func setTextField2() {
        textField2 = UITextField(frame: CGRect(x: 80, y: 300, width: 250, height: 35))
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
        
        let items = [["text":"第一个item", "img": UIImage(named: "user")],
                     ["text":"第二个item", "img": UIImage(named: "user")],
                     ["text":"第三个item", "img": UIImage(named: "user")],
                     ["text":"第四个item", "img": UIImage(named: "user")],
                     ["text":"第五个item", "img": UIImage(named: "user")],
                     ["text":"第六个item", "img": UIImage(named: "user")],
                     ["text":"第七个item", "img": UIImage(named: "user")]]
        let delegate = DropBoxDelegateImpl(items, { forItem in
            // 选中值赋给文本框
            self.textField2.text = items[forItem]["text"] as? String
        })
        
        let dropBoxTextField2 = DropBoxTextField(textField: textField2, delegate: delegate)
        self.view.addSubview(dropBoxTextField2)
    }
    
    // MARK: 下拉菜单样例
    
    func setMenu() {
        let items = [["text":"刷新", "img": UIImage(named: "reflesh")],
                     ["text":"分享", "img": UIImage(named: "share")],
                     ["text":"浏览器打开", "img": UIImage(named: "broswer")]
        ]
        let delegate = DropBoxDelegateImpl(items, { forItem in
            // TODO 本例没有添加菜单的点击事件
        })
        
        let rightTop = CGRect(x: self.view.frame.width - 155,
                              y: (self.navigationController?.navigationBar.frame.height)! + 50,
                              width: 150, height: 0)
        dropBoxMenu = DropBoxMenu(frame: rightTop, delegate: delegate)
        self.view.addSubview(dropBoxMenu)
    }
    
    @IBAction func dropMenu(_ sender: Any) {
        if(dropBoxMenu.isDrop) {
            dropBoxMenu.drawUp()
        } else {
            dropBoxMenu.dropDwon()
        }
    }
    
}

// MARK: 不直接在 Controller 实现 DropBoxDelegate，将其委托给其它实现类
class DropBoxDelegateImpl : NSObject, DropBoxDelegate{
    
    var items: [[String : Any?]]!
    var didSelect: (Int) -> Void
    var height: CGFloat
    
    init(_ items: [[String : Any?]], _ didSelect: @escaping (Int) -> Void, height: CGFloat = 40) {
        self.items = items
        self.didSelect = didSelect
        self.height = height
    }
    
    func count() -> Int {
        return items.count
    }
    
    func setItem(_ forItem: Int) -> [String : Any?] {
        return items[forItem]
    }
    
    func didSelectItemAt(_ forItem: Int) {
        didSelect(forItem)
    }
    
    func heightForItem(_ forItem: Int) -> CGFloat {
        return height
    }
    
}
