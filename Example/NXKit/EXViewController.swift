//
//  EXViewController.swift
//  NXKit
//
//  Created by niegaotao on 09/18/2021.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import NXKit
import UIKit

class EXViewController: NXTableViewController {
    var arrValues = [[[String: Any]]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationView.title = "NXViewController"

        // 布局视图
        setupSubviews()
        // 请求数据
        startAnimating()
        request("", nil) { _, value in
            self.stopAnimating()
            if let value = value as? [[[String: Any]]] {
                self.arrValues = value
                // 刷新UI
                self.updateSubviews(nil)
            }
        }
    }

    // 布局视图
    override func setupSubviews() {
        tableView.register(NXAbstractViewCell.self, forCellReuseIdentifier: "NXAbstractViewCell")
    }

    // 请求数据
    override func request(_ operation: String, _: Any?, _ completion: NXKit.Event<String, Any?>? = nil) {
        NXKit.log("request")
        // 模拟在子线程异步请求
        DispatchQueue.global().asyncAfter(delay: 2) {
            var arrValues = [[[String: Any]]]()
            if true {
                var arrSubvalues = [[String: Any]]()
                arrSubvalues.append(["title": "NXViewController", "operation": "NXViewController"])
                arrSubvalues.append(["title": "NXTableViewController", "operation": "NXTableViewController"])
                arrSubvalues.append(["title": "NXCollectionViewController", "operation": "NXCollectionViewController"])
                arrSubvalues.append(["title": "EXToolViewController", "operation": "EXToolViewController"])
                arrValues.append(arrSubvalues)
            }

            if true {
                var arrSubvalues = [[String: Any]]()
                arrSubvalues.append(["title": "相册选图:image<=1,push", "operation": "NXAsset-image-1"])
                arrSubvalues.append(["title": "相册选图:image<=9,present", "operation": "NXAsset-image-9"])
                arrSubvalues.append(["title": "相册选图:video<=1,overlay", "operation": "NXAsset-video-1"])
                arrSubvalues.append(["title": "相册选图:video<=9,push", "operation": "NXAsset-video-9"])
                arrSubvalues.append(["title": "相册选图:混合<=12,image<12&&video<=12,present", "operation": "NXAsset-12-1"])
                arrSubvalues.append(["title": "相册选图:混合<=12,image<6&&video<=6,overlay", "operation": "NXAsset-12-2"])
                arrValues.append(arrSubvalues)
            }

            if true {
                var arrSubvalues = [[String: Any]]()
                arrSubvalues.append(["title": "打开相机:拍图", "operation": "camera-image"])
                arrSubvalues.append(["title": "打开相机:拍视频", "operation": "camera-video"])
                arrValues.append(arrSubvalues)
            }

            if true {
                var arrSubvalues = [[String: Any]]()
                arrSubvalues.append(["title": "NXActionView-alert(1个选项)", "operation": "NXActionView-alert-1"])
                arrSubvalues.append(["title": "NXActionView-alert(2个选项)", "operation": "NXActionView-alert-2"])
                arrSubvalues.append(["title": "NXActionView-alert(>=3个选项)", "operation": "NXActionView-alert-3"])

                arrSubvalues.append(["title": "NXActionView-action(无头部，无尾部)", "operation": "NXActionView-action"])
                arrSubvalues.append(["title": "NXActionView-action(无头部，有尾部)", "operation": "NXActionView-action-footer"])
                arrSubvalues.append(["title": "NXActionView-action(有头部，有尾部)", "operation": "NXActionView-action--header-footer"])

                arrValues.append(arrSubvalues)
            }

            // 请求回来后回调
            DispatchQueue.main.async {
                completion?(operation, arrValues)
            }
        }
    }

    // 刷新UI
    override func updateSubviews(_: Any?) {
        data.removeAll()

        for arrSubvalues in arrValues {
            let section = data.addSection(cls: NXTableReusableView.self, reuse: "NXTableReusableView", height: 10)
            for dicValue in arrSubvalues {
                let item = NXAbstract(value: dicValue, completion: nil)
                item.ctxs.update(NXAbstractViewCell.self, "NXAbstractViewCell")
                item.ctxs.size = CGSize(width: NXKit.width, height: 56)

                item.asset.isHidden = true

                item.title.isHidden = false
                item.title.value = NXKit.get(string: dicValue["title"] as? String)
                item.title.frame = CGRect(x: 15, y: 0, width: NXKit.width - 30, height: item.ctxs.height)

                item.subtitle.isHidden = true

                item.value.isHidden = true

                item.arrow.isHidden = false
                item.arrow.frame = CGRect(x: NXKit.width - 15 - 6, y: (item.ctxs.height - 12) / 2.0, width: 6, height: 12)
                item.arrow.image = NXKit.image(named: "icon-arrow.png")

                item.raw.separator.ats = .maxY
                item.raw.separator.insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
                section.append(item)
            }
        }

        tableView.updateSubviews("", nil)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let item = data[indexPath] as? NXAbstract {
            if let operation = item.ctxs.value?["operation"] as? String, operation.count > 0 {
                if operation == "NXViewController" {
                    let vc = NXViewController()
                    vc.title = operation
                    navigationController?.pushViewController(vc, animated: true)
                } else if operation == "NXTableViewController" {
                    let vc = NXTableViewController()
                    vc.title = operation
                    navigationController?.pushViewController(vc, animated: true)
                } else if operation == "NXCollectionViewController" {
                    let vc = NXCollectionViewController()
                    vc.title = operation
                    navigationController?.pushViewController(vc, animated: true)
                } else if operation == "EXToolViewController" {
                    let vc = EXToolViewController()
                    navigationController?.pushViewController(vc, animated: true)
                } else if operation == "NXAsset-image-1" {
                    NXAsset.album(open: { _, value in
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
                    }, completion: { _, value in
                        NXKit.print("count:\(value.assets.count)")
                        self.navigationController?.popViewController(animated: true)
                    })
                } else if operation == "NXAsset-image-9" {
                    NXAsset.album(open: { _, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 9
                        value.wrapped.image.minOfAssets = 1
                        value.wrapped.image.maxOfAssets = 9
                        value.wrapped.video.minOfAssets = 0
                        value.wrapped.video.maxOfAssets = 0
                        value.wrapped.isMixable = false
                        value.wrapped.mediaType = .image
                        value.wrapped.subviews = (true, false, false)
                        self.present(value, animated: true, completion: nil)
                    }, completion: { _, value in
                        NXKit.print("count:\(value.assets.count)")
                        self.dismiss(animated: true, completion: nil)
                    })
                } else if operation == "NXAsset-video-1" {
                    NXAsset.album(open: { _, value in
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
                    }, completion: { _, value in
                        NXKit.print("count:\(value.assets.count)")
                        (self.navigationController as? NXNavigationController)?.closeViewController(value.contentViewController!, animated: true)

                    })
                } else if operation == "NXAsset-video-9" {
                    NXAsset.album(open: { _, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 9
                        value.wrapped.image.minOfAssets = 0
                        value.wrapped.image.maxOfAssets = 0
                        value.wrapped.video.minOfAssets = 1
                        value.wrapped.video.maxOfAssets = 9
                        value.wrapped.isMixable = false
                        value.wrapped.mediaType = .video
                        self.navigationController?.pushViewController(value, animated: true)
                    }, completion: { _, value in
                        NXKit.print("count:\(value.assets.count)")
                        self.navigationController?.popViewController(animated: true)
                    })
                } else if operation == "NXAsset-12-1" {
                    NXAsset.album(open: { _, value in
                        value.wrapped.minOfAssets = 1
                        value.wrapped.maxOfAssets = 12
                        value.wrapped.image.minOfAssets = 1
                        value.wrapped.image.maxOfAssets = 12
                        value.wrapped.video.minOfAssets = 1
                        value.wrapped.video.maxOfAssets = 12
                        value.wrapped.isMixable = true
                        value.wrapped.mediaType = .unknown
                        self.present(value, animated: true, completion: nil)
                    }, completion: { _, value in
                        NXKit.print("count:\(value.assets.count)")
                        self.dismiss(animated: true, completion: nil)
                    })
                } else if operation == "NXAsset-12-2" {
                    NXAsset.album(open: { _, value in
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
                    }, completion: { _, value in
                        NXKit.print("count:\(value.assets.count)")
                        (self.navigationController as? NXNavigationController)?.closeViewController(value.contentViewController!, animated: true)
                    })
                } else if operation == "camera-image" {
                    NXAsset.camera(open: { _, value in
                        self.navigationController?.pushViewController(value, animated: true)
                    }, completion: { _, value in
                        NXKit.print("count:\(value.assets.count)")
                        self.navigationController?.popViewController(animated: true)
                    })
                } else if operation == "camera-video" {
                    NXAsset.camera(open: { _, value in
                        self.present(value, animated: true, completion: nil)
                    }, completion: { _, value in
                        NXKit.print("count:\(value.assets.count)")
                        self.dismiss(animated: true, completion: nil)
                    })
                } else if operation == "NXActionView-alert-1" {
                    NXActionView.alert(title: "温馨提示", subtitle: "确认删除该记录吗？删除后不可恢复哦", actions: ["我再想想"], completion: nil)
                } else if operation == "NXActionView-alert-2" {
                    NXActionView.alert(title: "温馨提示", subtitle: "确认删除该记录吗？删除后不可恢复哦", actions: ["删除", "我再想想"], completion: nil)
                } else if operation == "NXActionView-alert-3" {
                    NXActionView.alert(title: "温馨提示", subtitle: "确认删除该记录吗？删除后不可恢复哦", actions: ["删除", "我再想想", "稍后再说", "好的"], completion: nil)
                } else if operation == "NXActionView-action" {
                    NXActionView.action(actions: [NXAbstract(title: "北京", value: nil, completion: nil), NXAbstract(title: "上海", value: nil, completion: nil)], header: .none, footer: .none, completion: nil)
                } else if operation == "NXActionView-action-footer" {
                    var actions = [NXAbstract]()
                    actions.append(NXAbstract(title: "北京", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "上海", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "广州", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "深圳", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "成都", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "重庆", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "武汉", value: nil, completion: nil))
                    NXActionView.action(actions: actions, header: .none, footer: .footer(false, "取消"), completion: nil)
                } else if operation == "NXActionView-action--header-footer" {
                    var actions = [NXAbstract]()
                    actions.append(NXAbstract(title: "北京", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "上海", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "广州", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "深圳", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "成都", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "重庆", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "武汉", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "杭州", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "西安", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "长沙", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "郑州", value: nil, completion: nil))
                    actions.append(NXAbstract(title: "合肥", value: nil, completion: nil))
                    NXActionView.action(actions: actions, header: .header(true, false, true, true, "请选择城市", ""), footer: .footer(false, "取消"), completion: nil)
                }
            }
        }
    }
}
