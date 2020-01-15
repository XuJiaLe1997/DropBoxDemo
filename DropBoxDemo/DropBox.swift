//
//  DropBoxView.swift
//  bookshop
//
//  Created by Xujiale on 2020/1/12.
//  Copyright © 2020 xujiale. All rights reserved.
//

import Foundation
import UIKit

/**
 * 下拉框，可以做成下拉文本框，也可以和bar button结合做下拉菜单
 */

// 使用者需要实现这个代理，以便定制自己的下拉框行为
protocol DropBoxDelegate: NSObjectProtocol {
    // 个数
    func count() -> Int
    // 选项内容
    func setItem(_ forItem: Int) -> [String: Any?]
    // 选中
    func didSelectItemAt(_ forItem: Int)
    // 高度
    func heightForItem(_ forItem: Int) -> CGFloat
}

class DropBoxView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var maxHeight: CGFloat!     // 最大显示的高度
    var showHeight: CGFloat = 0             // 当前显示的高度
    var isDrop: Bool = false                // 是否处于下拉状态
    
    var dropBoxDelegate: DropBoxDelegate!
    
    init(frame: CGRect, maxHeight: CGFloat = 200, delegate: DropBoxDelegate) {
        super.init(frame: CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: 0), style: .grouped)
        self.delegate = self
        self.dataSource = self
        self.maxHeight = maxHeight
        self.dropBoxDelegate = delegate
        
        initHelper()
    }
    
    // MARK: 样式
    
    func initHelper() {
        self.separatorStyle = .none
        self.backgroundColor = .clear // 透明背景
        
        self.register(SimpleDropBoxCell.classForCoder(), forCellReuseIdentifier: "dropBoxCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dropBoxDelegate.count()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // MARK: 设置section之间的间隔
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1    // 注意不能为0，否则设置无效
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: 单元格样式，重写这个方法可以定制自己的下拉框卡片
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "dropBoxCell", for: indexPath) as? SimpleDropBoxCell
        let text = dropBoxDelegate.setItem(indexPath.section)["text"] as! String
        let img = dropBoxDelegate.setItem(indexPath.section)["img"] as! UIImage
        cell?.setImg(img: img)
        cell?.setLabel(text: text)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dropBoxDelegate.heightForItem(indexPath.section)
    }
    
    // MARK: 展开下拉框
    func dropDwon() {
        if(isDrop) {
            return
        }
        isDrop = true
        
        UIView.animate(withDuration: 0.5, animations: {
            let h = self.caculateContentHeight()
            if( h > self.maxHeight) {   // 不允许无限展开，需要在最大高度范围内
                self.isScrollEnabled = true
                self.frame.size.height = self.maxHeight
                self.showHeight = self.maxHeight
            } else {
                self.isScrollEnabled = false
                self.frame.size.height = h
                self.showHeight = h
            }
        })
    }
    
    // 计算实际内容高度，本例为 (item高度 + header高度 + footer高度) * item个数
    func caculateContentHeight() -> CGFloat {
        let itemHeight = dropBoxDelegate.heightForItem(0)
        let itemCount = CGFloat(dropBoxDelegate.count())
        return  (itemHeight + 1 + 1) * itemCount
    }
    
    // MARK: 收起下拉框
    func drawUp() {
        if(!isDrop) {
            return
        }
        isDrop = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.frame.size.height = 0.0
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropBoxDelegate.didSelectItemAt(indexPath.section)
    }
    
}

// 简单的下拉文本框单元格
class SimpleDropBoxCell: UITableViewCell {
    
    var imgView: UIImageView!
    var label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 设置圆角和边界
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.3
        
        // 选中后右边显示一个绿色的“勾选”符号
        let selectedView = UIImageView(image: UIImage(named: "check"))
        selectedView.contentMode = .right
        selectedBackgroundView = selectedView
        
        // 左边图片
        imgView = UIImageView(frame: CGRect(x: 10, y: 7, width: 25, height: 25))
        imgView.layer.masksToBounds = true
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.contentMode = .scaleToFill
        self.addSubview(imgView)
        
        // 文字部分
        label = UILabel(frame: CGRect(x: 50, y: 5, width: self.frame.width - 80, height: 30))
        label.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(label)
    }
    
    func setImg(img: UIImage) {
        self.imgView.image = img
    }
    
    func setLabel(text: String) {
        label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
