//
//  EXViewController.swift
//  NXKit
//
//  Created by niegaotao on 09/18/2021.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit
import NXKit

class EXViewController: NXTableViewController {
    var arrValues = [[[String:Any]]]()
    
    override func setup() {
        super.setup()
        
        if true {
            var arrSubvalues = [[String:Any]]()
            arrSubvalues.append(["title":"NXViewController","operation":"NXViewController"])
            arrSubvalues.append(["title":"NXTableViewController","operation":"NXTableViewController"])
            arrSubvalues.append(["title":"NXCollectionViewController","operation":"NXCollectionViewController"])
            self.arrValues.append(arrSubvalues)
        }
        
        if true {
            var arrSubvalues = [[String:Any]]()
            arrSubvalues.append(["title":"NXActionView-alert(1个选项)","operation":"NXActionView-alert-1"])
            arrSubvalues.append(["title":"NXActionView-alert(2个选项)","operation":"NXActionView-alert-2"])
            arrSubvalues.append(["title":"NXActionView-alert(>=3个选项)","operation":"NXActionView-alert-3"])

            arrSubvalues.append(["title":"NXActionView-action(无头部，无尾部)","operation":"NXActionView-action"])
            arrSubvalues.append(["title":"NXActionView-action(无头部，有尾部)","operation":"NXActionView-action-footer"])
            arrSubvalues.append(["title":"NXActionView-action(有头部，有尾部)","operation":"NXActionView-action--header-footer"])

            self.arrValues.append(arrSubvalues)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviView.title = "NXViewController"
        
<<<<<<< HEAD
        self.setupSubviews()
        self.updateSubviews("", nil)
    }
    
    override func setupSubviews() {
        self.tableView?.register(NXApplicationViewCell.self, forCellReuseIdentifier: "NXApplicationViewCell")
    }
    
    override func updateSubviews(_ action: String, _ value: Any?) {
        self.tableWrapper.removeAll()
        
        for arrSubvalues in self.arrValues {
            let section = self.tableWrapper.addSection(cls: NXTableReusableView.self, reuse: "NXTableReusableView", height: 10)
            for dicValue in arrSubvalues {
                let item = NXAction(value: dicValue)
                item.ctxs.update(NXApplicationViewCell.self, "NXApplicationViewCell");
                item.ctxs.size = CGSize(width: NXUI.width, height: 56)
                
                item.asset.isHidden = true
                
                item.title.isHidden = false
                item.title.value = NX.get(string: dicValue["title"] as? String)
                item.title.frame = CGRect(x: 15, y: 0, width: NXUI.width-30, height: item.ctxs.height)
                
                item.subtitle.isHidden = true
                
                item.value.isHidden = true
                
                item.arrow.isHidden = false
                item.arrow.frame = CGRect(x: NXUI.width-15-6, y: (item.ctxs.height - 12)/2.0, width: 6, height: 12)
                item.arrow.image = NX.image(named: "icon-arrow.png")

                item.appearance.separator.ats = .maxY
                item.appearance.separator.insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                section.append(item)
            }
        }
        
        self.tableView?.updateSubviews("", nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let item = self.tableWrapper[indexPath] as? NXAction {
            if let operation = item.ctxs.value?["operation"] as? String, operation.count > 0 {
                if operation == "NXViewController" {
                    let vc = NXViewController()
                    vc.title = operation
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if operation == "NXTableViewController" {
                    let vc = NXTableViewController()
                    vc.title = operation
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if operation == "NXCollectionViewController" {
                    let vc = NXCollectionViewController()
                    vc.title = operation
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else if operation == "NXActionView-alert-1" {
                    NXActionView.alert(title: "温馨提示", subtitle: "确认删除该记录吗？删除后不可恢复哦", actions: ["我再想想"], completion: nil)
                }
                else if operation == "NXActionView-alert-2" {
                    NXActionView.alert(title: "温馨提示", subtitle: "确认删除该记录吗？删除后不可恢复哦", actions: ["删除","我再想想"], completion: nil)
                }
                else if operation == "NXActionView-alert-3" {
                    NXActionView.alert(title: "温馨提示", subtitle: "确认删除该记录吗？删除后不可恢复哦", actions: ["删除","我再想想","稍后再说","好的"], completion: nil)
                }
                else if operation == "NXActionView-action" {
                    NXActionView.action(actions: [NXAction(title: "北京", value: nil, completion: nil),NXAction(title: "上海", value: nil, completion: nil)], header: .none, footer: .none, initialize: nil, completion: nil)
                }
                else if operation == "NXActionView-action-footer" {
                    var actions = [NXAction]()
                    actions.append(NXAction(title: "北京", value: nil, completion: nil))
                    actions.append(NXAction(title: "上海", value: nil, completion: nil))
                    actions.append(NXAction(title: "广州", value: nil, completion: nil))
                    actions.append(NXAction(title: "深圳", value: nil, completion: nil))
                    actions.append(NXAction(title: "成都", value: nil, completion: nil))
                    actions.append(NXAction(title: "重庆", value: nil, completion: nil))
                    actions.append(NXAction(title: "武汉", value: nil, completion: nil))
                    NXActionView.action(actions: actions, header: .none, footer: .footer(true, false, true, "取消"), initialize: nil, completion: nil)
                }
                else if operation == "NXActionView-action--header-footer" {
                    var actions = [NXAction]()
                    actions.append(NXAction(title: "北京", value: nil, completion: nil))
                    actions.append(NXAction(title: "上海", value: nil, completion: nil))
                    actions.append(NXAction(title: "广州", value: nil, completion: nil))
                    actions.append(NXAction(title: "深圳", value: nil, completion: nil))
                    actions.append(NXAction(title: "成都", value: nil, completion: nil))
                    actions.append(NXAction(title: "重庆", value: nil, completion: nil))
                    actions.append(NXAction(title: "武汉", value: nil, completion: nil))
                    actions.append(NXAction(title: "杭州", value: nil, completion: nil))
                    actions.append(NXAction(title: "西安", value: nil, completion: nil))
                    actions.append(NXAction(title: "长沙", value: nil, completion: nil))
                    actions.append(NXAction(title: "郑州", value: nil, completion: nil))
                    actions.append(NXAction(title: "合肥", value: nil, completion: nil))
                    NXActionView.action(actions: actions, header: .header(true, false, true, true, "请选择城市"), footer: .footer(true, false, true, "取消"), initialize: nil, completion: nil)
                }
            }
        }
    }
}

