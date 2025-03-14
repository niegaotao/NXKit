//
//  NXTableViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/22.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit


open class NXTableViewController: NXViewController, UITableViewDelegate, UITableViewDataSource {
    //表视图
    open var tableView = NXTableView(frame: CGRect.zero, style: .grouped)
    //数据源管理对象
    public let data = NXCollection<NXTableView>()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //默认情况下不开启：通常在接口数据返回后把该标识为true
        self.data.placeholderView.ctxs.isHidden = true

        //tableView
        self.tableView.frame = self.contentView.bounds
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.backgroundColor = NXKit.viewBackgroundColor
        self.tableView.separatorColor = NXKit.separatorColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: 24)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        self.contentView.addSubview(self.tableView)

        tableView.data = self.data
        self.data.wrappedView = tableView
    }
    
    
    //分组个数
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    //各组单元格个数
    open func tableView(_ tableView: UITableView, numberOfRowsInSection index: Int) -> Int {
        if let section = self.data[index] {
            return section.count
        }
        return 0
    }
    
    //分组的头部：高度和视图
    open func tableView(_ tableView: UITableView, heightForHeaderInSection index: Int) -> CGFloat {
        if index == 0 && self.data.showsFirstSectionHeader == false {
            return 0.0
        }
        return self.data.heightForHeader(at: index)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection index: Int) -> UIView? {
        if index == 0 && self.data.showsFirstSectionHeader == false {
            return nil
        }
        
        if let rs = self.data.dequeue(tableView, index, NXItem.View.header.rawValue) {
            rs.reusableView.updateSubviews(rs.element)
            return rs.reusableView
        }
        else {
            if let header = self.data[index]?.header {
                if let cls = header.reuse.cls as? NXTableReusableView.Type {
                    let reusableView = cls.init(reuseIdentifier:header.reuse.id)
                    reusableView.updateSubviews(header)
                    return reusableView
                }
                else if let cls = header.reuse.cls as? UIView.Type {
                    return cls.init()
                }
            }
        }
        return nil
    }
    
    //中间的单元格：高度和视图
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.data.heightForRow(at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let rs = self.data.dequeue(self.tableView, indexPath) {
            rs.cell.updateSubviews(rs.element)
            return rs.cell
        }
        return NXTableViewCell()
    }
    
    
    //分组的尾部：高度和视图
    open func tableView(_ tableView: UITableView, heightForFooterInSection index: Int) -> CGFloat {
        if index == self.data.count-1 && self.data.showsLastSectionFooter == false {
            return 0.0
        }
        return self.data.heightForFooter(at: index)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection index: Int) -> UIView? {
        if index == self.data.count-1 && self.data.showsLastSectionFooter == false {
            return nil
        }
        
        if let rs = self.data.dequeue(tableView, index, NXItem.View.footer.rawValue) {
            rs.reusableView.updateSubviews(rs.element)
            return rs.reusableView
        }
        else {
            if let footer = self.data[index]?.footer {
                if let cls = footer.reuse.cls as? NXTableReusableView.Type {
                    let reusableView = cls.init(reuseIdentifier:footer.reuse.id)
                    reusableView.updateSubviews(footer)
                    return reusableView
                }
                else if let cls = footer.reuse.cls as? UIView.Type {
                    return cls.init()
                }
            }
        }
        return nil
    }
    
    
    //点击事件
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
