//
//  NXAsset.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/17.
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
    
    
    public override init() {
        super.init()
    }
    
    convenience public init(asset: PHAsset?, extensions:[String] = []) {
        self.init()
        
        if let __asset = asset {
            self.asset = __asset
            self.mediaType = __asset.mediaType
            
            self.size = CGSize(width: __asset.pixelWidth, height: __asset.pixelHeight)
            self.duration = __asset.duration
            self.filename = NX.get(string: __asset.value(forKey: "filename") as? String, "")
            
            if __asset.mediaType == .video {
                let __filename = self.filename.lowercased()
                if extensions.count > 0 {
                    self.isSelectable = extensions.contains { (suffix) -> Bool in
                        return __filename.hasSuffix(suffix)
                    }
                }
                else {
                    self.isSelectable = __filename.hasSuffix(".mp4")
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
    
    open var completion: NX.Completion<Bool, Any?>? = nil
}

extension NXAsset {
    
    open class Request {
        open var size = CGSize.zero
        open var iCloud = false
        public init(){}
    }
    
    open func startRequest(_ request:NXAsset.Request, _ completion:@escaping NX.Completion<Bool, Any?>){
        if self.completion == nil {
            self.value.removeAll()
        }
        self.completion = completion
        
        guard let __asset =  self.asset else {
            self.completion?(false, nil)
            return
        }
        
        NXAsset.requestImageData(__asset, request.iCloud, request.size, nil) {[weak self] (isDegraded, image) in
            
            //如果返回的是有效的图片，则先保存好图片
            if let __image = image, __image.size.width > 0 && __image.size.height > 0 {
                var images = self?.value["images"] as? [UIImage] ?? []
                images.append(__image)
                self?.value["images"] = images
            }
            
            if request.iCloud {
                //这次请求的就是iCloud上的大图
                self?.stopRequest()
            }
            else {
                //返回的是本地的大图或者缩略图
                let isRequesting = NX.get(bool: self?.value["isRequesting"] as? Bool, false)
                if isRequesting {
                    return
                }
                
                let __size = image?.size ?? CGSize.zero
                let __scale = image?.scale ?? 1.0
                
                if isDegraded || __size.width * __size.height * __scale * __scale <= (request.size.width - 10) * (request.size.height - 10) {
                    self?.value["isRequesting"] = true
                    
                    NXAsset.requestImageData(__asset, true, request.size, nil) {[weak self] (__isDegraded, __image) in
                        
                        if let ____image = __image, ____image.size.width > 0 && ____image.size.height > 0 {
                            var images = self?.value["images"] as? [UIImage] ?? []
                            images.append(____image)
                            self?.value["images"] = images
                        }
                        
                        self?.stopRequest()
                    }
                }
                else {
                    self?.stopRequest()
                }
            }
        }
    }

    open func stopRequest(){
        let image = (self.value["images"] as? [UIImage])?.last
        if let __completion = self.completion {
            __completion(true, image)
            self.completion = nil
        }
        self.value.removeAll()
    }
}

extension NXAsset {
    //选择的记录
    open class Value<Value:NXInitialValue> : NXAny {
        open var isIndex = Value.initialValue
        open var minOfAssets : Int = 0
        open var maxOfAssets : Int = 0
        open var assets = [NXAsset]()
    }
    
    //回调部分的结构
    open class Output : Value<Bool> {
        open var image = NXAsset.Value<Bool>()
        open var video = NXAsset.Value<Bool>()
        
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
    }
    
    open class Clip : NXAny {
        open var name = "1:1"
        open var isResizable = false
        open var width : CGFloat = 1.0
        open var height : CGFloat = 1.0
        open var isHidden = false
        
        public override init() {
            super.init()
        }
        
        convenience public init(name:String, isResizable:Bool, width:CGFloat, height:CGFloat, isHidden:Bool) {
            self.init()
            self.name = name
            self.isResizable = isResizable
            self.width = width
            self.height = height
            self.isHidden = isHidden
        }
    }
    
    open class Wrapped : NXAny {
        //创建相册信号量
        public static var semaphore = DispatchSemaphore(value: 1)
        //是否优先请求全高清图像
        public static var iCloud = true
        //支持展示的媒体类型
        open var mediaType = PHAssetMediaType.unknown
        //本次已经选择的资源
        open var identifiers = [String]()
        //全部相册（视频的会合并到一个相册中）
        open var albums = [NXAlbum]()
        //预览的资源文件
        open var assets = [NXAsset]()
        //输出的内容
        open var output = NXAsset.Output()
        //本次已经选择的资源
        open var selectedIdentifiers = [String]()

        //导出封面图相关
        open var outputResize = CGSize(width: 1920, height: 1920)//导出尺寸
        open var outputResizeBy = NXResize.side//导出size计算方法
        open var outputUIImage = true //是否需要导出UIImage
        open var isAutoclosed = true
        open var isOutputting  = false //是否正在导出image
        open var isMixable = false
        
        //图片相关
        open var clips = [NXAsset.Clip]()//具体的宽高比例
        
        //导出视频相关
        open var videoClipsAllowed = false//是否支持裁剪
        open var videoClipsDuration : TimeInterval = 15.0//最大视频时长
        open var videoFileExtensions = [".mp4"]//支持的视频格式
        
        //最后的回调
        open var completion : NX.Completion<Bool, NXAsset.Output>? = nil
        //最初的打开方式
        open var navigation = NXViewController.Navigation.present
        //是否打开页面
        open var openAllowed = true
        //是否关闭页面
        open var closeAllowed = true
        //是否需要动画
        open var isAnimated = true
        
        //导航控制器
        weak open var naviController : NXNavigationController? = nil
        //当前活跃的最顶层的视图控制器
        weak open var viewController : UIViewController? = nil
        
        //是否显示底部的拍照按钮
        open var footer : (lhs:Bool, center:Bool, rhs:Bool) = (false, false, false)
        
        //打开相册
        public class func open(_ wrapped:NXAsset.Wrapped, vc:NXViewController) {
            if let navi = wrapped.naviController {
                if wrapped.navigation == .present, let visible = navi.currentViewController {
                    wrapped.viewController = visible
                    visible.present(vc, animated: wrapped.isAnimated, completion: nil)
                }
                else if wrapped.navigation == .overlay, let _ = navi.topViewController as? NXViewController {
                    wrapped.viewController = vc
                    navi.showSubviewController(vc, animated: wrapped.isAnimated)
                }
                else if let top = navi.topViewController {
                    wrapped.navigation = .push
                    wrapped.viewController = top
                    navi.pushViewController(vc, animated: wrapped.isAnimated)
                }
            }
        }
        
        //处理数据
        public class func dispose(_ wrapped:NXAsset.Wrapped, assets:[NXAsset]){
            if wrapped.closeAllowed {
                NXAsset.Wrapped.close(wrapped)
            }
            
            let output = NXAsset.Output()
            output.assets = assets
            wrapped.completion?(true, output)
        }
        
        //关闭相册
        public class func close(_ wrapped:NXAsset.Wrapped) {
            if let navi = wrapped.naviController {
                if wrapped.navigation == .present {
                    wrapped.viewController?.dismiss(animated: wrapped.isAnimated, completion: nil)
                }
                else if wrapped.navigation == .overlay {
                    if let vc = wrapped.viewController as? NXViewController {
                        navi.removeSubviewController(vc, animated: wrapped.isAnimated)
                    }
                }
                else if wrapped.navigation == .push {
                    if let vc = wrapped.viewController {
                        navi.popToViewController(vc, animated: wrapped.isAnimated)
                    }
                }
            }
        }
    }
}


extension NXAsset {
    open class func open(album: NX.Completion<Bool, NXAssetsViewController>?,
                         completion: NX.Completion<Bool, NXAsset.Output>?) {
        NX.authorization(NX.Authorize.album, DispatchQueue.main, true, { state in
            guard state == NX.AuthorizeState.authorized else {return}

            let __wrapped = NXWrappedViewController<NXWrappedNavigationController<NXAssetsViewController>>()
            __wrapped.modalPresentationStyle = .fullScreen
            __wrapped.viewController.viewController.wrapped.completion = completion
            album?(true, __wrapped.viewController.viewController)
            if __wrapped.viewController.viewController.wrapped.openAllowed {
                NXAsset.Wrapped.open(__wrapped.viewController.viewController.wrapped, vc: __wrapped)
            }
        })
    }
    
    open class func album(minOfAssets:Int,
                          maxOfAssets:Int,
                          image : (minOfAssets:Int, maxOfAssets:Int, isIndex:Bool),
                          video : (minOfAssets:Int, maxOfAssets:Int, isIndex:Bool),
                          isMixable:Bool,
                          isAutoclosed:Bool,
                          
                          mediaType:PHAssetMediaType,
                          selectedIdentifiers:[String],
                          outputResize:CGSize,
                          outputResizeBy:String,
                          outputUIImage:Bool,

                          clips:[NXAsset.Clip],
                          
                          videoClipsAllowed:Bool,
                          videoClipsDuration:TimeInterval,
                          videoFileExtensions:[String],
                          
                          footer:(lhs:Bool, center:Bool, rhs:Bool),
                          
                          navigation:NXViewController.Navigation,
                          naviController:NXNavigationController,
                          openAllowed:Bool,
                          closeAllowed:Bool,
                          isAnimated:Bool,
                          completion:NX.Completion<Bool, NXAsset.Output>?) {
        
        NXAsset.open(album: {(state:Bool, vc:NXAssetsViewController) in
            //基础配置
            vc.wrapped.output.minOfAssets = minOfAssets
            vc.wrapped.output.maxOfAssets = maxOfAssets
            vc.wrapped.output.image.minOfAssets = image.minOfAssets
            vc.wrapped.output.image.maxOfAssets = image.maxOfAssets
            vc.wrapped.output.image.isIndex = image.isIndex
            vc.wrapped.output.video.minOfAssets = video.minOfAssets
            vc.wrapped.output.video.maxOfAssets = video.maxOfAssets
            vc.wrapped.output.video.isIndex = video.isIndex
            
            vc.wrapped.isMixable = isMixable
            vc.wrapped.isAutoclosed = isAutoclosed

            vc.wrapped.mediaType = mediaType
            vc.wrapped.selectedIdentifiers = selectedIdentifiers
            
            //导出封面图相关
            vc.wrapped.outputResize = outputResize
            vc.wrapped.outputResizeBy = outputResizeBy
            vc.wrapped.outputUIImage = outputUIImage

            //图片
            vc.wrapped.clips = clips
            
            //视频
            vc.wrapped.videoClipsAllowed = videoClipsAllowed
            vc.wrapped.videoClipsDuration = videoClipsDuration
            vc.wrapped.videoFileExtensions = videoFileExtensions
            
            //底部按钮
            vc.wrapped.footer = (footer.lhs, footer.center, footer.rhs)
            
            //导航相关
            vc.wrapped.naviController = naviController
            vc.wrapped.navigation = navigation
            vc.wrapped.openAllowed = openAllowed
            vc.wrapped.closeAllowed = closeAllowed
            vc.wrapped.isAnimated = isAnimated
        }, completion: completion)
    }
    
    open class func open(camera:NX.Completion<Bool, NXImagePickerController>?,
                         completion:NX.Completion<Bool, NXAsset.Output>?) {
        NX.authorization(NX.Authorize.camera, DispatchQueue.main, true, {(state) in
            guard state == NX.AuthorizeState.authorized else {return}
            
            let __wrapped = NXWrappedViewController<NXImagePickerController>()
            __wrapped.view.backgroundColor = .black
            __wrapped.naviView.isHidden = true
            __wrapped.viewController.view.backgroundColor = .black
            __wrapped.viewController.setNavigationBarHidden(true, animated: false)
            __wrapped.viewController.wrapped.completion = completion
            __wrapped.viewController.sourceType = .camera
            __wrapped.viewController.delegate = __wrapped.viewController
            __wrapped.viewController.modalPresentationStyle = .fullScreen
            camera?(true, __wrapped.viewController)
            __wrapped.viewController.wrapped.naviController?.pushViewController(__wrapped, animated: true)
        })
    }
    
    
    //这个地方存在同时创建多个同名相册的情况:采用信号量的方案来解决
    open class func fetchAlbum(name: String, queue:DispatchQueue, isCreated:Bool, completion:@escaping ((_ album:PHAssetCollection?) -> ())){
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
                if isCreated {
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
    
    //5.保存图片到相册
    open class func saveImage(image: UIImage, name: String = NX.name, queue:DispatchQueue = DispatchQueue.main, completion: ((_ isCompleted: Bool, _ asset:PHAsset?) -> ())?) {
        NXAsset.save(assets: [image], name: name, queue:queue, completion:{ (state, assets) in
            completion?(state, assets.first)
        })
    }
    
    //保存视频到相册
    open class func saveVideo(fileURL:URL, name: String = NX.name, queue:DispatchQueue = DispatchQueue.main, completion: ((_ isCompleted: Bool, _ asset:PHAsset?) -> ())?){
        NXAsset.save(assets: [fileURL], name: name, queue:queue, completion:{ (state, assets) in
            completion?(state, assets.first)
        })
    }
    
    //保存视频/图片到系统相册
    open class func save(assets:[Any], name: String, queue:DispatchQueue, completion: ((_ isCompleted: Bool, _ assets:[PHAsset]) -> ())?) {
        //相册授权
        NX.authorization(.album, queue, false) { (status) in
            guard status == .authorized else {
                queue.async {
                    completion?(false, [])
                }
                return
            }
            
            //获取目标相册
            NXAsset.fetchAlbum(name:name, queue:queue, isCreated:true, completion: { (album) in
                
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
    public class func outputAlbums(_ wrapped: NXAsset.Wrapped, completion: ((_ outputAlbums:[NXAlbum]) -> ())?) {
        
        var accessAlbums = [NXAlbum]()
        
        let options = PHFetchOptions()
        //resultsOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: true)]
        if wrapped.mediaType != .unknown {
            //当外部传入了具体类型(.image, .auduo, .video)的时候做过滤操作
            options.predicate = NSPredicate(format: "mediaType = %d", wrapped.mediaType.rawValue)
        }
        
        //用户自己创建的相册
        let __albums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        //系统创建的相册
        let __smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        
        var contains = [PHAssetCollection]()
        if let fetchResults = [__albums, __smartAlbums] as? [PHFetchResult<AnyObject>] {
            for fetchResult in fetchResults {
                
                for index in 0 ..< fetchResult.count {
                    
                    //有可能是PHCollectionList的对象，过滤掉
                    guard let collection  = fetchResult[index] as? PHAssetCollection else {continue}
                    
                    //最近删除：过滤掉
                    if collection.localizedTitle == "Deleted" || collection.localizedTitle == "最近删除" {continue}
                    //已经导入：过滤掉
                    if contains.contains(collection) {continue}
                    
                    //无照片相册,过滤掉
                    if let fetchResult = (PHAsset.fetchAssets(in: collection, options: options) as? PHFetchResult<AnyObject>), fetchResult.count > 0 {
                        
                        contains.append(collection)
                        let album = NXAlbum(title: collection.localizedTitle ?? "", fetchResults: [fetchResult], wrapped:wrapped)
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
                            wrapped.output.add(asset)
                            break
                        }
                    }
                }
            }
        }
        
        completion?(accessAlbums)
    }
    
    public class  func outputAssets(_ wrapped: NXAsset.Wrapped, completion:NX.Completion<Bool, [NXAsset]>?){
        let outputAssets = wrapped.output.assets.map { (__leyAsset) -> NXAsset in
            let __outputAsset = NXAsset(asset: __leyAsset.asset, extensions:wrapped.videoFileExtensions)
            __outputAsset.thumbnail = __leyAsset.thumbnail
            __outputAsset.image = __leyAsset.image
            return __outputAsset
        }
        
        DispatchQueue.main.async {
            NX.showLoading("")
        }
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            let semaphore = DispatchSemaphore(value: 3)
            
            for __outputAsset in outputAssets {
                group.enter()
                semaphore.wait()
                
                if let __phasset = __outputAsset.asset {
                    let request = NXAsset.Request()
                    request.size = NXResize.resize(by: wrapped.outputResizeBy, CGSize(width: __phasset.pixelWidth, height: __phasset.pixelHeight), wrapped.outputResize, true)
                    request.iCloud = NXAsset.Wrapped.iCloud
                    __outputAsset.startRequest(request, { (isCompleted, image) in
                        if let __image = image as? UIImage {
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
                NX.hideLoading(superview: UIApplication.shared.keyWindow)
                completion?(true, outputAssets)
            })
        }
    }
    
    
    @discardableResult
    open class func requestImageData(_ asset: PHAsset, _ isNetworkAccessAllowed:Bool, _ size:CGSize,  _ options:PHImageRequestOptions?, _ completion:NX.Completion<Bool, UIImage?>?) -> PHImageRequestID {
        if isNetworkAccessAllowed {
            var __options : PHImageRequestOptions? = options
            if __options == nil {
                __options = PHImageRequestOptions()
                __options?.isNetworkAccessAllowed = true
                if let filename = asset.value(forKey: "filename") as? String, filename.contains("GIF") {
                    __options?.version = .original
                }
                __options?.deliveryMode = .highQualityFormat
                __options?.progressHandler = {(progress, error, stop, info) in
                    NX.log{return "inCloud progressValue=\(progress)"}
                }
            }
            
            return PHImageManager.default().requestImageData(for: asset, options: __options) { (data, dataUTI, orientation, info) in
                if NX.isLoggable, var info = info {
                    info.removeValue(forKey: "PHImageFileDataKey")
                    NX.log{return info}
                }
                
                if let __data = data, let image = UIImage(data: __data) {
                    let outputImage = NXResize.resize(image, size) ?? image
                    completion?(true, outputImage)
                }
                else {
                    completion?(true, nil)
                }
            }
        }
        else {
            var __options : PHImageRequestOptions? = options
            if __options == nil {
                __options = PHImageRequestOptions()
                __options?.resizeMode = .fast
                __options?.isNetworkAccessAllowed = false
            }
            __options?.isNetworkAccessAllowed = false
            
            return PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: __options) {(result, info) in
                if NX.isLoggable, let info = info {
                    NX.log{return info}
                }
                let dicValue = info as? [String:Any] ?? [:]
                //let isInCloud = NX.get(bool: dicValue["PHImageResultIsInCloudKey"] as? Bool, false)
                let isDegraded = NX.get(bool: dicValue["PHImageResultIsDegradedKey"] as? Bool, false)
                completion?(isDegraded, result)
            }
        }
    }
    
    @discardableResult
    open class func requestAVAsset(_ asset: PHAsset, _ options:PHVideoRequestOptions?, _ completion:NX.Completion<Bool, AVAsset?>?) -> PHImageRequestID {
        var __options : PHVideoRequestOptions? = options
        if __options == nil {
            __options = PHVideoRequestOptions()
            __options?.deliveryMode = .automatic
            __options?.isNetworkAccessAllowed = true
            __options?.progressHandler = { (progress, error, stop, info) in
                NX.log{return "inCloud progressValue=\(progress)"}
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

open class NXImagePickerController : UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public let wrapped = NXAsset.Wrapped()
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //拍照
        var image : UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let __image = image, let fixed = UIImage.fixedOrientation(image: __image) {
            image = fixed
        }
        
        if let __image = image {
            NX.showLoading("正在保存", .center, self.view)
            NXAsset.saveImage(image: __image) {[weak self] (state, asset) in
                guard let self = self else {return}
                NX.hideLoading(superview: self.view)
                
                if let __asset = asset {
                    let leyAsset = NXAsset(asset: __asset)
                    leyAsset.image = __image
                    leyAsset.thumbnail = __image
                    
                    let ctxs = NXAsset.Output()
                    ctxs.assets.append(leyAsset)
                    self.wrapped.completion?(true, ctxs)
                    
                    self.wrapped.naviController?.popViewController(animated: true)
                }
                else {
                    let ctxs = NXAsset.Output()
                    self.wrapped.completion?(false, ctxs)
                    self.wrapped.naviController?.popViewController(animated: true)
                }
            }
        }
        else {
            let ctxs = NXAsset.Output()
            self.wrapped.completion?(false, ctxs)
            self.wrapped.naviController?.popViewController(animated: true)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.wrapped.naviController?.popViewController(animated: true)
    }
}


open class NXAssetViewCell: NXCollectionViewCell {
    public let assetView = UIImageView(frame: CGRect.zero) //显示图片或者视频的封面
    public let durationView = UILabel(frame: CGRect.zero) //显示视频时长
    public let indexView = UILabel(frame: CGRect.zero) //显示选中和非选中的按钮
    public let maskedView = UIView(frame: CGRect.zero)
    
    open override func setupSubviews() {
        clipsToBounds = true
        
        assetView.frame = contentView.bounds
        assetView.contentMode = .scaleAspectFill
        contentView.addSubview(assetView)
        
        durationView.textAlignment = .right
        durationView.textColor = UIColor.white
        durationView.font = NX.font(12, false)
        durationView.isHidden = true
        contentView.addSubview(durationView)
        
        indexView.layer.cornerRadius = 11.5
        indexView.layer.masksToBounds = true
        indexView.textColor = UIColor.white
        indexView.font = NX.font(13, true)
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
        
        if let __thumbnail = asset.thumbnail {
            self.assetView.image = __thumbnail
        }
        else{
            var size = self.contentView.frame.size
            size.width = round(size.width * NXUI.scale)
            size.height =  round(size.height * NXUI.scale)
            PHCachingImageManager.default().requestImage(for: phasset,
                                                         targetSize: size,
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
        durationView.frame = CGRect(x: 4, y: contentView.h-22, width: contentView.w-8, height: 22)
        indexView.frame = CGRect(x: contentView.w-23-5, y: 5, width: 23, height: 23)
        maskedView.frame = contentView.bounds
    }
}

open class NXAlbum : NXAction {
    public var assets = [NXAsset]() //保存自己之前生成的model
        
    convenience public init(title: String, fetchResults: [PHFetchResult<AnyObject>], wrapped:NXAsset.Wrapped) {
        self.init(title: title, value: nil, completion:nil)
        self.ctxs.update(NXActionViewCell.self, "NXActionViewCell")
        
        //生成NXAsset对象
        for fetchResult in fetchResults {
            if let __fetchResult = fetchResult as? PHFetchResult<PHAsset> {
                for index in 0 ..< __fetchResult.count {
                    let phasset = __fetchResult[index]
                    let __asset = NXAsset(asset: phasset, extensions:wrapped.videoFileExtensions)
                    self.assets.append(__asset)
                }
            }
        }
        
        //获取封面
        if let asset = self.assets.last?.asset {
            var __size = CGSize.zero
            __size.width = round((NXUI.width-12*2-2*3)/4.0 * NXUI.scale)
            __size.height = __size.width
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: __size,
                                                  contentMode: .aspectFill,
                                                  options: nil) {[weak self]
                                                    (image, info) in
                                                    self?.asset.image = image
            }
        }
                
        self.ctxs.size = CGSize(width: NXUI.width, height: 80)
        self.asset.frame = CGRect(x: 16, y: 1, width: 78, height: 78)
        self.asset.cornerRadius = 0.0
        self.asset.isHidden = false
        
        self.title.frame = CGRect(x: 106, y: 19, width: NXUI.width-136, height: 22)
        self.title.value = title
        self.title.textAlignment = .left
        self.title.font = NX.font(16, true)
        self.title.isHidden = false
        
        self.subtitle.frame = CGRect(x: 106, y: 43, width: NXUI.width-136, height: 18)
        self.subtitle.value = "\(self.assets.count)张"
        self.subtitle.font = NX.font(14, false)
        self.subtitle.textAlignment = .left
        self.subtitle.isHidden = false
        
        self.value.isHidden = true
        
        self.arrow.isHidden = false
        self.arrow.frame = CGRect(x: self.ctxs.width - 16 - 6, y: (self.ctxs.height - 12)/2.0, width: 6, height: 12)
        self.arrow.image = NX.image(named:"icon-arrow.png")
        
        self.appearance.separator.insets = UIEdgeInsets(top: 0, left: 106, bottom: 0, right: 0)
        self.appearance.separator.ats = .maxY
    }
}
