//
//  NXTableViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/8/22.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXTableViewController: NXViewController, UITableViewDelegate, UITableViewDataSource {
    // 表视图
    open var tableView = NXTableView(frame: CGRect.zero, style: .grouped)
    // 数据源管理对象
    public let data = NXCollection<NXTableView>()

    override open func viewDidLoad() {
        super.viewDidLoad()

        // 默认情况下不开启：通常在接口数据返回后把该标识为true
        data.placeholderView.ctxs.isHidden = true

        // tableView
        tableView.frame = contentView.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.backgroundColor = NXKit.viewBackgroundColor
        tableView.separatorColor = NXKit.separatorColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: contentView.width, height: 24)
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
        contentView.addSubview(tableView)

        tableView.data = data
        data.wrappedView = tableView
    }

    // 分组个数
    open func numberOfSections(in _: UITableView) -> Int {
        return data.count
    }

    // 各组单元格个数
    open func tableView(_: UITableView, numberOfRowsInSection index: Int) -> Int {
        if let section = data[index] {
            return section.count
        }
        return 0
    }

    // 分组的头部：高度和视图
    open func tableView(_: UITableView, heightForHeaderInSection index: Int) -> CGFloat {
        if index == 0 && data.showsFirstSectionHeader == false {
            return 0.0
        }
        return data.heightForHeader(at: index)
    }

    open func tableView(_ tableView: UITableView, viewForHeaderInSection index: Int) -> UIView? {
        if index == 0 && data.showsFirstSectionHeader == false {
            return nil
        }

        if let rs = data.dequeue(tableView, index, NXItem.View.header.rawValue) {
            rs.reusableView.updateSubviews(rs.element)
            return rs.reusableView
        } else {
            if let header = data[index]?.header {
                if let cls = header.reuse.cls as? NXTableReusableView.Type {
                    let reusableView = cls.init(reuseIdentifier: header.reuse.id)
                    reusableView.updateSubviews(header)
                    return reusableView
                } else if let cls = header.reuse.cls as? UIView.Type {
                    return cls.init()
                }
            }
        }
        return nil
    }

    // 中间的单元格：高度和视图
    open func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data.heightForRow(at: indexPath)
    }

    open func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let rs = data.dequeue(tableView, indexPath) {
            rs.cell.updateSubviews(rs.element)
            return rs.cell
        }
        return NXTableViewCell()
    }

    // 分组的尾部：高度和视图
    open func tableView(_: UITableView, heightForFooterInSection index: Int) -> CGFloat {
        if index == data.count - 1 && data.showsLastSectionFooter == false {
            return 0.0
        }
        return data.heightForFooter(at: index)
    }

    open func tableView(_ tableView: UITableView, viewForFooterInSection index: Int) -> UIView? {
        if index == data.count - 1 && data.showsLastSectionFooter == false {
            return nil
        }

        if let rs = data.dequeue(tableView, index, NXItem.View.footer.rawValue) {
            rs.reusableView.updateSubviews(rs.element)
            return rs.reusableView
        } else {
            if let footer = data[index]?.footer {
                if let cls = footer.reuse.cls as? NXTableReusableView.Type {
                    let reusableView = cls.init(reuseIdentifier: footer.reuse.id)
                    reusableView.updateSubviews(footer)
                    return reusableView
                } else if let cls = footer.reuse.cls as? UIView.Type {
                    return cls.init()
                }
            }
        }
        return nil
    }

    // 点击事件
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
