//
//  LEYAsset.swift
//  NXFoundation
//
//  Created by firelonely on 2020/5/17.
//

import UIKit
import Photos

open class LEYAsset: NSObject {
    open var value = [String:Any]()
    
    open var type = LEYAsset.Typed.unknown.rawValue//类型
    open var size : CGSize = CGSize.zero //宽度高度
    open var url : String = ""
    open var file : String = ""
    
    open var asset : PHAsset? = nil

    open var mediaType: PHAssetMediaType = .unknown
    open var duration: TimeInterval = 0 //时长
    
    open var name : String = "" //文件名
    open var isBlocked : Bool = false //是否在历史记录中
    open var isSelectable: Bool = false //是否可选择
    open var isMaskedable : Bool = false //是否添加覆盖层
    open var thumbnail : UIImage? = nil //点选显示的缩略图
    open var image : UIImage? = nil //输出的image
    open var index : String = ""
    
    
    public override init() {
        super.init()
    }
    
    convenience public init(asset: PHAsset?, fileExtensions:[String] = []) {
        self.init()
        
        if let __asset = asset {
            self.asset = __asset
            self.mediaType = __asset.mediaType
            
            self.size = CGSize(width: __asset.pixelWidth, height: __asset.pixelHeight)
            self.duration = __asset.duration
            
            self.name = LEYApp.get(string: __asset.value(forKey: "filename") as? String, "")
            if __asset.mediaType == .video {
                let __filename = self.name.lowercased()
                if fileExtensions.count > 0 {
                    self.isSelectable = fileExtensions.contains { (suffixe) -> Bool in
                        return __filename.hasSuffix(suffixe)
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
    
    open var completion: LEYApp.Completion<Bool, Any?>? = nil
}

extension LEYAsset {
    
    open func startRequest(_ request:LEYAsset.Request, _ completion:@escaping LEYApp.Completion<Bool, Any?>){
        if self.completion == nil {
            self.value.removeAll()
        }
        self.completion = completion
        
        guard let __asset =  self.asset else {
            self.completion?(false, nil)
            return
        }
        
        LEYAsset.requestImageData(__asset, request.iCloud, request.size, nil) {[weak self] (isDegraded, image) in
            
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
                let isRequesting = LEYApp.get(bool: self?.value["isRequesting"] as? Bool, false)
                if isRequesting {
                    return
                }
                
                let __size = image?.size ?? CGSize.zero
                let __scale = image?.scale ?? 1.0
                
                if isDegraded || __size.width * __size.height * __scale * __scale <= (request.size.width - 10) * (request.size.height - 10) {
                    self?.value["isRequesting"] = true
                    
                    LEYAsset.requestImageData(__asset, true, request.size, nil) {[weak self] (__isDegraded, __image) in
                        
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

extension LEYAsset {
    open class Request {
        open var size = CGSize.zero
        open var iCloud = false
        public init(){}
    }
    
    public enum Typed : String {
        case image = "image"
        case video = "video"
        case audio = "audio"
        case unknown = "unknown"
    }
    
    public class func type(_ mediaType:PHAssetMediaType?) -> LEYAsset.Typed.RawValue {
        guard let __mediaType = mediaType else {
            return LEYAsset.Typed.unknown.rawValue
        }
        if __mediaType == .image {
            return LEYAsset.Typed.image.rawValue
        }
        else if __mediaType == .video {
            return LEYAsset.Typed.video.rawValue
        }
        else if __mediaType == .audio {
            return LEYAsset.Typed.audio.rawValue
        }
        return LEYAsset.Typed.unknown.rawValue
    }
    
    public enum Resize : String {
        case side = "side" //图片变长/目标边长：所谓缩放系数
        case area = "area" //开平方（图片宽高相乘/目标宽高相乘）：作为缩放系数
        case none = "none" //不缩放
    }
    
}

extension LEYAsset {
    //选择的记录
    open class Value : NSObject {
        open var isIndex = true
        open var minOfAssets : Int = 0
        open var maxOfAssets : Int = 0
        open var assets = [LEYAsset]()
    }
    
    //操作结果
    public enum State {
        case succeed
        case error
        case denied
    }
    
    //回调部分的结构
    open class Output : NSObject {
        open var minOfAssets : Int = 0
        open var maxOfAssets : Int = 0
        open var assets = [LEYAsset]()
        
        open var image = LEYAsset.Value()
        open var video = LEYAsset.Value()
        open var isMixable = false
        
        open var isAutoclosed = true
        open var images = [UIImage]()
        open var value : Any? = nil //用在特殊场景的导出数据：例如拍摄导出的是rrxcasset
        open var isOutputting  = false //是否正在导出image
        
        open func add(_ value:LEYAsset) {
            if value.mediaType == .image {
                self.assets.append(value)
                self.image.assets.append(value)
            }
            else if value.mediaType == .video {
                self.assets.append(value)
                self.video.assets.append(value)
            }
        }
        
        open func remove(_ value:LEYAsset) {
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
    
    open class Clip : NSObject {
        open var isResizable = false
        open var width : CGFloat = 1.0
        open var height : CGFloat = 1.0
        open var isHidden = false
        
        public override init() {
            super.init()
        }
        
        convenience public init(isResizable:Bool, width:CGFloat, height:CGFloat, isHidden:Bool) {
            self.init()
            self.isResizable = isResizable
            self.width = width
            self.height = height
            self.isHidden = isHidden
        }
    }
    
    open class Wrapped : NSObject {
        //创建相册信号量
        public static var semaphore = DispatchSemaphore(value: 1)
        //是否优先请求全高清图像
        public static var iCloud = false
        //支持展示的媒体类型
        open var mediaType = PHAssetMediaType.unknown
        //本次已经选择的资源
        open var identifiers = [String]()
        //全部相册（视频的会合并到一个相册中）
        open var albums = [LEYAlbum]()
        //预览的资源文件
        open var assets = [LEYAsset]()
        //输出的内容
        open var output = LEYAsset.Output()
        //本次已经选择的资源
        open var selectedIdentifiers = [String]()
        //已经选择过的
        open var usedIdentifiers = [String]()

        //导出封面图相关
        open var outputResize = CGSize(width: 1920, height: 1920)//导出尺寸
        open var outputResizeBy = LEYAsset.Resize.side.rawValue//导出size计算方法
        open var outputUIImage = true //是否需要导出UIImage
        
        //图片相关
        open var imageClips = [LEYAsset.Clip]()//具体的宽高比例
        
        //导出视频相关
        open var videoClipsAllowed = false//是否支持裁剪
        open var videoClipsDuration : TimeInterval = 15.0//最大视频时长
        open var videoFileExtensions = [".mp4"]//支持的视频格式
        
        //最后的回调
        open var completion : LEYApp.Completion<Bool, LEYAsset.Output>? = nil
        //最初的打开方式
        open var operation = LEYViewController.Operation.present
        //是否打开页面
        open var isOpenable = true
        //是否关闭页面
        open var isCloseable = true
        //是否需要动画
        open var isAnimated = true
        
        //导航控制器
        weak open var naviController : LEYNavigationController? = nil
        //当前活跃的最顶层的视图控制器
        weak open var viewController : UIViewController? = nil
        
        //是否显示底部的拍照按钮
        open var footer : (lhs:Bool, center:Bool, rhs:Bool) = (false, false, false)
        
        //打开相册
        public class func open(_ wrapped:LEYAsset.Wrapped, vc:LEYViewController) {
            if let navi = wrapped.naviController {
                if wrapped.operation == .present, let visible = navi.currentViewController {
                    wrapped.viewController = visible
                    visible.present(vc, animated: wrapped.isAnimated, completion: nil)
                }
                else if wrapped.operation == .overlay, let _ = navi.topViewController as? LEYViewController {
                    wrapped.viewController = vc
                    navi.showSubviewController(vc, animated: wrapped.isAnimated)
                }
                else if let top = navi.topViewController {
                    wrapped.operation = .push
                    wrapped.viewController = top
                    navi.pushViewController(vc, animated: wrapped.isAnimated)
                }
            }
        }
        
        //处理数据
        public class func dispose(_ wrapped:LEYAsset.Wrapped, assets:[LEYAsset]){
            if wrapped.isCloseable {
                LEYAsset.Wrapped.close(wrapped)
            }
            
            let output = LEYAsset.Output()
            output.assets = assets
            for asset in assets {
                if let image = asset.image {
                    output.images.append(image)
                }
            }
            wrapped.completion?(true, output)
        }
        
        //关闭相册
        public class func close(_ wrapped:LEYAsset.Wrapped) {
            if let navi = wrapped.naviController {
                if wrapped.operation == .present {
                    wrapped.viewController?.dismiss(animated: wrapped.isAnimated, completion: nil)
                }
                else if wrapped.operation == .overlay {
                    if let vc = wrapped.viewController as? LEYViewController {
                        navi.removeSubviewController(vc, animated: wrapped.isAnimated)
                    }
                }
                else if wrapped.operation == .push {
                    if let vc = wrapped.viewController {
                        navi.popToViewController(vc, animated: wrapped.isAnimated)
                    }
                }
            }
        }
    }
}


extension LEYAsset {
    open class func resize(by:LEYAsset.Resize.RawValue, _ targetSize:CGSize, _ fixedSize:CGSize, _ floorAllowed:Bool) -> CGSize {
        var retValue = targetSize
        if targetSize.width == 0 || targetSize.height == 0 || fixedSize.width == 0 || fixedSize.height == 0 {
            return retValue
        }
        if by == LEYAsset.Resize.area.rawValue {
            let ratioValue = CGFloat(sqrtf(Float((retValue.width * retValue.height)/(fixedSize.width * fixedSize.height))))
            if ratioValue > 1 {
                retValue.width = retValue.width / ratioValue
                retValue.height = retValue.height / ratioValue
                
                if floorAllowed {
                    retValue.width = floor(retValue.width)
                    retValue.height = floor(retValue.height)
                }
            }
        }
        else if by == LEYAsset.Resize.side.rawValue {
            let ratioMaxValue = max(targetSize.width, targetSize.height)/max(fixedSize.width, fixedSize.height)
            let ratioMinValue = min(targetSize.width, targetSize.height)/min(fixedSize.width, fixedSize.height)
            let ratioValue = max(ratioMaxValue, ratioMinValue)
            if ratioValue > 1 {
                retValue.width = retValue.width / ratioValue
                retValue.height = retValue.height / ratioValue
                
                if floorAllowed {
                    retValue.width = floor(retValue.width)
                    retValue.height = floor(retValue.height)
                }
            }
        }
        else if by == LEYAsset.Resize.none.rawValue {
            
        }
        
        return retValue
    }
    
    open class func resize(_ image:UIImage, _ size:CGSize) -> UIImage? {
        if size.width <= 0 || size.height == 0 {
            return nil
        }
        if image.size.width * image.scale > size.width || image.size.height * image.scale > size.height {
            UIGraphicsBeginImageContext(size)
            image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return outputImage
        }
        return nil
    }
}


extension LEYAsset {
    @discardableResult
    open class func open(album: LEYApp.Completion<Bool, LEYAssetsViewController>?,
                         completion: LEYApp.Completion<Bool, LEYAsset.Output>?) -> LEYMixedViewController<LEYMixedNavigationController<LEYAssetsViewController>> {
        let vc = LEYMixedViewController<LEYMixedNavigationController<LEYAssetsViewController>>()
        vc.modalPresentationStyle = .fullScreen
        vc.viewController.viewController.wrapped.completion = completion
        album?(true, vc.viewController.viewController)
        if vc.viewController.viewController.wrapped.isOpenable {
            LEYAsset.Wrapped.open(vc.viewController.viewController.wrapped, vc: vc)
        }
        return vc
    }
    
    @discardableResult
    open class func openAlbum(minOfAssets:Int,
                              maxOfAssets:Int,
                              image : (minOfAssets:Int, maxOfAssets:Int, isIndex:Bool),
                              video : (minOfAssets:Int, maxOfAssets:Int, isIndex:Bool),
                              isMixable:Bool,
                              isAutoclosed:Bool,
                              
                              mediaType:PHAssetMediaType,
                              selectedIdentifiers:[String],
                              usedIdentifiers:[String],
                              outputResize:CGSize,
                              outputResizeBy:LEYAsset.Resize.RawValue,
                              outputUIImage:Bool,

                              imageClips:[LEYAsset.Clip],
                              
                              videoClipsAllowed:Bool,
                              videoClipsDuration:TimeInterval,
                              videoFileExtensions:[String],
                              
                              footer:(lhs:Bool, center:Bool, rhs:Bool),
                              
                              operation:LEYViewController.Operation,
                              naviController:LEYNavigationController,
                              isOpenable:Bool,
                              isCloseable:Bool,
                              isAnimated:Bool,
                              completion:LEYApp.Completion<Bool, LEYAsset.Output>?) -> LEYMixedViewController<LEYMixedNavigationController<LEYAssetsViewController>> {
        
        return LEYAsset.open(album: {(state:Bool, vc:LEYAssetsViewController) in
            //基础配置
            vc.wrapped.output.minOfAssets = minOfAssets
            vc.wrapped.output.maxOfAssets = maxOfAssets
            
            vc.wrapped.output.image.minOfAssets = image.minOfAssets
            vc.wrapped.output.image.maxOfAssets = image.maxOfAssets
            vc.wrapped.output.image.isIndex = image.isIndex
            vc.wrapped.output.video.minOfAssets = video.minOfAssets
            vc.wrapped.output.video.maxOfAssets = video.maxOfAssets
            vc.wrapped.output.video.isIndex = video.isIndex
            vc.wrapped.output.isMixable = isMixable
            vc.wrapped.output.isAutoclosed = isAutoclosed

            vc.wrapped.mediaType = mediaType
            vc.wrapped.usedIdentifiers = usedIdentifiers
            vc.wrapped.selectedIdentifiers = selectedIdentifiers
            
            //导出封面图相关
            vc.wrapped.outputResize = outputResize
            vc.wrapped.outputResizeBy = outputResizeBy
            vc.wrapped.outputUIImage = outputUIImage

            //图片
            vc.wrapped.imageClips = imageClips
            
            //视频
            vc.wrapped.videoClipsAllowed = videoClipsAllowed
            vc.wrapped.videoClipsDuration = videoClipsDuration
            vc.wrapped.videoFileExtensions = videoFileExtensions
            
            //底部按钮
            vc.wrapped.footer = (footer.lhs, footer.center, footer.rhs)
            
            //导航相关
            vc.wrapped.naviController = naviController
            vc.wrapped.operation = operation
            vc.wrapped.isOpenable = isOpenable
            vc.wrapped.isCloseable = isCloseable
            vc.wrapped.isAnimated = isAnimated
        },completion: completion)
    }
    
    @discardableResult
    open class func open(camera:LEYApp.Completion<Bool, LEYImagePickerController>?,
                         completion:LEYApp.Completion<Bool, LEYAsset.Output>?) -> LEYImagePickerController {
        
        let vc = LEYImagePickerController()
        vc.wrapped.completion = completion
        vc.delegate = vc
        vc.modalPresentationStyle = .fullScreen
        camera?(true, vc)
        LEYApp.authorization(LEYApp.AuthorizeType.camera, DispatchQueue.main, true) {[weak vc] (state) in
            guard let __vc = vc, state == LEYApp.AuthorizeState.authorized else {return}
            __vc.wrapped.naviController?.currentViewController?.present(__vc, animated: true, completion: nil)
        }
        return vc
    }
    
    
    //这个地方存在同时创建多个云阅交科的情况:采用信号量的方案来解决
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
            LEYAsset.Wrapped.semaphore.wait()
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
                LEYAsset.Wrapped.semaphore.signal()
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
                        LEYAsset.Wrapped.semaphore.signal()
                    })
                }
                else {
                    //不允许创建的话直接返回了
                    queue.async {
                        completion(nil)
                    }
                    LEYAsset.Wrapped.semaphore.signal()
                }
            }
        }
    }
    
    //5.保存图片到相册
    open class func saveImage(image: UIImage, name: String = LEYApp.name, queue:DispatchQueue = DispatchQueue.main, completion: ((_ state: LEYAsset.State, _ asset:PHAsset?) -> ())?) {
        LEYAsset.save(assets: [image], name: name, queue:queue, completion:{ (state, assets) in
            completion?(state, assets.first)
        })
    }
    
    //保存视频到相册
    open class func saveVideo(fileURL:URL, name: String = LEYApp.name, queue:DispatchQueue = DispatchQueue.main, completion: ((_ state: LEYAsset.State, _ asset:PHAsset?) -> ())?){
        LEYAsset.save(assets: [fileURL], name: name, queue:queue, completion:{ (state, assets) in
            completion?(state, assets.first)
        })
    }
    
    //保存视频/图片到系统相册
    open class func save(assets:[Any], name: String, queue:DispatchQueue, completion: ((_ state: LEYAsset.State, _ assets:[PHAsset]) -> ())?) {
        //相册授权
        LEYApp.authorization(.album, queue, false) { (status) in
            guard status == .authorized else {
                queue.async {
                    completion?(.denied, [])
                }
                return
            }
            
            //获取目标相册
            LEYAsset.fetchAlbum(name:name, queue:queue, isCreated:true, completion: { (album) in
                
                guard let album = album else {
                    queue.async {
                        completion?(.error, [])
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
                       completion?(.succeed, __assets)
                    }
                })
            })
        }
    }
}


extension LEYAsset {
    //获取所有的相册列表
    public class func outputAlbums(_ wrapped: LEYAsset.Wrapped, completion: ((_ outputAlbums:[LEYAlbum]) -> ())?) {
        
        var accessAlbums = [LEYAlbum]()
        
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
                        let album = LEYAlbum(title: collection.localizedTitle ?? "", fetchResults: [fetchResult], wrapped:wrapped)
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
    
    public class  func outputAssets(_ wrapped: LEYAsset.Wrapped, completion:LEYApp.Completion<Bool, [LEYAsset]>?){
        let outputAssets = wrapped.output.assets.map { (__leyAsset) -> LEYAsset in
            let __outputAsset = LEYAsset(asset: __leyAsset.asset, fileExtensions:wrapped.videoFileExtensions)
            __outputAsset.thumbnail = __leyAsset.thumbnail
            __outputAsset.image = __leyAsset.image
            return __outputAsset
        }
        
        DispatchQueue.main.async {
            LEYApp.showAnimation("")
        }
        
        DispatchQueue.global().async {
            let group = DispatchGroup()
            let semaphore = DispatchSemaphore(value: 3)
            
            for __outputAsset in outputAssets {
                group.enter()
                semaphore.wait()
                
                if let __phasset = __outputAsset.asset {
                    let request = LEYAsset.Request()
                    request.size = LEYAsset.resize(by: wrapped.outputResizeBy, CGSize(width: __phasset.pixelWidth, height: __phasset.pixelHeight), wrapped.outputResize, true)
                    request.iCloud = LEYAsset.Wrapped.iCloud
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
                LEYApp.hideAnimation(superview: UIApplication.shared.keyWindow)
                completion?(true, outputAssets)
            })
        }
    }
    
    
    @discardableResult
    open class func requestImageData(_ asset: PHAsset, _ isNetworkAccessAllowed:Bool, _ size:CGSize,  _ options:PHImageRequestOptions?, _ completion:LEYApp.Completion<Bool, UIImage?>?) -> PHImageRequestID {
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
                    LEYApp.log{return "inCloud progressValue=\(progress)"}
                }
            }
            
            return PHImageManager.default().requestImageData(for: asset, options: __options) { (data, dataUTI, orientation, info) in
                if LEYApp.isLoggable, var info = info {
                    info.removeValue(forKey: "PHImageFileDataKey")
                    LEYApp.log{return info}
                }
                
                if let __data = data, let image = UIImage(data: __data) {
                    let outputImage = LEYAsset.resize(image, size) ?? image
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
                if LEYApp.isLoggable, let info = info {
                    LEYApp.log{return info}
                }
                let dicValue = info as? [String:Any] ?? [:]
                //let isInCloud = LEYApp.get(bool: dicValue["PHImageResultIsInCloudKey"] as? Bool, false)
                let isDegraded = LEYApp.get(bool: dicValue["PHImageResultIsDegradedKey"] as? Bool, false)
                completion?(isDegraded, result)
            }
        }
    }
    
    @discardableResult
    open class func requestAVAsset(_ asset: PHAsset, _ options:PHVideoRequestOptions?, _ completion:LEYApp.Completion<Bool, AVAsset?>?) -> PHImageRequestID {
        var __options : PHVideoRequestOptions? = options
        if __options == nil {
            __options = PHVideoRequestOptions()
            __options?.deliveryMode = .automatic
            __options?.isNetworkAccessAllowed = true
            __options?.progressHandler = { (progress, error, stop, info) in
                LEYApp.log{return "inCloud progressValue=\(progress)"}
            }
        }
        return PHImageManager.default().requestAVAsset(forVideo: asset, options: __options) { (avasset, mix, info) in
            if LEYApp.isLoggable, let info = info {
                LEYApp.log{return info}
            }
            completion?(true, avasset)
        }
    }
}

open class LEYImagePickerController : UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public let wrapped = LEYAsset.Wrapped()
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //系统相册选图
        picker.dismiss(animated: false, completion: nil)

        //拍照
        var image : UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let __image = image, let fixed = UIImage.fixedOrientation(image: __image) {
            image = fixed
        }
        
        if let __image = image {
            LEYApp.showAnimation("正在保存", self.view)
            LEYAsset.saveImage(image: __image) {[weak self] (state, asset) in
                guard let self = self else {return}
                LEYApp.hideAnimation(superview: self.view)
                
                if let __asset = asset {
                    let leyAsset = LEYAsset(asset: __asset)
                    leyAsset.image = __image
                    leyAsset.thumbnail = __image
                    
                    let ctxs = LEYAsset.Output()
                    ctxs.assets.append(leyAsset)
                    ctxs.images.append(__image)
                    self.wrapped.completion?(true, ctxs)
                }
                else {
                    let ctxs = LEYAsset.Output()
                    self.wrapped.completion?(false, ctxs)
                }
            }
        }
        else {
            let ctxs = LEYAsset.Output()
            self.wrapped.completion?(false, ctxs)
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


open class LEYAssetViewCell: LEYCollectionViewCell{
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
        durationView.font = LEYApp.font(12, false)
        durationView.isHidden = true
        contentView.addSubview(durationView)
        
        indexView.layer.cornerRadius = 10
        indexView.layer.masksToBounds = true
        indexView.textColor = UIColor.white
        indexView.alpha = 0.85
        indexView.font = LEYApp.font(12, true)
        indexView.textAlignment = .center
        indexView.isUserInteractionEnabled = false
        contentView.addSubview(indexView)
        
        maskedView.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        contentView.addSubview(maskedView)
    }
    
    open override func updateSubviews(_ action: String, _ value: Any?){
        guard let asset = value as? LEYAsset, let phasset = asset.asset else {
            return
        }
        
        if let __thumbnail = asset.thumbnail {
            self.assetView.image = __thumbnail
        }
        else{
            PHCachingImageManager.default().requestImage(for: phasset,
                                                         targetSize: self.contentView.frame.size,
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
                indexView.backgroundColor = UIColor.white
            }
            else {
                indexView.text = asset.index
                indexView.backgroundColor = LEYApp.mainColor
            }
            maskedView.isHidden = true
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        assetView.frame = contentView.bounds
        durationView.frame = CGRect(x: 4, y: contentView.h-22, width: contentView.w-8, height: 22)
        indexView.frame = CGRect(x: contentView.w-20-5, y: 5, width: 20, height: 20)
        maskedView.frame = contentView.bounds
    }
}

public class LEYAlbum : LEYAction {
    var assets = [LEYAsset]() //保存自己之前生成的model
    var finalAssets = [LEYAsset]() //过滤之后的数据源
    
    var isBlockable = false //是否支持做过滤处理
    var isBlocked = true//默认是过滤过滤的
        
    convenience init(title: String, fetchResults: [PHFetchResult<AnyObject>], wrapped:LEYAsset.Wrapped) {
        self.init(title: title, value: nil, completion:nil)
        self.ctxs.update(LEYActionViewCell.self, "LEYActionViewCell")
                
        //生成LEYAsset对象
        for fetchResult in fetchResults {
            if let __fetchResult = fetchResult as? PHFetchResult<PHAsset> {
                for index in 0 ..< __fetchResult.count {
                    
                    let phasset = __fetchResult[index]
                    let __asset = LEYAsset(asset: phasset, fileExtensions:wrapped.videoFileExtensions)
                    __asset.isBlocked = wrapped.usedIdentifiers.contains(phasset.localIdentifier)
                    self.assets.append(__asset)
                    if !__asset.isBlocked {
                        self.finalAssets.append(__asset)
                    }
                }
            }
        }
        
        
        //获取封面
        if let asset = self.assets.first?.asset {
            var __size = CGSize.zero
            __size.width = floor((LEYDevice.width-12*2-2*3)/4.0)
            __size.height = __size.width
            PHImageManager.default().requestImage(for: asset,
                                                  targetSize: __size,
                                                  contentMode: .aspectFill,
                                                  options: nil) {[weak self]
                                                    (image, info) in
                                                    self?.asset.image = image
            }
        }
        
        self.isBlockable = (self.assets.count != self.finalAssets.count)
        
        self.ctxs.size = CGSize(width: LEYDevice.width, height: 80)
        self.asset.frame = CGRect(x: 16, y: 1, width: 78, height: 78)
        self.asset.radius = 0.0
        self.asset.isHidden = false
        
        self.title.frame = CGRect(x: 106, y: 19, width: LEYDevice.width-136, height: 22)
        self.title.value = title
        self.title.textAlignment = .left
        self.title.font = LEYApp.font(16, true)
        self.title.isHidden = false
        
        self.subtitle.frame = CGRect(x: 106, y: 43, width: LEYDevice.width-136, height: 18)
        self.subtitle.value = "\(self.assets.count)张"
        self.subtitle.font = LEYApp.font(14, false)
        self.subtitle.textAlignment = .left
        self.subtitle.isHidden = false
        
        self.access.isHidden = true
        
        self.arrow.isHidden = false
        self.arrow.frame = CGRect(x: self.ctxs.w - 16 - 6, y: (self.ctxs.h - 12)/2.0, width: 6, height: 12)
        self.arrow.image = LEYApp.image(named:"uiapp_arrow.png")
        
        self.separator.insets = UIEdgeInsets(top: 0, left: 106, bottom: 0, right: 0)
        self.separator.side = .bottom
    }
}
