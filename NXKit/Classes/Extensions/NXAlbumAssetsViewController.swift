//
//  NXAlbumAssetsViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/24.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import Photos
import UIKit

open class NXAlbumAssetsViewController: NXViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    public func getWrapped() -> NXAsset.Wrapped { wrapped }
    // 配置信息
    private let wrapped = NXAsset.Wrapped()
    // 导航栏中间切换相册
    public let centerView = NXButton(frame: CGRect(x: 75.0, y: NXKit.safeAreaInsets.top, width: NXKit.width - 75.0 * 2, height: 44.0))
    // 空页面
    public let placeholderView = NXPlaceholderView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: NXKit.width))
    // 展示图片
    public let collectionView = NXCollectionView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: NXKit.height - NXKit.safeAreaInsets.top - 44.0 - 50 - NXKit.safeAreaInsets.bottom))
    // 展示底部切换的按钮
    public let footerView = NXLRView<UIButton, UIButton>(frame: CGRect(x: 0, y: -(50 + NXKit.safeAreaInsets.bottom), width: NXKit.width, height: 50 + NXKit.safeAreaInsets.bottom))
    // 观察者
    public let observer = NXAsset.Observer()
    // 选中了第几个相册
    public var index = 0

    override open func initialize() {
        super.initialize()

        observer.completion = { [weak self] _, _ in
            self?.request("", nil, nil)
            self?.observer.unregister()
        }
    }

    public func photoLibraryDidChange(_: PHChange) {
        NXKit.print("photoLibraryDidChange")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        request("", nil, nil)
    }

    override open func request(_: String, _: Any?, _: NXKit.Event<String, Any?>? = nil) {
        /** 加载图片数据:
         1.创建一个串行队列：不在主队列，不会阻塞主线程。
         2.串行队列保证队列内的任务按顺序执行，即先夹在完图片数据，再刷新UI显示
         3.采用异步的方式，不影响主线程的其他操作
         */
        wrapped.albums.removeAll()
        wrapped.previewAssets.removeAll()
        wrapped.assets.removeAll()
        wrapped.image.assets.removeAll()
        wrapped.video.assets.removeAll()
        collectionView.reloadData()

        NXKit.authorization(NXKit.Authorize.album, DispatchQueue.main, true) { [weak self] state in
            // 1.授权
            if state == .authorized, let self = self {
                self.startAnimating()
                DispatchQueue(label: "serialQueue", attributes: .init(rawValue: 0)).async {
                    NXAsset.outputAlbums(self.wrapped, completion: { [weak self] _, albums in
                        self?.wrapped.albums = albums

                        DispatchQueue.main.async { [weak self] in
                            self?.stopAnimating()

                            // 2.获取资源
                            if let count = self?.wrapped.albums.count, count > 0 {
                                self?.previewAssets(at: 0)
                            } else {
                                self?.updateSubviews(nil)
                            }
                        }
                    })
                }
            } else {
                self?.updateSubviews(nil)
            }
        }
    }

    override open func setupSubviews() {
        centerView.setTitle("我的相册", for: .normal)
        centerView.setImage(NXKit.image(named: "navi-dropdown-arrow.png", mode: .alwaysTemplate), for: .normal)
        centerView.setTitleColor(NXKit.barForegroundColor, for: .normal)
        centerView.tintColor = NXKit.barForegroundColor
        centerView.titleLabel?.font = NXKit.font(17, .bold)
        centerView.contentHorizontalAlignment = .center
        centerView.setupEvent(.touchUpInside) { [weak self] _, _ in
            self?.dispose("previewAlbums", nil, nil)
        }
        centerView.updateAlignment(.horizontalReverse, 2)
        navigationView.centerView = centerView
        navigationView.backBarButton.isHidden = false
        navigationView.backBarButton.updateSubviews(NXKit.image(named: "navi-close.png", mode: .alwaysTemplate), nil)
        navigationView.backBarButton.addTarget(nil, action: nil) { [weak self] _ in
            self?.wrapped.close(assets: [])
        }

        navigationView.rightView = NXNavigationView.Bar.forward(image: NXKit.image(named: "icon-camera.png", mode: .alwaysTemplate), title: nil, completion: { [weak self] _ in
            self?.observer.unregister()
            self?.dispose("openCamera", nil)
        })
        navigationView.rightView?.isHidden = wrapped.subviews.camera

        placeholderView.isHidden = true
        placeholderView.descriptionView.text = "您的相册没有图片/视频，或者您没有授权\(NXKit.name)访问您的相册。"
        contentView.addSubview(placeholderView)

        if wrapped.numberOfColumns < 1 || wrapped.numberOfColumns > 7 {
            wrapped.numberOfColumns = 4
        }
        var itemSize = (NXKit.width - 12 * 2 - 2 * CGFloat(wrapped.numberOfColumns - 1)) / CGFloat(wrapped.numberOfColumns)
        itemSize = floor(itemSize * NXKit.scale) / NXKit.scale // 因为屏幕渲染的最小的大小为1/NXKit.scale

        collectionView.isHidden = false
        collectionView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - 50 - NXKit.safeAreaInsets.bottom)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = 1
            layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: itemSize, height: itemSize)
        }

        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = NXKit.backgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NXAlbumAssetViewCell.self, forCellWithReuseIdentifier: "NXAlbumAssetViewCell")
        collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        contentView.addSubview(collectionView)

        footerView.isHidden = false
        footerView.frame = CGRect(x: 0, y: contentView.height - 50 - NXKit.safeAreaInsets.bottom, width: contentView.width, height: 50 + NXKit.safeAreaInsets.bottom)
        footerView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        footerView.backgroundColor = NXKit.backgroundColor
        footerView.lhsView.frame = CGRect(x: 15, y: 7, width: 144, height: 36)
        footerView.lhsView.setTitleColor(NXKit.primaryColor, for: .normal)
        footerView.lhsView.titleLabel?.font = NXKit.font(16, .regular)
        footerView.lhsView.contentHorizontalAlignment = .left
        footerView.lhsView.isHidden = wrapped.subviews.preview
        footerView.lhsView.setTitle("预览(0)", for: .normal)
        footerView.lhsView.setupEvent(.touchUpInside, action: { [weak self] _, _ in
            self?.dispose("previewAssets", self?.wrapped.assets)
        })

        footerView.rhsView.frame = CGRect(x: NXKit.width - 15 - 88, y: 7, width: 88, height: 36)
        footerView.rhsView.layer.cornerRadius = 18
        footerView.rhsView.layer.masksToBounds = true
        footerView.rhsView.setTitleColor(UIColor.white, for: .normal)
        footerView.rhsView.setBackgroundImage(UIImage.image(color: NXKit.primaryColor), for: .normal)
        footerView.rhsView.titleLabel?.font = NXKit.font(15, .regular)
        footerView.rhsView.isHidden = wrapped.subviews.output
        footerView.rhsView.setTitle("完成(0/\(wrapped.maxOfAssets))", for: .normal)
        footerView.rhsView.setupEvent(.touchUpInside, action: { [weak self] _, _ in
            self?.dispose("outputAssets", nil)
        })
        footerView.layer.shadowColor = NXKit.shadowColor.cgColor
        footerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        footerView.layer.shadowRadius = 2
        footerView.layer.shadowOpacity = 0.15
        footerView.layer.cornerRadius = 2
        footerView.layer.masksToBounds = false
        contentView.addSubview(footerView)

        dispose("subcomponents", nil)
    }

    override open func updateSubviews(_ value: Any?) {
        if wrapped.albums.count > 0 {
            placeholderView.isHidden = true
            collectionView.isHidden = false
            footerView.isHidden = false
        } else {
            placeholderView.isHidden = false
            collectionView.isHidden = true
            footerView.isHidden = true
        }

        guard let album = value as? NXAlbum else {
            return
        }

        centerView.setTitle(album.title.value, for: .normal)
        centerView.updateAlignment(.horizontalReverse, 2)

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset.top = 12
        }
    }

    override open func dispose(_ action: String, _ value: Any?, _: NXKit.Event<String, Any?>? = nil) {
        if action == "previewAssets" {
            guard let assets = value as? [NXAsset] else { return }
            if assets.count == 0 {
                NXKit.showToast(message: "请选择图片或视频后再预览哦", .center, contentView)
                return
            }

            if wrapped.isOutputting {
                return
            }
            wrapped.isOutputting = true
            NXAsset.outputAssets(assets, wrapped, completion: { [weak self] _, outputs in
                self?.wrapped.isOutputting = false
                NXKit.previewAssets(assets: outputs, index: 0)
            })
        } else if action == "outputAssets" {
            if wrapped.assets.count < wrapped.minOfAssets {
                if wrapped.image.minOfAssets > 0 {
                    NXKit.showToast(message: "请至少选择\(wrapped.image.minOfAssets)张图片", .center, contentView)
                } else if wrapped.video.minOfAssets > 0 {
                    NXKit.showToast(message: "请至少选择\(wrapped.video.minOfAssets)个视频", .center, contentView)
                }
                return
            }

            if wrapped.isOutputable {
                if wrapped.isOutputting {
                    return
                }
                wrapped.isOutputting = true

                NXAsset.outputAssets(wrapped.assets, wrapped, completion: { [weak self] (_, assets: [NXAsset]) in
                    guard let self = self else {
                        return
                    }
                    self.wrapped.isOutputting = false

                    if assets.count == 1, self.wrapped.clips.count >= 1, let image = assets.first?.image {
                        let vc = NXAssetClipViewController()
                        vc.image = image
                        vc.clips.key = 0
                        vc.clips.value = self.wrapped.clips
                        vc.ctxs.event = { [weak self] _, outputUIImage in
                            guard let self = self else {
                                return
                            }
                            if let o = outputUIImage as? UIImage {
                                assets.first?.image = o
                            }
                            self.wrapped.close(assets: assets)
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        self.wrapped.close(assets: assets)
                    }
                })
            } else {
                wrapped.close(assets: wrapped.assets)
            }
        } else if action == "didSelectAsset" {
            guard let asset = value as? NXAsset else {
                return
            }
            let __wrapped = wrapped

            if __wrapped.assets.contains(asset) {
                __wrapped.remove(asset)
                collectionView.reloadData()

                dispose("subcomponents", nil)
                return
            }

            if asset.mediaType == .image {
                if __wrapped.image.maxOfAssets <= 0 {
                    NXKit.showToast(message: "不支持选择图片", .center, contentView)
                    return
                }

                if __wrapped.isMixable {
                    if __wrapped.assets.count >= __wrapped.maxOfAssets {
                        NXKit.showToast(message: "最多只能选择\(__wrapped.maxOfAssets)张图片和视频哦", .center, contentView)
                        return
                    }
                } else {
                    if __wrapped.video.assets.count > 0 {
                        NXKit.showToast(message: "不支持同时选择图片和视频", .center, contentView)
                        return
                    }
                }

                if __wrapped.image.assets.count >= __wrapped.image.maxOfAssets {
                    NXKit.showToast(message: "最多只能选择\(__wrapped.image.maxOfAssets)张图片哦", .center, contentView)
                    return
                }

                if asset.isSelectable {
                    // 选择图片
                    __wrapped.add(asset)
                    collectionView.reloadData()

                    // 当只选择一张的时候，选择之后直接进行接下来的操作
                    if __wrapped.image.maxOfAssets == 1 && __wrapped.image.assets.count == 1 && __wrapped.isMixable == false && __wrapped.isAutoclosed {
                        dispose("outputAssets", nil)
                    }
                    dispose("subcomponents", nil)
                } else {
                    NXKit.showToast(message: "不支持选择图片", .center, contentView)
                }
            } else if asset.mediaType == .video {
                if __wrapped.video.maxOfAssets <= 0 {
                    NXKit.showToast(message: "不支持选择视频", .center, contentView)
                    return
                }

                if __wrapped.isMixable {
                    if __wrapped.assets.count >= __wrapped.maxOfAssets {
                        NXKit.showToast(message: "最多只能选择\(__wrapped.maxOfAssets)张图片和视频哦", .center, contentView)
                        return
                    }
                } else {
                    if __wrapped.image.assets.count > 0 {
                        NXKit.showToast(message: "不支持同时选择图片和视频", .center, contentView)
                        return
                    }
                }

                if __wrapped.video.assets.count >= __wrapped.video.maxOfAssets {
                    NXKit.showToast(message: "最多只能选择\(__wrapped.video.maxOfAssets)个视频哦", .center, contentView)
                    return
                }

                if asset.isSelectable {
                    // 格式有效：检测一下如果视频超长但是又不支持裁减的话就不能选中
                    if __wrapped.duration > 0 && asset.duration > __wrapped.duration {
                        NXKit.showToast(message: "暂时只支持\(__wrapped.duration)秒以内的视频", .center, contentView)
                        return
                    }

                    // 选择视频
                    __wrapped.add(asset)
                    collectionView.reloadData()

                    if __wrapped.video.maxOfAssets == 1 && __wrapped.video.assets.count == 1 && __wrapped.isMixable == false && __wrapped.isAutoclosed {
                        dispose("outputAssets", nil)
                    }
                    dispose("subcomponents", nil)
                } else {
                    NXKit.showToast(message: "暂时只支持MP4格式的视频", .center, contentView)
                }
            } else if asset.mediaType == .audio {
                NXKit.showToast(message: "不支持选择音频哦", .center, contentView)
            }
        } else if action == "previewAlbums" {
            if wrapped.albums.count <= 0 {
                NXKit.showToast(message: "您的相册没有图片/视频，或者您没有授权\(NXKit.name)访问您的相册。", .center, contentView)
                return
            }
            NXActionView.action(actions: wrapped.albums,
                                header: .header(false, false, true, true, "请选择相册", ""),
                                footer: .whitespace(32))
            { _, index in
                guard index != self.index else {
                    return
                }
                self.index = index
                self.previewAssets(at: index)
            }
        } else if action == "openCamera" {
            NXKit.authorization(NXKit.Authorize.camera, DispatchQueue.main, true) { [weak self] status in
                if status == .authorized, let self = self {
                    let picker = UIImagePickerController()
                    picker.allowsEditing = false
                    picker.delegate = self
                    picker.sourceType = .camera
                    picker.modalPresentationStyle = .fullScreen
                    self.present(picker, animated: true, completion: nil)
                }
            }
        } else if action == "subcomponents" {
            footerView.lhsView.setTitle("预览(\(wrapped.assets.count))", for: .normal)
            var __description = "完成(0/\(wrapped.maxOfAssets))"
            if wrapped.isMixable {
                __description = "完成(\(wrapped.assets.count)/\(wrapped.maxOfAssets))"
            } else {
                if wrapped.image.assets.count > 0 {
                    __description = "完成(\(wrapped.assets.count)/\(wrapped.image.maxOfAssets))"
                } else if wrapped.video.assets.count > 0 {
                    __description = "完成(\(wrapped.assets.count)/\(wrapped.video.maxOfAssets))"
                }
            }
            var __size = String.size(of: __description, size: CGSize(width: 200, height: 36), font: NXKit.font(15))
            __size.width = __size.width + 24
            __size.height = 36
            footerView.rhsView.frame = CGRect(x: NXKit.width - 15 - __size.width, y: 12, width: __size.width, height: __size.height)
            footerView.rhsView.setTitle(__description, for: .normal)

            navigationView.rightView?.isHidden = wrapped.subviews.camera
                || wrapped.assets.count >= wrapped.maxOfAssets
                || wrapped.image.assets.count >= wrapped.image.maxOfAssets && wrapped.image.maxOfAssets > 0
                || wrapped.video.assets.count >= wrapped.video.maxOfAssets && wrapped.video.maxOfAssets > 0
        }
    }

    @objc override open func onBackPressed() {
        wrapped.close(assets: [])
    }

    public func previewAssets(at index: Int) {
        guard index >= 0 && index < wrapped.albums.count else {
            updateSubviews(nil)
            return
        }
        wrapped.index = index

        let album = wrapped.albums[index]
        wrapped.previewAssets.removeAll()

        wrapped.previewAssets.append(contentsOf: album.assets)
        wrapped.previewAssets.forEach { [weak self] asset in
            asset.completion = { [weak self] _, value in
                self?.dispose("didSelectAsset", value, nil)
            }
        }

        updateSubviews(album)
        collectionView.reloadData()

        // 滚动到底部
        if wrapped.previewAssets.count > 0 {
            let index = IndexPath(row: wrapped.previewAssets.count - 1, section: 0)
            collectionView.scrollToItem(at: index, at: .bottom, animated: false)
        }
    }

    /// UICollectionViewDelegate, UICollectionViewDataSource
    public func collectionView(_: UICollectionView, onSelectViewAt indexPath: IndexPath) {
        let asset = wrapped.previewAssets[indexPath.item]
        if wrapped.assets.contains(asset) && wrapped.assets.count > 0 {
            dispose("previewAssets", wrapped.assets, nil)
        } else {
            dispose("previewAssets", [asset], nil)
        }
    }

    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return wrapped.previewAssets.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NXAlbumAssetViewCell", for: indexPath) as! NXAlbumAssetViewCell
        let asset = wrapped.previewAssets[indexPath.item]
        if wrapped.assets.contains(asset) {
            asset.isMaskedable = false
            asset.index = "✓"

            if asset.mediaType == .image && wrapped.image.isIndex, let index = wrapped.image.assets.firstIndex(of: asset) {
                asset.index = "\(index + 1)"
            } else if asset.mediaType == .video && wrapped.video.isIndex, let index = wrapped.video.assets.firstIndex(of: asset) {
                asset.index = "\(index + 1)"
            }
        } else {
            if asset.mediaType == .image {
                asset.isMaskedable = wrapped.image.assets.count >= wrapped.image.maxOfAssets
                if asset.isMaskedable == false {
                    asset.isMaskedable = wrapped.assets.count >= wrapped.maxOfAssets
                }
                if asset.isMaskedable == false && wrapped.isMixable == false {
                    asset.isMaskedable = wrapped.video.assets.count > 0
                }
            } else if asset.mediaType == .video {
                asset.isMaskedable = wrapped.video.assets.count >= wrapped.video.maxOfAssets
                if asset.isMaskedable == false {
                    asset.isMaskedable = wrapped.assets.count >= wrapped.maxOfAssets
                }
                if asset.isMaskedable == false && wrapped.isMixable == false {
                    asset.isMaskedable = wrapped.image.assets.count > 0
                }
            } else {
                asset.isMaskedable = true
            }
            asset.index = ""
        }
        cell.updateSubviews(asset)
        return cell
    }

    override open func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        footerView.layer.shadowColor = NXKit.shadowColor.cgColor
        footerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        footerView.layer.shadowRadius = 2
        footerView.layer.shadowOpacity = 0.15
        footerView.layer.cornerRadius = 2
        footerView.layer.masksToBounds = false
    }

    deinit {
        self.observer.unregister()
    }
}

extension NXAlbumAssetsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: false, completion: nil)

        // 系统相册选图
        var image: UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let __image = image, let fixed = UIImage.fixedOrientation(image: __image) {
            image = fixed
        }

        if let __output = image {
            NXKit.showLoading("正在保存", .center, view)
            NXAsset.saveImage(image: __output, completion: { [weak self] _, asset in
                guard let self = self else { return }
                NXKit.hideLoading(superview: self.view)

                if let __asset = asset {
                    let nxAsset = NXAsset(wrappedValue: __asset, suffixes: self.wrapped.suffixes)
                    nxAsset.image = __output
                    nxAsset.thumbnail = __output

                    if self.wrapped.albums.count > 0 {
                        // 存在相册，添加到第一个相册中
                        self.wrapped.albums.first?.assets.append(nxAsset)
                        // 如果是当前相册，则更新previewAssets
                        self.previewAssets(at: self.wrapped.index)
                    } else {
                        // 不存在相册，则创建一个，并插入
                        let album = NXAlbum()
                        album.assets.append(nxAsset)
                        self.wrapped.albums.append(album)
                        // 展示第一个相册
                        self.previewAssets(at: 0)
                    }

                    self.dispose("didSelectAsset", nxAsset, nil)
                } else {
                    NXKit.showToast(message: "保存失败了", .center, self.view)
                }
            })
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
