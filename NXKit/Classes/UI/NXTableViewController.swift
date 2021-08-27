//
//  NXTableViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/22.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit


open class NXTableViewController: NXViewController, UITableViewDelegate, UITableViewDataSource {
    //表视图
    open var tableView: NXTableView? = nil
    //数据源管理对象
    public let tableWrapper = NXTableWrapper()
    
    override open func setup() {
        super.setup()
        self.ctxs.index = 1 //用以记录分页加载的索引（从1开始）
        self.ctxs.next = 1 //记录下一页的索引
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        //默认情况下不开启：通常在接口数据返回后把该标识为true
        self.tableWrapper.placeholderView.wrapped.isHidden = true

        //tableView
        self.tableView = NXTableView(frame: self.contentView.bounds, style: tableWrapper.tableViewStyle)
        self.tableView?.frame = self.contentView.bounds
        self.tableView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView?.backgroundColor = NX.tableViewBackgroundColor
        self.tableView?.separatorColor = NX.separatorColor
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = NX.Association.separatorStyle
        self.tableView?.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.contentView.w, height: 24)
        if #available(iOS 11.0, *) {
            self.tableView?.contentInsetAdjustmentBehavior = .never
        }
        self.contentView.addSubview(self.tableView!)

        tableView?.tableWrapper = self.tableWrapper
        self.tableWrapper.tableView = tableView
        if let __animationsView = self.animationView {
            self.contentView.bringSubviewToFront(__animationsView)
        }
    }
    
    
    //分组个数
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableWrapper.count
    }
    
    //各组单元格个数
    open func tableView(_ tableView: UITableView, numberOfRowsInSection index: Int) -> Int {
        if let section = self.tableWrapper[index] {
            return section.count
        }
        return 0
    }
    
    //分组的头部：高度和视图
    open func tableView(_ tableView: UITableView, heightForHeaderInSection index: Int) -> CGFloat {
        if index == 0 && self.tableWrapper.showsFirstSectionHeader == false {
            return 0.0
        }
        return self.tableWrapper.heightForHeader(at: index)
    }
    
    open func tableView(_ tableView: UITableView, viewForHeaderInSection index: Int) -> UIView? {
        if index == 0 && self.tableWrapper.showsFirstSectionHeader == false {
            return nil
        }
        
        if let rs = self.tableWrapper.dequeue(tableView, index, NXCollection.Dequeue.header.rawValue) {
            rs.reusableView.updateSubviews("update", rs.element)
            return rs.reusableView
        }
        else {
            if let header = self.tableWrapper[index]?.header {
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
        return self.tableWrapper.heightForRow(at: indexPath)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let rs = self.tableWrapper.dequeue(self.tableView, indexPath) {
            rs.cell.updateSubviews("update", rs.element)
            return rs.cell
        }
        return NXTableViewCell()
    }
    
    
    //分组的尾部：高度和视图
    open func tableView(_ tableView: UITableView, heightForFooterInSection index: Int) -> CGFloat {
        if index == self.tableWrapper.count-1 && self.tableWrapper.showsLastSectionFooter == false {
            return 0.0
        }
        return self.tableWrapper.heightForFooter(at: index)
    }
    
    open func tableView(_ tableView: UITableView, viewForFooterInSection index: Int) -> UIView? {
        if index == self.tableWrapper.count-1 && self.tableWrapper.showsLastSectionFooter == false {
            return nil
        }
        
        if let rs = self.tableWrapper.dequeue(tableView, index, NXCollection.Dequeue.footer.rawValue) {
            rs.reusableView.updateSubviews("update", rs.element)
            return rs.reusableView
        }
        else {
            if let footer = self.tableWrapper[index]?.footer {
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
