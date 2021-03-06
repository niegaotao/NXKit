//
//  NXTableWrapper.swift
//  NXKit
//
//  Created by firelonely on 2018/10/7.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

open class NXTableWrapper : NXCollection {
    //表视图样式
    open var tableViewStyle = NXApp.Table.tableViewStyle
    //视图
    open weak var tableView : NXTableView?
    //是否展示第一个section的头部
    open var showsFirstSectionHeader = false
    //是否显示最后一个section的尾部
    open var showsLastSectionFooter = false
    //计算相对位置关系:默认不计算
    open var calcAt = false

    
    open func heightForHeader(at index: Int) -> CGFloat {
        if let header = self[index]?.header {
            
            //1.根据自身的高度赋值拿到header的高度
            if header.ctxs.h > 0 {
                return header.ctxs.h
            }
        }
        return 0.0
    }
    
    
    open func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if let element = self[indexPath] {
            
            //1.根据自己对高度的赋值拿到相应的高度
            if element.ctxs.h > 0 {
                return element.ctxs.h
            }
            
            //2.根据FD中的自适应返回单元格的高度
            if let height = NXApp.heightForRow(self.tableView, element, indexPath), height > 0 {
                return height
            }
        }
        
        return 0.0
    }
    
    
    open func heightForFooter(at index: Int) -> CGFloat {
        if let footer = self[index]?.footer {
            //1.根据自身的高度赋值拿到header的高度
            if footer.ctxs.h > 0 {
                return footer.ctxs.h
            }
        }
        return 0.0
    }
    
    public let placeholderView = NXPlaceholderView()
    open func addPlaceholderView(_ frame: CGRect){
        let e = NXPlaceholderView.Element()
        e.placeholderView = self.placeholderView
        e.ctxs.update(NXPlaceholderView.TableViewCell.self, "NXPlaceholderViewCell")
        e.ctxs.frame = frame
        self.addElementToLastSection(e)
        self.tableView?.register(NXPlaceholderView.TableViewCell.self, forCellReuseIdentifier: "NXPlaceholderViewCell")
    }
}

