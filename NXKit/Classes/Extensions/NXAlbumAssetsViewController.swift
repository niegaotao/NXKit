//
//  NXAlbumAssetsViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/24.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit
import Photos

open class NXAlbumAssetsViewController: NXViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    public func getWrapped() -> NXAsset.Wrapped { self.wrapped }
    //配置信息
    private let wrapped = NXAsset.Wrapped()
    //导航栏中间切换相册
    public let centerView = NXButton(frame: CGRect(x: 75.0, y: NXKit.safeAreaInsets.top, width: NXKit.width-75.0*2, height: 44.0))
    //空页面
    public let placeholderView = NXPlaceholderView(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: NXKit.width))
    //展示图片
    public let collectionView = NXCollectionView(frame: CGRect(x: 0, y:0 , width: NXKit.width, height: NXKit.height - NXKit.safeAreaInsets.top - 44.0 - 50 - NXKit.safeAreaInsets.bottom))
    //展示底部切换的按钮
    public let footerView = NXLRView<UIButton, UIButton>(frame: CGRect(x: 0, y: -(50+NXKit.safeAreaInsets.bottom), width: NXKit.width, height: 50+NXKit.safeAreaInsets.bottom))
    //观察者
    public let observer = NXAsset.Observer()
    //选中了第几个相册
    public var index = 0
    
    override open func initialize(){
        super.initialize()
        
        self.observer.completion = {[weak self] _, _ in
            self?.request("", nil, nil)
            self?.observer.unregister()
        }
    }
    
    public func photoLibraryDidChange(_ changeInstance: PHChange) {
        NXKit.print("photoLibraryDidChange")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSubviews()
        self.request("", nil, nil)
    }
    
    open override func request(_ operation: String, _ value: Any?, _ completion: NXKit.Event<String, Any?>? = nil) {
        /** 加载图片数据:
         1.创建一个串行队列：不在主队列，不会阻塞主线程。
         2.串行队列保证队列内的任务按顺序执行，即先夹在完图片数据，再刷新UI显示
         3.采用异步的方式，不影响主线程的其他操作
         */
        self.wrapped.albums.removeAll()
        self.wrapped.previewAssets.removeAll()
        self.wrapped.assets.removeAll()
        self.wrapped.image.assets.removeAll()
        self.wrapped.video.assets.removeAll()
        self.collectionView.reloadData()
        
        NXKit.authorization(NXKit.Authorize.album, DispatchQueue.main, true) {[weak self] (state) in
            //1.授权
            if state == .authorized, let self = self {
                self.startAnimating()
                DispatchQueue(label: "serialQueue", attributes: .init(rawValue: 0)).async {
                    NXAsset.outputAlbums(self.wrapped, completion: { [weak self] (_, albums) in
                        self?.wrapped.albums = albums
                        
                        DispatchQueue.main.async {[weak self] in
                            self?.stopAnimating()
                            
                            //2.获取资源
                            if let count = self?.wrapped.albums.count, count > 0  {
                                self?.previewAssets(at: 0)
                            }
                            else{
                                self?.updateSubviews(nil)
                            }
                        }
                    })
                }
            }
            else {
                self?.updateSubviews(nil)
            }
        }
    }
    
    open override func setupSubviews(){
        self.centerView.setTitle("我的相册", for: .normal)
        self.centerView.setImage(NXKit.image(named: "navi-dropdown-arrow.png", mode: .alwaysTemplate), for: .normal)
        self.centerView.setTitleColor(NXKit.barForegroundColor, for: .normal)
        self.centerView.tintColor = NXKit.barForegroundColor
        self.centerView.titleLabel?.font = NXKit.font(17, .bold)
        self.centerView.contentHorizontalAlignment = .center
        self.centerView.setupEvent(.touchUpInside) {[weak self] _, _ in
            self?.dispose("previewAlbums", nil, nil)
        }
        self.centerView.updateAlignment(.horizontalReverse, 2)
        self.navigationView.centerView = self.centerView
        self.navigationView.backBarButton.isHidden = false
        self.navigationView.backBarButton.updateSubviews(NXKit.image(named: "navi-close.png", mode: .alwaysTemplate), nil)
        self.navigationView.backBarButton.addTarget(nil, action: nil) {[weak self] _ in
            self?.wrapped.close(assets: [])
        }
        
        self.navigationView.rightView = NXNavigationView.Bar.forward(image: NXKit.image(named: "icon-camera.png", mode: .alwaysTemplate), title: nil, completion: {[weak self] owner in
            self?.observer.unregister()
            self?.dispose("openCamera", nil)
        })
        self.navigationView.rightView?.isHidden = self.wrapped.subviews.camera
        
        self.placeholderView.isHidden = true
        self.placeholderView.descriptionView.text = "您的相册没有图片/视频，或者您没有授权\(NXKit.name)访问您的相册。"
        self.contentView.addSubview(self.placeholderView)
        
        if(self.wrapped.numberOfColumns < 1 || self.wrapped.numberOfColumns > 7) {
            self.wrapped.numberOfColumns = 4
        }
        var itemSize = (NXKit.width-12*2-2*CGFloat(self.wrapped.numberOfColumns-1))/CGFloat(self.wrapped.numberOfColumns)
        itemSize = floor(itemSize * NXKit.scale)/NXKit.scale//因为屏幕渲染的最小的大小为1/NXKit.scale
        
        self.collectionView.isHidden = false
        self.collectionView.frame = CGRect(x: 0, y:0 , width: self.contentView.width, height: self.contentView.height - 50 - NXKit.safeAreaInsets.bottom)
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = 1
            layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: itemSize, height: itemSize)
        }
        
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = NXKit.backgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(NXAlbumAssetViewCell.self, forCellWithReuseIdentifier: "NXAlbumAssetViewCell")
        self.collectionView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        self.contentView.addSubview(self.collectionView)

        
        self.footerView.isHidden = false
        self.footerView.frame = CGRect(x: 0, y: self.contentView.height-50-NXKit.safeAreaInsets.bottom, width: self.contentView.width, height: 50+NXKit.safeAreaInsets.bottom)
        self.footerView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.footerView.backgroundColor = NXKit.backgroundColor
        self.footerView.lhsView.frame = CGRect(x: 15, y: 7, width: 144, height: 36)
        self.footerView.lhsView.setTitleColor(NXKit.primaryColor, for: .normal)
        self.footerView.lhsView.titleLabel?.font = NXKit.font(16, .regular)
        self.footerView.lhsView.contentHorizontalAlignment = .left
        self.footerView.lhsView.isHidden = self.wrapped.subviews.preview
        self.footerView.lhsView.setTitle("预览(0)", for: .normal)
        self.footerView.lhsView.setupEvent(.touchUpInside, action: {[weak self] (e, v) in
            self?.dispose("previewAssets", self?.wrapped.assets)
        })
        
        self.footerView.rhsView.frame = CGRect(x: NXKit.width-15-88, y: 7, width: 88, height: 36)
        self.footerView.rhsView.layer.cornerRadius = 18
        self.footerView.rhsView.layer.masksToBounds = true
        self.footerView.rhsView.setTitleColor(UIColor.white, for: .normal)
        self.footerView.rhsView.setBackgroundImage(UIImage.image(color: NXKit.primaryColor), for: .normal)
        self.footerView.rhsView.titleLabel?.font = NXKit.font(15, .regular)
        self.footerView.rhsView.isHidden = self.wrapped.subviews.output
        self.footerView.rhsView.setTitle("完成(0/\(self.wrapped.maxOfAssets))", for: .normal)
        self.footerView.rhsView.setupEvent(.touchUpInside, action: {[weak self] (e, v) in
            self?.dispose("outputAssets", nil)
        })
        self.footerView.layer.shadowColor = NXKit.shadowColor.cgColor;
        self.footerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.footerView.layer.shadowRadius = 2
        self.footerView.layer.shadowOpacity = 0.15
        self.footerView.layer.cornerRadius = 2
        self.footerView.layer.masksToBounds = false
        self.contentView.addSubview(self.footerView)
        
        self.dispose("subcomponents", nil)
    }
    
    open override func updateSubviews(_ value: Any?){
        
        if self.wrapped.albums.count > 0 {
            self.placeholderView.isHidden = true
            self.collectionView.isHidden = false
            self.footerView.isHidden = false
        }
        else {
            self.placeholderView.isHidden = false
            self.collectionView.isHidden = true
            self.footerView.isHidden = true
        }
        
        guard let album = value as? NXAlbum else {
            return
        }
        
        self.centerView.setTitle(album.title.value, for: .normal)
        self.centerView.updateAlignment(.horizontalReverse, 2)
                
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset.top = 12
        }
    }
    
    open override func dispose(_ action: String, _ value: Any?, _ completion: NXKit.Event<String, Any?>? = nil) {
        if action == "previewAssets" {
            guard let assets = value as? [NXAsset] else {return}
            if assets.count == 0 {
                NXKit.showToast(message: "请选择图片或视频后再预览哦", .center, self.contentView)
                return;
            }
            
            if wrapped.isOutputting {
                return;
            }
            wrapped.isOutputting = true
            NXAsset.outputAssets(assets, self.wrapped, completion:{[weak self] (_, outputs) in
                self?.wrapped.isOutputting = false
                NXKit.previewAssets(assets: outputs, index: 0)
            })
        }
        else if action == "outputAssets" {
            if self.wrapped.assets.count < self.wrapped.minOfAssets {
                if self.wrapped.image.minOfAssets > 0 {
                    NXKit.showToast(message: "请至少选择\(self.wrapped.image.minOfAssets)张图片", .center, self.contentView)
                }
                else if self.wrapped.video.minOfAssets > 0 {
                    NXKit.showToast(message: "请至少选择\(self.wrapped.video.minOfAssets)个视频", .center, self.contentView)
                }
                return
            }
            
            if wrapped.isOutputable {
                if wrapped.isOutputting {
                    return;
                }
                wrapped.isOutputting = true
                
                NXAsset.outputAssets(self.wrapped.assets, self.wrapped, completion:{[weak self] (_, assets: [NXAsset]) in
                    guard let self = self else {
                        return
                    }
                    self.wrapped.isOutputting = false
                    
                    if assets.count == 1 && self.wrapped.clips.count >= 1, let image = assets.first?.image  {
                        let vc = NXAssetClipViewController()
                        vc.image = image
                        vc.clips.key = 0
                        vc.clips.value = self.wrapped.clips
                        vc.ctxs.event = { [weak self] (_, outputUIImage) in
                            guard let self = self else {
                                return
                            }
                            if let o = outputUIImage as? UIImage {
                                assets.first?.image = o
                            }
                            self.wrapped.close(assets: assets)
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        self.wrapped.close(assets: assets)
                    }
                })
            }
            else {
                self.wrapped.close(assets: self.wrapped.assets)
            }
        }
        else if action == "didSelectAsset" {
            guard let asset = value as? NXAsset else {
                return
            }
            let __wrapped = self.wrapped
            
            if __wrapped.assets.contains(asset) {
                __wrapped.remove(asset)
                self.collectionView.reloadData()
                
                self.dispose("subcomponents", nil)
                return
            }
            
            if asset.mediaType == .image {
                if __wrapped.image.maxOfAssets <= 0 {
                    NXKit.showToast(message: "不支持选择图片", .center, self.contentView)
                    return
                }
                
                if __wrapped.isMixable {
                    if __wrapped.assets.count >= __wrapped.maxOfAssets {
                        NXKit.showToast(message: "最多只能选择\(__wrapped.maxOfAssets)张图片和视频哦", .center, self.contentView)
                        return
                    }
                }
                else {
                    if __wrapped.video.assets.count > 0  {
                        NXKit.showToast(message: "不支持同时选择图片和视频", .center, self.contentView)
                        return
                    }
                }
            
                if __wrapped.image.assets.count >= __wrapped.image.maxOfAssets {
                    NXKit.showToast(message: "最多只能选择\(__wrapped.image.maxOfAssets)张图片哦", .center, self.contentView)
                    return
                }
                
                if asset.isSelectable {
                    //选择图片
                    __wrapped.add(asset)
                    self.collectionView.reloadData()
                    
                    //当只选择一张的时候，选择之后直接进行接下来的操作
                    if __wrapped.image.maxOfAssets == 1 && __wrapped.image.assets.count == 1 && __wrapped.isMixable == false && __wrapped.isAutoclosed {
                        self.dispose("outputAssets", nil)
                    }
                    self.dispose("subcomponents", nil)
                }
                else {
                    NXKit.showToast(message: "不支持选择图片", .center, self.contentView)
                }
            }
            else if asset.mediaType == .video {
                if __wrapped.video.maxOfAssets <= 0 {
                    NXKit.showToast(message: "不支持选择视频", .center, self.contentView)
                    return
                }
                
                if __wrapped.isMixable {
                    if __wrapped.assets.count >= __wrapped.maxOfAssets {
                        NXKit.showToast(message: "最多只能选择\(__wrapped.maxOfAssets)张图片和视频哦", .center, self.contentView)
                        return
                    }
                }
                else {
                    if __wrapped.image.assets.count > 0 {
                        NXKit.showToast(message: "不支持同时选择图片和视频", .center, self.contentView)
                        return
                    }
                }
                
                if __wrapped.video.assets.count >= __wrapped.video.maxOfAssets {
                    NXKit.showToast(message: "最多只能选择\(__wrapped.video.maxOfAssets)个视频哦", .center, self.contentView)
                    return
                }
                
                if asset.isSelectable {
                    //格式有效：检测一下如果视频超长但是又不支持裁减的话就不能选中
                    if __wrapped.duration > 0 && asset.duration > __wrapped.duration {
                        NXKit.showToast(message: "暂时只支持\(__wrapped.duration)秒以内的视频", .center, self.contentView)
                        return
                    }
                    
                    //选择视频
                    __wrapped.add(asset)
                    self.collectionView.reloadData()

                    if __wrapped.video.maxOfAssets == 1 && __wrapped.video.assets.count == 1 && __wrapped.isMixable == false && __wrapped.isAutoclosed {
                        self.dispose("outputAssets", nil)
                    }
                    self.dispose("subcomponents", nil)
                }
                else {
                    NXKit.showToast(message: "暂时只支持MP4格式的视频", .center, self.contentView)
                }
            }
            else if asset.mediaType == .audio {
                NXKit.showToast(message: "不支持选择音频哦", .center, self.contentView)
            }
        }
        else if action == "previewAlbums" {
            if self.wrapped.albums.count <= 0 {
                NXKit.showToast(message: "您的相册没有图片/视频，或者您没有授权\(NXKit.name)访问您的相册。", .center, self.contentView)
                return
            }
            NXActionView.action(actions: self.wrapped.albums, 
                                header: .header(false, false, true, true, "请选择相册",""),
                                footer: .whitespace(32)) { (_, index) in
                guard index != self.index else {
                    return;
                }
                self.index = index
                self.previewAssets(at: index)
            }
        }
        else if action == "openCamera" {
            NXKit.authorization(NXKit.Authorize.camera, DispatchQueue.main, true) {[weak self] (status) in
                if status == .authorized, let self = self {
                    let picker = UIImagePickerController()
                    picker.allowsEditing = false
                    picker.delegate = self
                    picker.sourceType = .camera
                    picker.modalPresentationStyle = .fullScreen
                    self.present(picker, animated: true, completion: nil)
                }
            }
        }
        else if action == "subcomponents" {
            self.footerView.lhsView.setTitle("预览(\(self.wrapped.assets.count))", for: .normal)
            var __description = "完成(0/\(self.wrapped.maxOfAssets))"
            if self.wrapped.isMixable {
                __description = "完成(\(self.wrapped.assets.count)/\(self.wrapped.maxOfAssets))"
            }
            else {
                if self.wrapped.image.assets.count > 0 {
                    __description = "完成(\(self.wrapped.assets.count)/\(self.wrapped.image.maxOfAssets))"
                }
                else if self.wrapped.video.assets.count > 0 {
                    __description = "完成(\(self.wrapped.assets.count)/\(self.wrapped.video.maxOfAssets))"
                }
            }
            var __size = String.size(of: __description, size: CGSize(width: 200, height: 36), font: NXKit.font(15))
            __size.width = __size.width + 24
            __size.height = 36
            self.footerView.rhsView.frame = CGRect(x: NXKit.width-15-__size.width, y: 12, width: __size.width, height: __size.height)
            self.footerView.rhsView.setTitle(__description, for: .normal)
            
            self.navigationView.rightView?.isHidden = self.wrapped.subviews.camera
            || self.wrapped.assets.count >= self.wrapped.maxOfAssets
            || self.wrapped.image.assets.count >= self.wrapped.image.maxOfAssets && self.wrapped.image.maxOfAssets > 0
            || self.wrapped.video.assets.count >= self.wrapped.video.maxOfAssets && self.wrapped.video.maxOfAssets > 0
        }
    }
    
    @objc override open func onBackPressed() {
        self.wrapped.close(assets: [])
    }
    
    public func previewAssets(at index: Int){
        guard index >= 0 && index < self.wrapped.albums.count else {
            self.updateSubviews(nil)
            return;
        }
        self.wrapped.index = index
        
        let album = self.wrapped.albums[index]
        self.wrapped.previewAssets.removeAll()
        
        self.wrapped.previewAssets.append(contentsOf: album.assets)
        self.wrapped.previewAssets.forEach {[weak self] asset in
            asset.completion = {[weak self] _ , value in
                self?.dispose("didSelectAsset", value, nil)
            }
        }
        
        self.updateSubviews(album)
        self.collectionView.reloadData()
        
        //滚动到底部
        if self.wrapped.previewAssets.count > 0 {
            let index = IndexPath(row: self.wrapped.previewAssets.count-1, section: 0)
            self.collectionView.scrollToItem(at: index, at: .bottom, animated: false)
        }
    }
    
    ///UICollectionViewDelegate, UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, onSelectViewAt indexPath: IndexPath) {
        let asset = self.wrapped.previewAssets[indexPath.item]
        if self.wrapped.assets.contains(asset) && self.wrapped.assets.count > 0{
            self.dispose("previewAssets", self.wrapped.assets, nil)
        }
        else {
            self.dispose("previewAssets", [asset], nil)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wrapped.previewAssets.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NXAlbumAssetViewCell", for: indexPath) as! NXAlbumAssetViewCell
        let asset = self.wrapped.previewAssets[indexPath.item]
        if self.wrapped.assets.contains(asset) {
            
            asset.isMaskedable = false
            asset.index = "✓"

            if asset.mediaType == .image && self.wrapped.image.isIndex, let index = self.wrapped.image.assets.firstIndex(of: asset) {
                asset.index = "\(index+1)"
            }
            else if asset.mediaType == .video && self.wrapped.video.isIndex, let index = self.wrapped.video.assets.firstIndex(of: asset) {
                asset.index = "\(index+1)"
            }
        }
        else {
            if asset.mediaType == .image {
                asset.isMaskedable = self.wrapped.image.assets.count >= self.wrapped.image.maxOfAssets
                if asset.isMaskedable == false {
                    asset.isMaskedable = self.wrapped.assets.count >= self.wrapped.maxOfAssets
                }
                if asset.isMaskedable == false && self.wrapped.isMixable == false {
                    asset.isMaskedable = self.wrapped.video.assets.count > 0
                }
            }
            else if asset.mediaType == .video {
                asset.isMaskedable = self.wrapped.video.assets.count >= self.wrapped.video.maxOfAssets
                if asset.isMaskedable == false {
                    asset.isMaskedable = self.wrapped.assets.count >= self.wrapped.maxOfAssets
                }
                if asset.isMaskedable == false && self.wrapped.isMixable == false {
                    asset.isMaskedable = self.wrapped.image.assets.count > 0
                }
            }
            else {
                asset.isMaskedable = true
            }
            asset.index = ""
        }
        cell.updateSubviews(asset)
        return cell
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        self.footerView.layer.shadowColor = NXKit.shadowColor.cgColor;
        self.footerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.footerView.layer.shadowRadius = 2
        self.footerView.layer.shadowOpacity = 0.15
        self.footerView.layer.cornerRadius = 2
        self.footerView.layer.masksToBounds = false
    }
    
    deinit {
        self.observer.unregister()
    }
}

extension NXAlbumAssetsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)

        //系统相册选图
        var image : UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let __image = image, let fixed = UIImage.fixedOrientation(image: __image) {
            image = fixed
        }
        
        if let __output = image {
            NXKit.showLoading("正在保存", .center, self.view)
            NXAsset.saveImage(image: __output, completion: {[weak self] (state, asset) in
                guard let self = self else {return}
                NXKit.hideLoading(superview: self.view)
                                
                if let __asset = asset {
                    let nxAsset = NXAsset(wrappedValue: __asset, suffixes: self.wrapped.suffixes)
                    nxAsset.image = __output
                    nxAsset.thumbnail = __output
                    
                    if self.wrapped.albums.count > 0 {
                        //存在相册，添加到第一个相册中
                        self.wrapped.albums.first?.assets.append(nxAsset)
                        //如果是当前相册，则更新previewAssets
                        self.previewAssets(at: self.wrapped.index)
                    }
                    else {
                        //不存在相册，则创建一个，并插入
                        let album = NXAlbum()
                        album.assets.append(nxAsset)
                        self.wrapped.albums.append(album)
                        //展示第一个相册
                        self.previewAssets(at: 0)
                    }
                    
                    self.dispose("didSelectAsset", nxAsset, nil)
                }
                else {
                    NXKit.showToast(message: "保存失败了", .center, self.view)
                }
            })
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

