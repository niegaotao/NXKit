//
//  NXTableViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/22.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit


open class NXTableViewController: NXViewController, UITableViewDelegate, UITableViewDataSource {
    //表视图样式
    open var tableViewStyle = NXUI.tableViewStyle
    
    //表视图
    open var tableView: NXTableView? = nil
    //数据源管理对象
    public let data = NXCollection<NXTableView>()
    
    override open func setup() {
        super.setup()
        self.ctxs.index = 1 //用以记录分页加载的索引（从1开始）
        self.ctxs.next = 1 //记录下一页的索引
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //默认情况下不开启：通常在接口数据返回后把该标识为true
        self.data.placeholderView.ctxs.isHidden = true

        //tableView
        self.tableView = NXTableView(frame: self.contentView.bounds, style: self.tableViewStyle)
        self.tableView?.frame = self.contentView.bounds
        self.tableView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView?.backgroundColor = NXUI.tableViewBackgroundColor
        self.tableView?.separatorColor = NXUI.separatorColor
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = NXUI.separatorStyle
        self.tableView?.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.contentView.w, height: 24)
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
        }
        self.contentView.addSubview(self.tableView!)

        tableView?.data = self.data
        self.data.wrappedView = tableView
        
        self.contentView.bringSubviewToFront(self.animationView)
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
        
        if let rs = self.data.dequeue(tableView, index, NXCollectionDequeue.header.rawValue) {
            rs.reusableView.updateSubviews("update", rs.element)
            return rs.reusableView
        }
        else {
            if let header = self.data[index]?.header {
                if let cls = header.ctxs.cls as? NXTableReusableView.Type {
                    let reusableView = cls.init(reuseIdentifier:header.ctxs.reuse)
                    reusableView.updateSubviews("update", header)
                    return reusableView
                }
                else if let cls = header.ctxs.cls as? UIView.Type {
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
            rs.cell.updateSubviews("update", rs.element)
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
        
        if let rs = self.data.dequeue(tableView, index, NXCollectionDequeue.footer.rawValue) {
            rs.reusableView.updateSubviews("update", rs.element)
            return rs.reusableView
        }
        else {
            if let footer = self.data[index]?.footer {
                if let cls = footer.ctxs.cls as? NXTableReusableView.Type {
                    let reusableView = cls.init(reuseIdentifier:footer.ctxs.reuse)
                    reusableView.updateSubviews("update", footer)
                    return reusableView
                }
                else if let cls = footer.ctxs.cls as? UIView.Type {
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
