//
//  NXAsset.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/17.
//  Copyright (c) 2021 niegaotao. All rights reserved.
//

import UIKit
import Photos

open class NXAsset: NXAny {
    open var value = [String:Any]()
    
    open var mediaType = PHAssetMediaType.unknown//类型
    open var size : CGSize = CGSize.zero //宽度高度
    open var url : String = ""
    open var file : String = ""
    
    open var asset : PHAsset? = nil
    open var duration: TimeInterval = 0 //时长
    
    open var filename : String = "" //文件名
    open var isBlocked : Bool = false //是否在历史记录中
    open var isSelectable: Bool = false //是否可选择
    open var isMaskedable : Bool = false //是否添加覆盖层
    open var thumbnail : UIImage? = nil //点选显示的缩略图
    open var image : UIImage? = nil //输出的image
    open var index : String = ""
    
    
    public required init() {
        super.init()
    }
    
    convenience public init(asset: PHAsset?, suffixes:[String] = []) {
        self.init()
        
        if let __asset = asset {
            self.asset = __asset
            self.mediaType = __asset.mediaType
            
            self.size = CGSize(width: __asset.pixelWidth, height: __asset.pixelHeight)
            self.duration = __asset.duration
            self.filename = NX.get(string: __asset.value(forKey: "filename") as? String, "")
            
            if __asset.mediaType == .video {
                if suffixes.count > 0 {
                    let __filename = self.filename.lowercased()
                    self.isSelectable = suffixes.contains { (suffix) -> Bool in
                        return __filename.hasSuffix(suffix)
                    }
                }
                else {
                    self.isSelectable = true
                }
            }
            else if __asset.mediaType == .image {
                self.isSelectable = true
            }
            else {
                self.isSelectable = true
            }
        }
    }
    
    open var completion: NX.Event<Bool, Any?>? = nil
}


open class NXAlbumAssetViewCell: NXCollectionViewCell {
    public let assetView = UIImageView(frame: CGRect.zero) //显示图片或者视频的封面
    public let durationView = UILabel(frame: CGRect.zero) //显示视频时长
    public let selectionView = UIButton(frame: CGRect.zero)//选中取消选中的按钮
    public let indexView = UILabel(frame: CGRect.zero)  //显示选中和非选中的按钮
    public let maskedView = UIView(frame: CGRect.zero)  //遮罩
    
    open override func setupSubviews() {
        clipsToBounds = true
        
        assetView.frame = contentView.bounds
        assetView.contentMode = .scaleAspectFill
        contentView.addSubview(assetView)
        
        durationView.textAlignment = .right
        durationView.textColor = UIColor.white
        durationView.font = NX.font(12, .regular)
        durationView.isHidden = true
        contentView.addSubview(durationView)
        
        selectionView.setupEvent(.touchUpInside) {[weak self] event, sender in
            if let self = self, let asset = self.value as? NXAsset {
                asset.completion?(true, asset)
            }
        }
        contentView.addSubview(selectionView)
        
        indexView.layer.cornerRadius = 11.5
        indexView.layer.masksToBounds = true
        indexView.textColor = UIColor.white
        indexView.font = NX.font(13, .bold)
        indexView.layer.borderWidth = 1.5
        indexView.textAlignment = .center
        indexView.isUserInteractionEnabled = false
        contentView.addSubview(indexView)
        
        maskedView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        contentView.addSubview(maskedView)
    }
    
    open override func updateSubviews(_ action: String, _ value: Any?){
        guard let asset = value as? NXAsset, let phasset = asset.asset else {
            return
        }
        self.value = asset
        
        if let __thumbnail = asset.thumbnail {
            self.assetView.image = __thumbnail
        }
        else{
            PHCachingImageManager.default().requestImage(for: phasset,
                                                            targetSize: NXAsset.Wrapped.size,
                                                         contentMode: .aspectFill,
                                                         options: nil) {[weak self](image, info) in
                                                            asset.thumbnail = image
                                                            self?.assetView.image = image
            }
        }
        
        if asset.mediaType == .image {
            durationView.isHidden = true
        }
        else if asset.mediaType == .video {
            durationView.isHidden = false
            let minute : Int = Int(floor(phasset.duration/60))
            let second : Int = Int(phasset.duration - Double(minute * 60))
            durationView.text = String(format: "%02d'%02d\"", arguments:[minute,second])
        }
        else if asset.mediaType == .audio {
            
        }
        
        if asset.isMaskedable {
            indexView.isHidden = true

            maskedView.isHidden = false
        }
        else {
            indexView.isHidden = false
            if asset.index.isEmpty {
                indexView.text = ""
                indexView.backgroundColor = UIColor.clear
                indexView.layer.borderColor = UIColor.white.cgColor
            }
            else {
                indexView.text = asset.index
                indexView.backgroundColor = NX.mainColor
                indexView.layer.borderColor = NX.mainColor.cgColor
            }
            maskedView.isHidden = true
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        assetView.frame = contentView.bounds
        durationView.frame = CGRect(x: 4, y: contentView.height-22, width: contentView.width-8, height: 22)
        selectionView.frame = CGRect(x: contentView.width-40, y: 0, width: 40, height: 40)
        indexView.frame = CGRect(x: contentView.width-23-5, y: 5, width: 23, height: 23)
        maskedView.frame = contentView.bounds
    }
}

extension NXAsset {
    //选择的记录
    open class Preset : NXAny {
        open var isIndex = true
        open var minOfAssets : Int = 0
        open var maxOfAssets : Int = 0
        open var assets = [NXAsset]()
        open var suffixes = [String]()
    }
    
    //回调部分的结构
    open class Output : Preset {
        open weak var contentViewController : NXViewController? = nil
        open var image = NXAsset.Preset()
        open var video = NXAsset.Preset()
        open var audio = NXAsset.Preset()

        open func add(_ value:NXAsset) {
            if value.mediaType == .image {
                self.assets.append(value)
                self.image.assets.append(value)
            }
            else if value.mediaType == .video {
                self.assets.append(value)
                self.video.assets.append(value)
            }
        }
        
        open func remove(_ value:NXAsset) {
            if value.mediaType == .image {
                self.assets.removeAll { (loopValue) -> Bool in return loopValue == value }
                self.image.assets.removeAll { (loopValue) -> Bool in return loopValue == value }
            }
            else if value.mediaType == .video {
                self.assets.removeAll { (loopValue) -> Bool in return loopValue == value }
                self.video.assets.removeAll { (loopValue) -> Bool in return loopValue == value }
            }
        }
        
        public required init() {
            super.init()
            self.image.suffixes = []
            self.video.suffixes = [".mp4", ".mov"]
        }
        
        //图片相关，导出封面图相关
        open var isMixable = false
        open var clips = [NXClip]()//具体的宽高比例
        open var duration : TimeInterval = 0.0//最大视频时长，0表示无限制
        open var resize = CGSize(width: 1920, height: 1920)//导出尺寸
        open var resizeBy = NXClip.side//导出size计算方法
        open var isOutputable = true //是否需要导出UIImage
        open var isOutputting  = false //是否正在导出UIImage
    }
    
    open class Wrapped : Output {
        //创建相册信号量
        public static var semaphore = DispatchSemaphore(value: 1)
        //缩略图尺寸
        public static var size = CGSize(width: Int(NX.width/4.0 * CGFloat(UIScreen.main.scale)), height: Int(NX.width/4.0 * CGFloat(UIScreen.main.scale)))

        //支持展示的媒体类型
        open var mediaType = PHAssetMediaType.unknown
        //本次已经选择的资源
        open var identifiers = [String]()
        //全部相册（视频的会合并到一个相册中）
        open var albums = [NXAlbum]()
        //当前展示的是第几个相册
        open var index = -1
        //预览的资源文件
        open var previewAssets = [NXAsset]()
        //本次已经选择的资源
        open var selectedIdentifiers = [String]()
        open var isAutoclosed = true //当选择一张的时候，选择之后是否自动回电
        open var numberOfColumns = 4 //列表显示多少列,允许[1,2],推荐[3,4,5],允许[6,7]
        open var completion : NX.Event<Bool, NXAsset.Output>? = nil//最后的回调
        
        //操作按钮
        open var subviews : (preview:Bool, camera:Bool, output:Bool) = (false, false, false)
        
        //处理数据
        public func close(assets:[NXAsset]){
            let output = NXAsset.Output()
            output.assets = assets
            output.contentViewController = self.contentViewController
            self.completion?(true, output)
        }
        
        public required init() {
            super.init()
        }
    }
    
    open class Observer : NSObject, PHPhotoLibraryChangeObserver {
        open var completion : NX.Event<String, Any?>? = nil//最后的回调
        public override init() {
            super.init()
            self.register()
        }
        
        public func register(){
            if #available(iOS 14.0, *) {
                PHPhotoLibrary.shared().register(self)
            }
        }
        
        public func unregister(){
            if #available(iOS 14.0, *) {
                PHPhotoLibrary.shared().unregisterChangeObserver(self)
            }
            self.completion = nil
        }
        
        public func photoLibraryDidChange(_ changeInstance: PHChange) {
            DispatchQueue.main.async {
                self.completion?("photoLibraryDidChange", nil)
            }
        }
    }
}


extension NXAsset {
    //打开相册
    public class func album(open: NX.Event<Bool, NXAlbumViewController>?,
                          completion: NX.Event<Bool, NXAsset.Output>?) {
        NX.authorization(NX.Authorize.album, DispatchQueue.main, true, { state in
            guard state == NX.AuthorizeState.authorized else {return}

            let __wrapped = NXAlbumViewController()
            __wrapped.modalPresentationStyle = .fullScreen
            __wrapped.wrapped.minOfAssets = 1
            __wrapped.wrapped.maxOfAssets = 9
            __wrapped.wrapped.image.minOfAssets = 1
            __wrapped.wrapped.image.maxOfAssets = 9
            __wrapped.wrapped.image.isIndex = true
            __wrapped.wrapped.video.minOfAssets = 0
            __wrapped.wrapped.video.maxOfAssets = 0
            __wrapped.wrapped.video.isIndex = true
            __wrapped.wrapped.video.suffixes = [".mp4",".mov"]
            __wrapped.wrapped.duration = 0
            __wrapped.wrapped.isMixable = false
            __wrapped.wrapped.mediaType = .image
            __wrapped.wrapped.selectedIdentifiers = []
            __wrapped.wrapped.isOutputable = true
            __wrapped.wrapped.clips = []
            __wrapped.wrapped.subviews = (false, true, false)////底部按钮
            __wrapped.wrapped.contentViewController = __wrapped
            __wrapped.wrapped.completion = completion
            open?(true, __wrapped)
        })
    }
    
    //打开相机
    public class func camera(open:NX.Event<Bool, NXCameraViewController>?,
                         completion:NX.Event<Bool, NXAsset.Output>?) {
        NX.authorization(NX.Authorize.camera, DispatchQueue.main, true, {(state) in
            guard state == NX.AuthorizeState.authorized else {return}
            
            let __wrapped = NXCameraViewController()
            __wrapped.modalPresentationStyle = .fullScreen
            __wrapped.view.backgroundColor = .black
            __wrapped.naviView.isHidden = true
            __wrapped.contentView.backgroundColor = .black
            __wrapped.viewController.view.backgroundColor = .black
            __wrapped.viewController.setNavigationBarHidden(true, animated: false)
            __wrapped.viewController.sourceType = .camera
            __wrapped.viewController.delegate = __wrapped.viewController
            __wrapped.viewController.modalPresentationStyle = .fullScreen
            __wrapped.wrapped.contentViewController = __wrapped
            __wrapped.wrapped.completion = completion
            open?(true, __wrapped)
        })
    }
}


extension NXAsset {
    //这个地方存在同时创建多个同名相册的情况:采用信号量的方案来解决
    public class func fetchCollection(name: String, queue:DispatchQueue, autocreate:Bool, completion:@escaping ((_ album:PHAssetCollection?) -> ())){
        if name.count == 0 {
            //指定的相册名称为空，则保存到相机胶卷
            let albums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
            queue.async {
                completion(albums.firstObject)
            }
        }
        else {
            //有指定的相册名称则需要去查找对应的名称的相册
            NXAsset.Wrapped.semaphore.wait()
            //指定的相册名称不为空，看保存的指定相册文件夹是否存在
            var assetAlbum: PHAssetCollection?
            
            let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
            for index in 0 ..< collections.count {
                let collection = collections[index]
                if collection.localizedTitle == name {
                    assetAlbum = collection
                    break
                }
            }
            
            if let __assetAlbum = assetAlbum {
                //存在，获取置顶相册路径
                queue.async {
                    completion(__assetAlbum)
                }
                NXAsset.Wrapped.semaphore.signal()
            }
            else{
                //不存在的话
                if autocreate {
                    //不存在的话则创建该相册
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
                    }, completionHandler: { (_, _) in
                        
                        //获取一次新创建的相册
                        let collections = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
                        for index in 0 ..< collections.count {
                            let collection = collections[index]
                            if collection.localizedTitle == name {
                                assetAlbum = collection
                                break
                            }
                        }
                        
                        //创建之后再获取一次自定义相册，不管存不存在都返回
                        queue.async {
                            completion(assetAlbum)
                        }
                        NXAsset.Wrapped.semaphore.signal()
                    })
                }
                else {
                    //不允许创建的话直接返回了
                    queue.async {
                        completion(nil)
                    }
                    NXAsset.Wrapped.semaphore.signal()
                }
            }
        }
    }
    
    //保存图片到相册
    public class func saveImage(image: UIImage, name: String = NX.name, queue:DispatchQueue = DispatchQueue.main, completion: ((_ isCompleted: Bool, _ asset:PHAsset?) -> ())?) {
        NXAsset.save(assets: [image], name: name, queue:queue, completion:{ (state, assets) in
            completion?(state, assets.first)
        })
    }
    
    //保存视频到相册
    public class func saveVideo(fileURL:URL, name: String = NX.name, queue:DispatchQueue = DispatchQueue.main, completion: ((_ isCompleted: Bool, _ asset:PHAsset?) -> ())?){
        NXAsset.save(assets: [fileURL], name: name, queue:queue, completion:{ (state, assets) in
            completion?(state, assets.first)
        })
    }
    
    //保存视频/图片到系统相册
    public class func save(assets:[Any], name: String, queue:DispatchQueue, completion: ((_ isCompleted: Bool, _ assets:[PHAsset]) -> ())?) {
        //相册授权
        NX.authorization(.album, queue, false) { (status) in
            guard status == .authorized else {
                queue.async {
                    completion?(false, [])
                }
                return
            }
            
            //获取目标相册
            NXAsset.fetchCollection(name:name, queue:queue, autocreate:true, completion: { (album) in
                
                guard let album = album else {
                    queue.async {
                        completion?(false, [])
                    }
                    return
                }
                
                //ID
                var __assetIdentifiers = [String]()
                var __assetPlaceholders = [PHObjectPlaceholder]()
                
                
                PHPhotoLibrary.shared().performChanges({
                    
                    for asset in assets {
                        if let image = asset as? UIImage {
                            //保存图片
                            let result = PHAssetChangeRequest.creationRequestForAsset(from: image)
                            if let assetPlaceholder = result.placeholderForCreatedAsset {
                                __assetIdentifiers.append(assetPlaceholder.localIdentifier)
                                __assetPlaceholders.append(assetPlaceholder)
                            }
                        }
                        else if let url = asset as? URL {
                            //保存视频
                            let result = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
                            if let assetPlaceholder = result?.placeholderForCreatedAsset {
                                __assetIdentifiers.append(assetPlaceholder.localIdentifier)
                                __assetPlaceholders.append(assetPlaceholder)
                            }
                        }
                        
                        if let request = PHAssetCollectionChangeRequest(for: album) {
                            request.addAssets(__assetPlaceholders as NSArray)
                        }
                    }
                    
                }, completionHandler: {(isSucceed: Bool, error: Error?) in
                    
                    var __assets = [PHAsset]()
                    let __fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: __assetIdentifiers, options: nil)
                    for index in 0 ..< __fetchResult.count {
                        __assets.append(__fetchResult[index])
                    }
                    queue.async {
                       completion?(true, __assets)
                    }
                })
            })
        }
    }
}


extension NXAsset {
    //获取所有的相册列表
    public class func outputAlbums(_ wrapped: NXAsset.Wrapped, completion: NX.Event<Bool, [NXAlbum]>?) {
        
        var accessAlbums = [NXAlbum]()
        
        let options = PHFetchOptions()
        //options.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: true)]
        if wrapped.mediaType != .unknown {
            //当外部传入了具体类型(.image, .auduo, .video)的时候做过滤操作
            options.predicate = NSPredicate(format: "mediaType = %d", wrapped.mediaType.rawValue)
        }
        
        //用户自己创建的相册：美颜相机，QQ空间、百度网盘、Alciade、微博、重要文件、抖音、QQ、今日头条、拼图大师、NXKit-Example、简书
        let __albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        //系统创建的相册：最近项目、个人收藏、视频、自拍、实况照片、人像、长曝光、全景照片、延时摄影、慢动作、连拍快照、截屏、动图、RAW、已隐藏、无法上传
        let __smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        
        if let fetchResults = [__albums, __smartAlbums] as? [PHFetchResult<AnyObject>] {
            for fetchResult in fetchResults {
                for index in 0 ..< fetchResult.count {
                    
                    //有可能是PHCollectionList的对象，过滤掉
                    guard let collection  = fetchResult[index] as? PHAssetCollection else {continue}
                               
                    //无照片相册,过滤掉
                    if let fetchResult = (PHAsset.fetchAssets(in: collection, options: options) as? PHFetchResult<AnyObject>), fetchResult.count > 0 {
                        
                        let album = NXAlbum(title: collection.localizedTitle ?? "相册", fetchResult: fetchResult, wrapped:wrapped)
                        if album.assets.count > 0 {
                            accessAlbums.append(album)
                        }
                    }
                }
            }
        }
        
        accessAlbums.sort { (lhs, rhs) -> Bool in
            return lhs.assets.count > rhs.assets.count
        }
        
        if wrapped.selectedIdentifiers.count > 0, let album = accessAlbums.first {
            let filterAssets = album.assets.filter { (asset) -> Bool in
                if let __phasset = asset.asset {
                    return wrapped.selectedIdentifiers.contains(__phasset.localIdentifier)
                }
                return false
            }
            
            if filterAssets.count > 0 {
                for identifier in wrapped.selectedIdentifiers {
                    for asset in filterAssets {
                        if let __phasset = asset.asset, __phasset.localIdentifier == identifier {
                            wrapped.add(asset)
                            break
                        }
                    }
                }
            }
        }
        
        completion?(true, accessAlbums)
    }
    
    public class  func outputAssets(_ assets:[NXAsset], _ wrapped: NXAsset.Wrapped, completion:NX.Event<Bool, [NXAsset]>?){
        let outputAssets = assets.map { (nxAsset) -> NXAsset in
            let outputAsset = NXAsset(asset: nxAsset.asset, suffixes:wrapped.video.suffixes)
            outputAsset.thumbnail = nxAsset.thumbnail
            outputAsset.image = nxAsset.image
            return outputAsset
        }
        
        var animationView : NXHUD.WrappedView? = nil
        DispatchQueue.main.async {
            animationView = NX.showLoading("正在加载图片...")
        }
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            let semaphore = DispatchSemaphore(value: 1)
            
            for __outputAsset in outputAssets {
                group.enter()
                semaphore.wait()
                
                if let __phasset = __outputAsset.asset {
                    let size = NXClip.resize(by: wrapped.resizeBy, CGSize(width: __phasset.pixelWidth, height: __phasset.pixelHeight), wrapped.resize, true)
                    NXAsset.requestImage(__phasset,
                                           true,
                                           size,
                                           progress:{value, _ in
                        if value >= 1 {
                            animationView?.ctxs.message = "正在加载图片..."
                            animationView?.updateSubviews("", nil)
                        }
                        else {
                            animationView?.ctxs.message = "正在从iCloud加载图片,\(Int(value*100))%..."
                            animationView?.updateSubviews("", nil)
                        }
                    },
                                           completion:{ action, value in
                        if let __image = value {
                            __outputAsset.image = __image
                        }
                        else if let thumbnail = __outputAsset.thumbnail {
                            __outputAsset.image = thumbnail
                        }
                        semaphore.signal()
                        group.leave()
                    })
                }
                else{
                    if __outputAsset.image == nil && __outputAsset.thumbnail != nil {
                        __outputAsset.image = __outputAsset.thumbnail
                    }
                    semaphore.signal()
                    group.leave()
                }
            }
            
            group.notify(queue: DispatchQueue.main, execute: {
                NX.hideLoading(animationView)
                completion?(true, outputAssets)
            })
        }
    }
    
    //PHImageFileOrientationKey:0, int
    //PHImageResultIsDegradedKey:0, bool
    //PHImageResultRequestIDKey:48,int
    //PHImageFileUTIKey:public.png, string
    
    
    @discardableResult
    public class func requestImage(_ asset: PHAsset, _ isNetworkAccessAllowed:Bool, _ size:CGSize, progress:NX.Event<Double, Any?>?, completion:NX.Event<Bool, UIImage?>?) -> PHImageRequestID {
        var isReturnedOrRequestingiCloud = false
        let unaccess = PHImageRequestOptions()
        unaccess.resizeMode = .fast
        unaccess.isNetworkAccessAllowed = false
        return PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: unaccess) {(result, info) in
            
            if NX.isLoggable, var info = info {
                info["image"] = result
                NX.log{return info}
            }
            let dicValue = info as? [String:Any] ?? [:]
            let isInCloud = NX.get(bool: dicValue["PHImageResultIsInCloudKey"] as? Bool, false)
            let isDegraded = NX.get(bool: dicValue["PHImageResultIsDegradedKey"] as? Bool, false)
            let isCancelled = NX.get(bool: dicValue["PHImageCancelledKey"] as? Bool, false)
            if isCancelled {return}
            
            if isDegraded {
                if isInCloud && isNetworkAccessAllowed {
                    //只要已回调过或者已开启iCloud下载，这里的iCloud下载流程终止
                    if isReturnedOrRequestingiCloud == true { return }
                    isReturnedOrRequestingiCloud = true
                    
                    NXAsset.requestImageData(asset, progress: progress) { action, value in
                        if let __data = value, let image = UIImage(data: __data) {
                            let outputImage = NXClip.resize(image, size) ?? image
                            completion?(true, outputImage)
                        }
                        else {
                            completion?(true, nil)
                        }
                    }
                }
            }
            else {
                if isReturnedOrRequestingiCloud == true { return }//只要已回调过或者已开启iCloud下载，这里的回调流程终止
                isReturnedOrRequestingiCloud = true
                
                completion?(true, result)
            }
        }
    }
    
    @discardableResult
    public class func requestImageData(_ asset: PHAsset, progress:NX.Event<Double, Any?>?, completion:NX.Event<Bool, Data?>?) -> PHImageRequestID {
        let access = PHImageRequestOptions()
        if let filename = asset.value(forKey: "filename") as? String, filename.contains("GIF") {
            access.version = .original
        }
        access.deliveryMode = .highQualityFormat
        access.progressHandler = {(value, error, stop, info) in
            DispatchQueue.main.async {
                progress?(value, nil)
            }
        }
        access.resizeMode = .fast
        access.isNetworkAccessAllowed = true
        if #available(iOS 13, *) {
            return PHImageManager.default().requestImageDataAndOrientation(for: asset, options: access) { data, dataUTI, orientation, info in
                
                var dicValue = info as? [String:Any] ?? [:]
                let isCancelled = NX.get(bool: dicValue["PHImageCancelledKey"] as? Bool, false)
                if NX.isLoggable {
                    dicValue.removeValue(forKey: "PHImageFileDataKey")
                    NX.log{return dicValue}
                }
                
                if isCancelled == false {
                    completion?(data != nil, data)
                }
            }
        }
        else {
            return PHImageManager.default().requestImageData(for: asset, options: access) { (data, dataUTI, orientation, info) in
                var dicValue = info as? [String:Any] ?? [:]
                let isCancelled = NX.get(bool: dicValue["PHImageCancelledKey"] as? Bool, false)

                if NX.isLoggable {
                    dicValue.removeValue(forKey: "PHImageFileDataKey")
                    NX.log{return dicValue}
                }
                
                if isCancelled == false {
                    completion?(data != nil, data)
                }
            }
        }
    }
    
    
    @discardableResult
    public class func requestAVAsset(_ asset: PHAsset, progress:NX.Event<Double, Any?>?, completion:NX.Event<Bool, AVAsset?>?) -> PHImageRequestID {
        let __options = PHVideoRequestOptions()
        __options.deliveryMode = .automatic
        __options.isNetworkAccessAllowed = true
        __options.progressHandler = { (value, error, stop, info) in
            DispatchQueue.main.async {
                progress?(value, nil)
            }
        }
        return PHImageManager.default().requestAVAsset(forVideo: asset, options: __options) { (avasset, mix, info) in
            if NX.isLoggable, let info = info {
                NX.log{return info}
            }
            completion?(true, avasset)
        }
    }
}
