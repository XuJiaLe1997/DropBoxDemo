//
//  DropBoxMenu.swift
//  bookshop
//
//  Created by Xujiale on 2020/1/15.
//  Copyright © 2020 xujiale. All rights reserved.
//

import Foundation
import UIKit

/**
 * 简单的下拉菜单实现
 */

class DropBoxMenu: DropBoxView {
    
    override func initHelper() {
        separatorStyle = .none
        layer.cornerRadius = 5
        backgroundColor = .white
        layer.borderWidth = 0.1
        layer.borderColor = UIColor.lightGray.cgColor
        
        register(MenuCell.classForCoder(), forCellReuseIdentifier: "menuCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dropBoxDelegate.count()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as? MenuCell
        cell?.setImg(img: dropBoxDelegate.setItem(indexPath.row).img)
        cell?.setLabel(text: dropBoxDelegate.setItem(indexPath.row).text)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dropBoxDelegate.heightForItem(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dropBoxDelegate.didSelectItemAt(indexPath.row)
        self.drawUp()
    }
    
    // 计算实际内容高度，本例为 item个数 * item高度 + header高度 + footer高度
    override func caculateContentHeight() -> CGFloat {
        return CGFloat(dropBoxDelegate.count()) * dropBoxDelegate.heightForItem(0) + 1 + 1
    }
    
}

class MenuCell: UITableViewCell {
    
    var imgView: UIImageView!
    var label: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        imgView = UIImageView(frame: CGRect(x: 15, y: 10, width: 20, height: 20))
        imgView.contentMode = .scaleToFill
        addSubview(imgView)
        
        label = UILabel(frame: CGRect(x: 50, y: 5, width: self.frame.width - 50, height: 30))
        label.font = UIFont.systemFont(ofSize: 15)
        addSubview(label)
    }
    
    func setImg(img: UIImage) {
        imgView.image = img
    }
    
    func setLabel(text: String) {
        label.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
