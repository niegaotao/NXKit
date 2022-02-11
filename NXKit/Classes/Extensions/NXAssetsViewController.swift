//
//  NXAssetsViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/24.
//  Copyright © 2020年 TIMESCAPE. All rights reserved.
//

import UIKit
import Photos

open class NXAssetsViewController: NXViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    //配置信息
    public let wrapped = NXAsset.Wrapped()
    //导航栏中间切换相册
    public let centerView = NXButton(frame: CGRect(x: 75.0, y: NXUI.insets.top, width: NXUI.width-75.0*2, height: NXUI.topOffset-NXUI.insets.top))
    //展示图片
    public let collectionView = NXCollectionView(frame: CGRect.zero)
    //展示底部切换的按钮
    public let footerView = NXFooterView(frame: CGRect(x: 0, y: -(60+NXUI.bottomOffset), width: NXUI.width, height: 60+NXUI.bottomOffset))
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.centerView.setTitle("我的相册", for: .normal)
        self.centerView.setImage(NX.image(named: "navi-dropdown-arrow.png"), for: .normal)
        self.centerView.setTitleColor(NX.darkBlackColor, for: .normal)
        self.centerView.titleLabel?.font = NX.font(17, true)
        self.centerView.contentHorizontalAlignment = .center
        self.centerView.setupEvents([.touchUpInside]) {[weak self] _, _ in
            self?.dispose("navi.center", nil, nil)
        }
        self.centerView.updateAlignment(.horizontalReverse, 2)
        self.naviView.centerView = self.centerView
        self.naviView.backBar.isHidden = false
        self.naviView.backBar.updateSubviews(NX.image(named: "navi-close.png"), nil)
        
        /** 加载图片数据:
         1.创建一个串行队列：不在主队列，不回阻塞主线程。
         2.串行队列保证队列内的任务按顺序执行，即先夹在完图片数据，再刷新UI显示
         3.采用异步的方式，不影响主线程的其他操作
         */
        NX.authorization(NX.Authorize.album, DispatchQueue.main, true) {[weak self] (state) in
            if state == .authorized, let self = self {
                self.contentView.addSubview(self.animationView)
                self.animationView.startAnimating()
                DispatchQueue(label: "serialQueue", attributes: .init(rawValue: 0)).async {
                    NXAsset.outputAlbums(self.wrapped, completion: { [weak self] (albums) in
                        self?.wrapped.albums.append(contentsOf: albums)
                        
                        DispatchQueue.main.async {[weak self] in
                            self?.animationView.stopAnimating()
                            
                            if let count = self?.wrapped.albums.count, count > 0  {
                                self?.setupSubviews()
                                self?.showAlbumAssets(at: 0)
                            }
                            else{
                                NX.showToast(message: "您的相册没有图片或视频", .center, self?.contentView)
                            }
                        }
                    })
                }
            }
        }
    }
    
    open override func setupSubviews(){
        self.collectionView.frame = CGRect(x: 0, y:0 , width: self.contentView.w, height: self.contentView.h-60-NXUI.bottomOffset)
        self.collectionView.ctxs?.minimumLineSpacing = 2
        self.collectionView.ctxs?.minimumInteritemSpacing = 1
        self.collectionView.ctxs?.sectionInset = UIEdgeInsets(top: 40, left: 12, bottom: 10, right: 12)
        self.collectionView.ctxs?.scrollDirection = .vertical
        self.collectionView.ctxs?.itemSize = CGSize(width: (NXUI.width-12*2-2*3)/4, height: (NXUI.width-12*2-2*3)/4)
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = NX.backgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(NXAssetViewCell.self, forCellWithReuseIdentifier: "NXAssetViewCell")
        self.collectionView.alwaysBounceVertical = true
        self.contentView.addSubview(self.collectionView)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        
        self.footerView.frame = CGRect(x: 0, y: self.contentView.h-60-NXUI.bottomOffset, width: self.contentView.w, height: 60+NXUI.bottomOffset)
        self.footerView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.footerView.backgroundColor = NX.backgroundColor
        self.footerView.lhsView.frame = CGRect(x: 15, y: 12, width: 144, height: 36)
        self.footerView.lhsView.setTitleColor(NX.mainColor, for: .normal)
        self.footerView.lhsView.titleLabel?.font = NX.font(16, false)
        self.footerView.lhsView.contentHorizontalAlignment = .left
        self.footerView.lhsView.isHidden = !(self.wrapped.outputUIImage && self.wrapped.footer.lhs == false)
        self.footerView.lhsView.setTitle("预览(0)", for: .normal)
        self.footerView.lhsView.setupEvents([.touchUpInside], action: {[weak self] (e, v) in
            self?.dispose("footer.lhs", nil)
        })
        
        self.footerView.centerView.frame = CGRect(x: (footerView.w-50)/2, y: 5, width: 50, height: 50)
        self.footerView.centerView.isHidden = self.wrapped.footer.center
        self.footerView.centerView.setImage(NX.image(named: "icon-camera.png"), for: .normal)
        self.footerView.centerView.setupEvents([.touchUpInside], action: {[weak self] (e, v) in
            self?.dispose("footer.center", nil)
        })
        
        self.footerView.rhsView.frame = CGRect(x: NXUI.width-15-88, y: 12, width: 88, height: 36)
        self.footerView.rhsView.layer.cornerRadius = 18
        self.footerView.rhsView.layer.masksToBounds = true
        self.footerView.rhsView.setTitleColor(UIColor.white, for: .normal)
        self.footerView.rhsView.setBackgroundImage(UIImage.image(color: NX.mainColor), for: .normal)
        self.footerView.rhsView.titleLabel?.font = NX.font(15, false)
        self.footerView.rhsView.isHidden = self.wrapped.footer.rhs
        self.footerView.rhsView.setTitle("完成(0/\(self.wrapped.output.maxOfAssets))", for: .normal)
        self.footerView.rhsView.setupEvents([.touchUpInside], action: {[weak self] (e, v) in
            self?.dispose("footer.rhs", nil)
        })
        self.contentView.addSubview(self.footerView)
        
        self.dispose("subcomponents", nil)
    }
    
    open override func updateSubviews(_ action:String, _ value: Any?){
        guard let value = value as? [String:Any], let album = value["album"] as? NXAlbum else {
            return
        }
        
        self.centerView.setTitle(album.title.value, for: .normal)
        self.centerView.updateAlignment(.horizontalReverse, 2)
                
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset.top = 12
        }
    }
    
    open override func dispose(_ action: String, _ value: Any?, _ completion: NX.Completion<String, Any?>? = nil) {
        if action == "navi.center" {
            NXActionView.action(actions: self.wrapped.albums, header: (.header(false, false, true, true), "请选择相册"), footer: (.whitespace, ""), initialize: nil) { (_, index) in
                guard index != self.ctxs.x else {
                    return;
                }
                self.ctxs.x = index
                self.showAlbumAssets(at: index)
            }
        }
        else if action == "footer.lhs" {
            if self.wrapped.outputUIImage {
                if self.wrapped.output.assets.count == 0 {
                    NX.showToast(message: "请选择图片或视频后再预览哦", .center, self.contentView)
                    return;
                }
                
                if wrapped.isOutputting {
                    return;
                }
                wrapped.isOutputting = true
                
                NXAsset.outputAssets(self.wrapped) {[weak self] (assets, outputs) in
                    self?.wrapped.isOutputting = false
                    NX.previewAssets(type: "UIImage", assets: outputs)
                }
            }
            else{
                NX.showToast(message: "不支持图片预览哦", .center, self.contentView)
                return;
            }
        }
        else if action == "footer.center" {
            
            NX.authorization(NX.Authorize.camera, DispatchQueue.main, true) {[weak self] (status) in
                if status == .authorized, let self = self {
                    let picker = UIImagePickerController()
                    picker.allowsEditing = false
                    picker.delegate = self
                    picker.sourceType = .camera
                    picker.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(picker, animated: true, completion: nil)
                }
            }
        }
        else if action == "footer.rhs" {
            if self.wrapped.output.assets.count < self.wrapped.output.minOfAssets {
                if self.wrapped.output.image.minOfAssets > 0 {
                    NX.showToast(message: "请至少选择\(self.wrapped.output.image.minOfAssets)张图片", .center, self.contentView)
                }
                else if self.wrapped.output.video.minOfAssets > 0 {
                    NX.showToast(message: "请至少选择\(self.wrapped.output.video.minOfAssets)个视频", .center, self.contentView)
                }
                return
            }
            
            if wrapped.outputUIImage {
                if wrapped.isOutputting {
                    return;
                }
                wrapped.isOutputting = true
                
                NXAsset.outputAssets(self.wrapped, completion:{[weak self] (_, assets:[NXAsset]) in
                    guard let self = self else {
                        return
                    }
                    self.wrapped.isOutputting = false
                    
                    if assets.count == 1 && self.wrapped.clips.count >= 1, let image = assets.first?.image  {
                        let vc = NXAssetClipViewController()
                        vc.image = image
                        vc.clips.is = 0
                        vc.clips.value = self.wrapped.clips
                        vc.ctxs.completion = { [weak self] (_, outputUIImage) in
                            guard let self = self else {
                                return
                            }
                            if let o = outputUIImage as? UIImage {
                                assets.first?.image = o
                            }
                            NXAsset.Wrapped.dispose(self.wrapped, assets: assets)
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        NXAsset.Wrapped.dispose(self.wrapped, assets: assets)
                    }
                })
            }
            else {
                NXAsset.Wrapped.dispose(self.wrapped, assets: self.wrapped.output.assets)
            }
        }
        else if action == "subcomponents" {
            self.footerView.lhsView.setTitle("预览(\(self.wrapped.output.assets.count))", for: .normal)
            var __description = "完成(0/\(self.wrapped.output.maxOfAssets))"
            if self.wrapped.isMixable {
                __description = "完成(\(self.wrapped.output.assets.count)/\(self.wrapped.output.maxOfAssets))"
            }
            else {
                if self.wrapped.output.image.assets.count > 0 {
                    __description = "完成(\(self.wrapped.output.assets.count)/\(self.wrapped.output.image.maxOfAssets))"
                }
                else if self.wrapped.output.video.assets.count > 0 {
                    __description = "完成(\(self.wrapped.output.assets.count)/\(self.wrapped.output.video.maxOfAssets))"
                }
            }
            var __size = String.size(of: __description, size: CGSize(width: 200, height: 36), font: NX.font(15))
            __size.width = __size.width + 24
            __size.height = 36
            self.footerView.rhsView.frame = CGRect(x: NXUI.width-15-__size.width, y: 12, width: __size.width, height: __size.height)
            self.footerView.rhsView.setTitle(__description, for: .normal)
        }
    }
    
    @objc override open func backBarAction() {
        NXAsset.Wrapped.close(self.wrapped)
    }
    
    public func showAlbumAssets(at index: Int){
        guard index >= 0 && index < self.wrapped.albums.count else {return;}
        
        let album = self.wrapped.albums[index]
        self.wrapped.assets.removeAll()
        
        self.wrapped.assets.append(contentsOf: album.assets)
        
        self.updateSubviews("", ["album":album])
        self.collectionView.reloadData()
        
        //滚动到底部
        if self.wrapped.assets.count > 0 {
            let index = IndexPath(row: self.wrapped.assets.count-1, section: 0)
            self.collectionView.scrollToItem(at: index, at: .bottom, animated: false)
        }
    }
    
    ///UICollectionViewDelegate, UICollectionViewDataSource
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let __wrapped = self.wrapped
        let asset = __wrapped.assets[indexPath.item]
        
        if __wrapped.output.assets.contains(asset) {
            __wrapped.output.remove(asset)
            self.collectionView.reloadData()
            
            self.dispose("subcomponents", nil)
            return
        }
        
        if asset.mediaType == .image {
            if __wrapped.output.image.maxOfAssets <= 0 {
                NX.showToast(message: "不支持选择图片", .center, self.contentView)
                return
            }
            
            if __wrapped.isMixable {
                if __wrapped.output.assets.count >= __wrapped.output.maxOfAssets {
                    NX.showToast(message: "最多只能选择\(__wrapped.output.maxOfAssets)张图片和视频哦", .center, self.contentView)
                    return
                }
            }
            else {
                if __wrapped.output.video.assets.count > 0  {
                    NX.showToast(message: "不支持同时选择图片和视频", .center, self.contentView)
                    return
                }
            }
        
            if __wrapped.output.image.assets.count >= __wrapped.output.image.maxOfAssets {
                NX.showToast(message: "最多只能选择\(__wrapped.output.image.maxOfAssets)张图片哦", .center, self.contentView)
                return
            }
            
            if asset.isSelectable {
                //选择图片
                __wrapped.output.add(asset)
                self.collectionView.reloadData()
                
                //当只选择一张的时候，选择之后直接进行接下来的操作
                if __wrapped.output.image.maxOfAssets == 1 && __wrapped.output.image.assets.count == 1 && __wrapped.isMixable == false && __wrapped.isAutoclosed {
                    self.dispose("footer.rhs", nil)
                }
                self.dispose("subcomponents", nil)
            }
            else {
                NX.showToast(message: "不支持选择图片", .center, self.contentView)
            }
        }
        else if asset.mediaType == .video {
            if __wrapped.output.video.maxOfAssets <= 0 {
                NX.showToast(message: "不支持选择视频", .center, self.contentView)
                return
            }
            
            if __wrapped.isMixable {
                if __wrapped.output.assets.count >= __wrapped.output.maxOfAssets {
                    NX.showToast(message: "最多只能选择\(__wrapped.output.maxOfAssets)张图片和视频哦", .center, self.contentView)
                    return
                }
            }
            else {
                if __wrapped.output.image.assets.count > 0 {
                    NX.showToast(message: "不支持同时选择图片和视频", .center, self.contentView)
                    return
                }
            }
            
            if __wrapped.output.video.assets.count >= __wrapped.output.video.maxOfAssets {
                NX.showToast(message: "最多只能选择\(__wrapped.output.video.maxOfAssets)个视频哦", .center, self.contentView)
                return
            }
            
            if asset.isSelectable {
                
                //格式有效：检测一下如果视频超长但是又不支持裁减的话就不能选中
                if asset.duration > __wrapped.videoClipsDuration && __wrapped.videoClipsAllowed == false {
                    NX.showToast(message: "暂时只支持\(__wrapped.videoClipsDuration)秒以内的视频", .center, self.contentView)
                    return
                }
                
                //选择视频
                __wrapped.output.add(asset)
                self.collectionView.reloadData()

                if __wrapped.output.video.maxOfAssets == 1 && __wrapped.output.video.assets.count == 1 && __wrapped.isMixable == false && __wrapped.isAutoclosed {
                    self.dispose("footer.rhs", nil)
                }
                self.dispose("subcomponents", nil)
            }
            else {
                NX.showToast(message: "暂时只支持MP4格式的视频", .center, self.contentView)
            }
        }
        else if asset.mediaType == .audio {
            NX.showToast(message: "不支持选择音频哦", .center, self.contentView)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wrapped.assets.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NXAssetViewCell", for: indexPath) as! NXAssetViewCell
        let asset = self.wrapped.assets[indexPath.item]
        if self.wrapped.output.assets.contains(asset) {
            
            asset.isMaskedable = false
            asset.index = "✓"

            if asset.mediaType == .image && self.wrapped.output.image.isIndex, let index = self.wrapped.output.image.assets.firstIndex(of: asset) {
                asset.index = "\(index+1)"
            }
            else if asset.mediaType == .video && self.wrapped.output.video.isIndex, let index = self.wrapped.output.video.assets.firstIndex(of: asset) {
                asset.index = "\(index+1)"
            }
        }
        else {
            if asset.mediaType == .image {
                asset.isMaskedable = self.wrapped.output.image.assets.count >= self.wrapped.output.image.maxOfAssets
                if asset.isMaskedable == false {
                    asset.isMaskedable = self.wrapped.output.assets.count >= self.wrapped.output.maxOfAssets
                }
                if asset.isMaskedable == false && self.wrapped.isMixable == false {
                    asset.isMaskedable = self.wrapped.output.video.assets.count > 0
                }
            }
            else if asset.mediaType == .video {
                asset.isMaskedable = self.wrapped.output.video.assets.count >= self.wrapped.output.video.maxOfAssets
                if asset.isMaskedable == false {
                    asset.isMaskedable = self.wrapped.output.assets.count >= self.wrapped.output.maxOfAssets
                }
                if asset.isMaskedable == false && self.wrapped.isMixable == false {
                    asset.isMaskedable = self.wrapped.output.image.assets.count > 0
                }
            }
            else {
                asset.isMaskedable = true
            }
            asset.index = ""
        }
        cell.updateSubviews("update", asset)
        return cell
    }
}

extension NXAssetsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)

        //系统相册选图
        var image : UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let __image = image, let fixed = UIImage.fixedOrientation(image: __image) {
            image = fixed
        }
        
        if let __output = image {
            NX.showLoading("正在保存", .center, self.view)
            NXAsset.saveImage(image: __output, completion: {[weak self] (state, asset) in
                guard let self = self else {return}
                
                NX.hideLoading(superview: self.view)
                
                if let __asset = asset {
                    let leyAsset = NXAsset(asset: __asset)
                    leyAsset.image = __output
                    leyAsset.thumbnail = __output
                    
                    NXAsset.Wrapped.dispose(self.wrapped, assets: [leyAsset])
                }
                else {
                    NXAsset.Wrapped.dispose(self.wrapped, assets: [])
                }
            })
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

