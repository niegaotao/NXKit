//
//  NXAssetsViewController.swift
//  NXKit
//
//  Created by 聂高涛 on 2018/5/24.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit
import Photos

open class NXAssetsViewController: NXViewController,UICollectionViewDelegate, UICollectionViewDataSource {
    //配置信息
    public let wrapped = NXAsset.Wrapped()
    //顶部悬停过滤的
    public let filterView = NXSuspendView<UIButton>(frame: CGRect(x: 0, y: 0, width: NXDevice.width, height: 40))
    //展示图片
    public let collectionView = NXCollectionView(frame: CGRect.zero)
    //展示底部切换的按钮
    public let footerView = NXFooterView(frame: CGRect(x: 0, y: -(60+NXDevice.bottomOffset), width: NXDevice.width, height: 60+NXDevice.bottomOffset))
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        ///每次进来同步一下目标类型
        self.naviView.title = "我的相册"
        self.naviView.backBar.isHidden = false
        self.naviView.backBar.updateSubviews(NXApp.image(named: "navi_close_black.png"), nil)
        
        /** 加载图片数据:
         1.创建一个串行队列：不在主队列，不回阻塞主线程。
         2.串行队列保证队列内的任务按顺序执行，即先夹在完图片数据，再刷新UI显示
         3.采用异步的方式，不影响主线程的其他操作
         */
        NXApp.authorization(NXApp.AuthorizeType.album, DispatchQueue.main, true) {[weak self] (state) in
            if state == .authorized, let self = self {
                self.contentView.addSubview(self.animationView!)
                self.animationView?.startAnimating()
                DispatchQueue(label: "serialQueue", attributes: .init(rawValue: 0)).async {
                    NXAsset.outputAlbums(self.wrapped, completion: { [weak self] (albums) in
                        self?.wrapped.albums.append(contentsOf: albums)
                        
                        DispatchQueue.main.async {[weak self] in
                            self?.animationView?.stopAnimating()
                            
                            if let count = self?.wrapped.albums.count, count > 0  {
                                self?.setupSubviews()
                                self?.showAlbumAssets(at: 0)
                            }
                            else{
                                NXApp.showToast(message: "您的相册没有图片或视频", .center, self?.contentView)
                            }
                        }
                    })
                }
            }
        }
    }
    
    open override func setupSubviews(){
        self.collectionView.frame = CGRect(x: 0, y:0 , width: self.contentView.w, height: self.contentView.h-60-NXDevice.bottomOffset)
        self.collectionView.wrapped?.minimumLineSpacing = 2
        self.collectionView.wrapped?.minimumInteritemSpacing = 1
        self.collectionView.wrapped?.sectionInset = UIEdgeInsets(top: 40, left: 12, bottom: 10, right: 12)
        self.collectionView.wrapped?.scrollDirection = .vertical
        self.collectionView.wrapped?.itemSize = CGSize(width: (NXDevice.width-12*2-2*3)/4, height: (NXDevice.width-12*2-2*3)/4)
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = NXApp.backgroundColor
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(NXAssetViewCell.self, forCellWithReuseIdentifier: "NXAssetViewCell")
        self.collectionView.alwaysBounceVertical = true
        self.contentView.addSubview(self.collectionView)
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
        self.naviView.forwardBar = NXNaviView.Bar.forward(image: nil, title: "预览(0)", completion: {[weak self] (_) in
            self?.dispose("forward", nil)
        })
        self.naviView.forwardBar?.setTitleColor(NXApp.mainColor, for: .normal)
        self.naviView.forwardBar?.isHidden = !self.wrapped.outputUIImage
        
        self.filterView.contentView.frame = CGRect(x: 0, y: 0, width: NXDevice.width, height: 40)
        self.filterView.contentView.titleLabel?.font = NXApp.font(13, false)
        self.filterView.contentView.contentHorizontalAlignment = .center
        self.filterView.setupSeparator(color: NXApp.separatorColor, side: .bottom)
        self.filterView.contentView.setupEvents([.touchUpInside]) {[weak self] (e, v) in
            self?.dispose("filter", nil)
        }
        self.filterView.backgroundColor = NXApp.backgroundColor
        self.contentView.addSubview(self.filterView)
        self.filterView.updateSubviews("", false)
        
        self.footerView.frame = CGRect(x: 0, y: self.contentView.h-60-NXDevice.bottomOffset, width: self.contentView.w, height: 60+NXDevice.bottomOffset)
        self.footerView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        self.footerView.backgroundColor = NXApp.backgroundColor
        self.footerView.lhsView.frame = CGRect(x: 15, y: 12, width: 144, height: 36)
        self.footerView.lhsView.setTitleColor(NXApp.darkBlackColor, for: .normal)
        self.footerView.lhsView.titleLabel?.font = NXApp.font(16, false)
        self.footerView.lhsView.contentHorizontalAlignment = .left
        self.footerView.lhsView.isHidden = self.wrapped.footer.lhs
        self.footerView.lhsView.setTitle("我的相册", for: .normal)
        self.footerView.lhsView.setupEvents([.touchUpInside], action: {[weak self] (e, v) in
            self?.dispose("footer.lhs", nil)
        })
        
        self.footerView.centerView.frame = CGRect(x: (footerView.w-50)/2, y: 5, width: 50, height: 50)
        self.footerView.centerView.isHidden = self.wrapped.footer.center
        self.footerView.centerView.setImage(UIImage(named: "rrxc_camera.png"), for: .normal)
        self.footerView.centerView.setupEvents([.touchUpInside], action: {[weak self] (e, v) in
            self?.dispose("footer.center", nil)
        })
        
        self.footerView.rhsView.frame = CGRect(x: NXDevice.width-15-88, y: 12, width: 88, height: 36)
        self.footerView.rhsView.layer.cornerRadius = 18
        self.footerView.rhsView.layer.masksToBounds = true
        self.footerView.rhsView.setTitleColor(UIColor.white, for: .normal)
        self.footerView.rhsView.setBackgroundImage(UIImage.image(color: NXApp.mainColor), for: .normal)
        self.footerView.rhsView.titleLabel?.font = NXApp.font(15, false)
        self.footerView.rhsView.isHidden = self.wrapped.footer.rhs
        self.footerView.rhsView.setTitle("完成(0/\(self.wrapped.output.maxOfAssets))", for: .normal)
        self.footerView.rhsView.setupEvents([.touchUpInside], action: {[weak self] (e, v) in
            self?.dispose("footer.rhs", nil)
        })
        self.contentView.addSubview(self.footerView)
        
        self.dispose("subcomponents", nil)
    }
    
    open override func updateSubviews(_ action:String, _ value: [String:Any]?){
        guard let album = value?["album"] as? NXAlbum else {
            return
        }
        self.naviView.title = album.title.value
        self.footerView.lhsView.setTitle(album.title.value + " ▼", for: .normal)
        
        if album.isBlockable {
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset.top = 40
            }

            var prefix = "\(album.assets.count-album.finalAssets.count)张图已经发布过，已为您智能隐藏 "
            var subfix = "全部显示"
            if !album.isBlocked {
                prefix = "\(album.assets.count-album.finalAssets.count)张图已经发布过，已为您全部显示 "
                subfix = "智能隐藏"
            }
            let attris = NSMutableAttributedString(string: prefix+subfix)
            attris.setAttributes([NSAttributedString.Key.font:NXApp.font(13, false)], range: NSRange(location: 0, length: prefix.count+subfix.count))
            attris.setAttributes([NSAttributedString.Key.foregroundColor:NXApp.darkGrayColor], range: NSRange(location: 0, length: prefix.count))
            attris.setAttributes([NSAttributedString.Key.foregroundColor:NXApp.mainColor], range: NSRange(location: prefix.count, length: subfix.count))
            self.filterView.contentView.setAttributedTitle(attris, for: .normal)
            
            
            DispatchQueue.main.after(time: .now()+0.2) {[weak self] in
                self?.filterView.updateSubviews("animation", true)
            }
        }
        else{
            self.filterView.updateSubviews("", false)
            if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.sectionInset.top = 12
            }
        }
    }
    
    open override func dispose(_ action: String, _ value: Any?, _ completion: NXApp.Completion<String, Any?>? = nil) {
        if action == "footer.lhs" {
            NXActionView.action(options: self.wrapped.albums, header: (.components(false, true, true, false), "请选择相册"), footer: (.whitespace, "")) { (_, index) in
                guard index != self.ctxs.index else {
                    return;
                }
                self.ctxs.index = index
                self.showAlbumAssets(at: index)
            }
        }
        else if action == "footer.center" {
            self.openCamera()
        }
        else if action == "footer.rhs" {
            if self.wrapped.output.assets.count < self.wrapped.output.minOfAssets {
                if self.wrapped.output.image.minOfAssets > 0 {
                    NXApp.showToast(message: "请至少选择\(self.wrapped.output.image.minOfAssets)张图片", .center, self.contentView)
                }
                else if self.wrapped.output.video.minOfAssets > 0 {
                    NXApp.showToast(message: "请至少选择\(self.wrapped.output.video.minOfAssets)个视频", .center, self.contentView)
                }
                return
            }
            
            if wrapped.outputUIImage {
                if wrapped.output.isOutputting {
                    return;
                }
                wrapped.output.isOutputting = true
                
                NXAsset.outputAssets(self.wrapped, completion:{[weak self] (_, assets:[NXAsset]) in
                    guard let self = self else {
                        return
                    }
                    self.wrapped.output.isOutputting = false
                    
                    if assets.count == 1 && self.wrapped.imageClips.count >= 1, let image = assets.first?.image  {
                        let vc = NXAssetClipImageViewController()
                        vc.image = image
                        vc.clips.index = 0
                        vc.clips.value = self.wrapped.imageClips
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
        else if action == "forward" {
            if self.wrapped.outputUIImage {
                if self.wrapped.output.assets.count == 0 {
                    NXApp.showToast(message: "请选择图片或视频后再预览哦", .center, self.contentView)
                    return;
                }
                
                if wrapped.output.isOutputting {
                    return;
                }
                wrapped.output.isOutputting = true
                
                NXAsset.outputAssets(self.wrapped) {[weak self] (assets, outputs) in
                    self?.wrapped.output.isOutputting = false
                    NXApp.showAssets(type: "UIImage", assets: outputs)
                }
            }
            else{
                NXApp.showToast(message: "不支持图片预览哦", .center, self.contentView)
                return;
            }
        }
        else if action == "filter" {
            if self.ctxs.index < self.wrapped.albums.count {
                let album = self.wrapped.albums[self.ctxs.index]
                if album.isBlockable {
                    album.isBlocked = !album.isBlocked
                    self.showAlbumAssets(at: self.ctxs.index)
                }
            }
        }
        else if action == "subcomponents" {
            self.naviView.forwardBar?.setTitle("预览(\(self.wrapped.output.assets.count))", for: .normal)
            var __description = "完成(0/\(self.wrapped.output.maxOfAssets))"
            if self.wrapped.output.isMixable {
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
            var __size = String.size(of: __description, size: CGSize(width: 200, height: 36), font: NXApp.font(15))
            __size.width = __size.width + 24
            __size.height = 36
            self.footerView.rhsView.frame = CGRect(x: NXDevice.width-15-__size.width, y: 12, width: __size.width, height: __size.height)
            self.footerView.rhsView.setTitle(__description, for: .normal)
        }
    }
    
    @objc override open func backBarAction() {
        NXAsset.Wrapped.close(self.wrapped)
    }
    
    public func showAlbumAssets(at index: Int){
        self.filterView.updateSubviews("", false)
        guard index >= 0 && index < self.wrapped.albums.count else {return;}
        
        let album = self.wrapped.albums[index]
        self.wrapped.assets.removeAll()
        
        if album.isBlockable {
            if album.isBlocked {
                if album.assets.count > 0 {
                    self.wrapped.assets.append(contentsOf: album.finalAssets)
                }
            }
            else{
                if album.assets.count > 0 {
                    self.wrapped.assets.append(contentsOf: album.assets)
                }
            }
        }
        else{
            self.wrapped.assets.append(contentsOf: album.assets)
        }
        
        
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
                NXApp.showToast(message: "不支持选择图片", .center, self.contentView)
                return
            }
            
            if __wrapped.output.isMixable {
                if __wrapped.output.assets.count >= __wrapped.output.maxOfAssets {
                    NXApp.showToast(message: "最多只能选择\(__wrapped.output.maxOfAssets)张图片和视频哦", .center, self.contentView)
                    return
                }
            }
            else {
                if __wrapped.output.video.assets.count > 0  {
                    NXApp.showToast(message: "不支持同时选择图片和视频", .center, self.contentView)
                    return
                }
            }
        
            if __wrapped.output.image.assets.count >= __wrapped.output.image.maxOfAssets {
                NXApp.showToast(message: "最多只能选择\(__wrapped.output.image.maxOfAssets)张图片哦", .center, self.contentView)
                return
            }
            
            if asset.isSelectable {
                //选择图片
                __wrapped.output.add(asset)
                self.collectionView.reloadData()
                
                //当只选择一张的时候，选择之后直接进行接下来的操作
                if __wrapped.output.image.maxOfAssets == 1 && __wrapped.output.image.assets.count == 1 && __wrapped.output.isMixable == false && __wrapped.output.isAutoclosed {
                    self.dispose("footer.rhs", nil)
                }
                self.dispose("subcomponents", nil)
            }
            else {
                NXApp.showToast(message: "不支持选择图片", .center, self.contentView)
            }
        }
        else if asset.mediaType == .video {
            if __wrapped.output.video.maxOfAssets <= 0 {
                NXApp.showToast(message: "不支持选择视频", .center, self.contentView)
                return
            }
            
            if __wrapped.output.isMixable {
                if __wrapped.output.assets.count >= __wrapped.output.maxOfAssets {
                    NXApp.showToast(message: "最多只能选择\(__wrapped.output.maxOfAssets)张图片和视频哦", .center, self.contentView)
                    return
                }
            }
            else {
                if __wrapped.output.image.assets.count > 0 {
                    NXApp.showToast(message: "不支持同时选择图片和视频", .center, self.contentView)
                    return
                }
            }
            
            if __wrapped.output.video.assets.count >= __wrapped.output.video.maxOfAssets {
                NXApp.showToast(message: "最多只能选择\(__wrapped.output.video.maxOfAssets)个视频哦", .center, self.contentView)
                return
            }
            
            if asset.isSelectable {
                
                //格式有效：检测一下如果视频超长但是又不支持裁减的话就不能选中
                if asset.duration > __wrapped.videoClipsDuration && __wrapped.videoClipsAllowed == false {
                    NXApp.showToast(message: "暂时只支持\(__wrapped.videoClipsDuration)秒以内的视频", .center, self.contentView)
                    return
                }
                
                //选择视频
                __wrapped.output.add(asset)
                self.collectionView.reloadData()

                if __wrapped.output.video.maxOfAssets == 1 && __wrapped.output.video.assets.count == 1 && __wrapped.output.isMixable == false && __wrapped.output.isAutoclosed {
                    self.dispose("footer.rhs", nil)
                }
                self.dispose("subcomponents", nil)
            }
            else {
                NXApp.showToast(message: "暂时只支持MP4格式的视频", .center, self.contentView)
            }
        }
        else if asset.mediaType == .audio {
            NXApp.showToast(message: "不支持选择音频哦", .center, self.contentView)
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
                if asset.isMaskedable == false && self.wrapped.output.isMixable == false {
                    asset.isMaskedable = self.wrapped.output.video.assets.count > 0
                }
            }
            else if asset.mediaType == .video {
                asset.isMaskedable = self.wrapped.output.video.assets.count >= self.wrapped.output.video.maxOfAssets
                if asset.isMaskedable == false {
                    asset.isMaskedable = self.wrapped.output.assets.count >= self.wrapped.output.maxOfAssets
                }
                if asset.isMaskedable == false && self.wrapped.output.isMixable == false {
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if self.wrapped.albums[self.ctxs.index].isBlockable {
                self.filterView.updateSubviews("animation", false)
            }
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if self.wrapped.albums[self.ctxs.index].isBlockable {
                self.filterView.updateSubviews("animation", true)
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if self.wrapped.albums[self.ctxs.index].isBlockable {
                self.filterView.updateSubviews("animation", true)
            }
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.collectionView {
            if self.wrapped.albums[self.ctxs.index].isBlockable {
                self.filterView.updateSubviews("animation", true)
            }
        }
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            if self.wrapped.albums[self.ctxs.index].isBlockable {
                self.filterView.updateSubviews("animation", true)
            }
        }
    }
}

extension NXAssetsViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera(){
        
        NXApp.authorization(NXApp.AuthorizeType.camera, DispatchQueue.main, true) {[weak self] (status) in
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
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: false, completion: nil)

        //系统相册选图
        var image : UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let __image = image, let fixed = UIImage.fixedOrientation(image: __image) {
            image = fixed
        }
        
        if let __output = image {
            NXApp.showAnimation("正在保存", self.view)
            NXAsset.saveImage(image: __output, completion: {[weak self] (state, asset) in
                guard let self = self else {return}
                
                NXApp.hideAnimation(superview: self.view)
                
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

