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
            arrSubvalues.append(["title":"相册选图:image<=1,push","operation":"NXAsset-image-1"])
            arrSubvalues.append(["title":"相册选图:image<=9,present","operation":"NXAsset-image-9"])
            arrSubvalues.append(["title":"相册选图:video<=1,overlay","operation":"NXAsset-video-1"])
            arrSubvalues.append(["title":"相册选图:video<=9,push","operation":"NXAsset-video-9"])
            arrSubvalues.append(["title":"相册选图:混合<=12,image<12&&video<=12,present","operation":"NXAsset-12-1"])
            arrSubvalues.append(["title":"相册选图:混合<=12,image<6&&video<=6,overlay","operation":"NXAsset-12-2"])
            self.arrValues.append(arrSubvalues)
        }
        
        if true {
            var arrSubvalues = [[String:Any]]()
            arrSubvalues.append(["title":"打开相机:拍图","operation":"camera-image"])
            arrSubvalues.append(["title":"打开相机:拍视频","operation":"camera-video"])
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
                else if operation == "NXAsset-image-1" {
                    NXAsset.album(open:{ action, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 1
                        value.wrapped.image.minOfAssets = 1
                        value.wrapped.image.maxOfAssets = 1
                        value.wrapped.video.minOfAssets = 0
                        value.wrapped.video.maxOfAssets = 0
                        value.wrapped.isMixable = false
                        value.wrapped.mediaType = .image
                        value.wrapped.subviews = (true, false, false)
                        value.wrapped.clips = [NXClip(name: "1:1", isResizable: false, width: 1, height: 1, isHidden: false)]
                        value.wrapped.numberOfColumns = 4
                        self.navigationController?.pushViewController(value, animated: true)
                    }, completion: { action, value in
                        NX.print("count:\(value.assets.count)")
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else if operation == "NXAsset-image-9" {
                    NXAsset.album(open:{ action, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 9
                        value.wrapped.image.minOfAssets = 1
                        value.wrapped.image.maxOfAssets = 9
                        value.wrapped.video.minOfAssets = 0
                        value.wrapped.video.maxOfAssets = 0
                        value.wrapped.isMixable = false
                        value.wrapped.mediaType = .image
                        //self.navigationController?.pushViewController(value, animated: true)
                        value.wrapped.subviews = (true, false, false)
                        self.present(value, animated: true, completion: nil)
                    }, completion: { action, value in
                        NX.print("count:\(value.assets.count)")
                        self.dismiss(animated: true, completion: nil)
                        //self.navigationController?.popViewController(animated: true)
                    })
                }
                else if operation == "NXAsset-video-1" {
                    NXAsset.album(open:{ action, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 1
                        value.wrapped.image.minOfAssets = 0
                        value.wrapped.image.maxOfAssets = 0
                        value.wrapped.video.minOfAssets = 1
                        value.wrapped.video.maxOfAssets = 1
                        value.wrapped.isMixable = false
                        value.wrapped.mediaType = .video
                        value.wrapped.clips = [NXClip(name: "1:1", isResizable: false, width: 1, height: 1, isHidden: false)]
                        value.ctxs.orientation = .bottom
                        (self.navigationController as? NXNavigationController)?.openViewController(value, animated: true)
                    }, completion: { action, value in
                        NX.print("count:\(value.assets.count)")
                        (self.navigationController as? NXNavigationController)?.closeViewController(value.contentViewController!, animated: true)

                    })
                }
                else if operation == "NXAsset-video-9" {
                    NXAsset.album(open:{ action, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 9
                        value.wrapped.image.minOfAssets = 0
                        value.wrapped.image.maxOfAssets = 0
                        value.wrapped.video.minOfAssets = 1
                        value.wrapped.video.maxOfAssets = 9
                        value.wrapped.isMixable = false
                        value.wrapped.mediaType = .video
                        self.navigationController?.pushViewController(value, animated: true)
                    }, completion: { action, value in
                        NX.print("count:\(value.assets.count)")
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else if operation == "NXAsset-12-1" {
                    NXAsset.album(open:{ action, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 12
                        value.wrapped.image.minOfAssets = 1
                        value.wrapped.image.maxOfAssets = 12
                        value.wrapped.video.minOfAssets = 1
                        value.wrapped.video.maxOfAssets = 12
                        value.wrapped.isMixable = true
                        value.wrapped.mediaType = .unknown
                        self.present(value, animated: true, completion: nil)
                    }, completion: { action, value in
                        NX.print("count:\(value.assets.count)")
                        self.dismiss(animated: true, completion: nil)
                    })
                }
                else if operation == "NXAsset-12-2" {
                    NXAsset.album(open:{ action, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 12
                        value.wrapped.image.minOfAssets = 1
                        value.wrapped.image.maxOfAssets = 6
                        value.wrapped.video.minOfAssets = 1
                        value.wrapped.video.maxOfAssets = 6
                        value.wrapped.isMixable = true
                        value.wrapped.mediaType = .unknown
                        value.ctxs.orientation = .bottom
                        (self.navigationController as? NXNavigationController)?.openViewController(value, animated: true)
                    }, completion: { action, value in
                        NX.print("count:\(value.assets.count)")
                        (self.navigationController as? NXNavigationController)?.closeViewController(value.contentViewController!, animated: true)
                    })
                }
                else if operation == "camera-image"{
                    NXAsset.camera(open: { action, value in
                        self.navigationController?.pushViewController(value, animated: true)
                    }, completion: { action, value in
                        NX.print("count:\(value.assets.count)")
                        self.navigationController?.popViewController(animated: true)
                    })
                }
                else if operation == "camera-video"{
                    NXAsset.camera(open: { action, value in
                        self.present(value, animated: true, completion: nil)
                    }, completion: { action, value in
                        NX.print("count:\(value.assets.count)")
                        self.dismiss(animated: true, completion: nil)
                    })
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
                    NXActionView.action(actions: [NXAction(title: "北京", value: nil, completion: nil), NXAction(title: "上海", value: nil, completion: nil)], header: .none, footer: .none, completion: nil)
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
                    NXActionView.action(actions: actions, header: .none, footer: .footer(true, false, true, "取消"), completion: nil)
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
                    NXActionView.action(actions: actions, header: .header(true, false, true, true, "请选择城市"), footer: .footer(true, false, true, "取消"), completion: nil)
                }
            }
        }
    }
}

