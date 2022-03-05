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
    
    convenience public init(asset: PHAsset?, suffixes:[String] = []) {
        self.init()
        
        if let __asset = asset {
            self.asset = __asset
            self.mediaType = __asset.mediaType
            
            self.size = CGSize(width: __asset.pixelWidth, height: __asset.pixelHeight)
            self.duration = __asset.duration
            self.filename = NX.get(string: __asset.value(forKey: "filename") as? String, "")
            
            if __asset.mediaType == .video {
                let __filename = self.filename.lowercased()
                if suffixes.count > 0 {
                    self.isSelectable = suffixes.contains { (suffix) -> Bool in
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
        durationView.font = NX.font(12, false)
        durationView.isHidden = true
        contentView.addSubview(durationView)
        
        selectionView.setupEvents([.touchUpInside]) {[weak self] event, sender in
            if let self = self, let asset = self.value as? NXAsset {
                asset.completion?(true, asset)
            }
        }
        contentView.addSubview(selectionView)
        
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
        self.value = asset
        
        if let __thumbnail = asset.thumbnail {
            self.assetView.image = __thumbnail
        }
        else{
            PHCachingImageManager.default().requestImage(for: phasset,
                                                            targetSize: CGSize(width: NXUI.width, height: NXUI.width),
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
        selectionView.frame = CGRect(x: contentView.w-40, y: 0, width: 40, height: 40)
        indexView.frame = CGRect(x: contentView.w-23-5, y: 5, width: 23, height: 23)
        maskedView.frame = contentView.bounds
    }
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
        
        public override init() {
            super.init()
            self.image.suffixes = []
            self.video.suffixes = [".mp4", ".mov"]
        }
        
        //图片相关，导出封面图相关
        open var isMixable = false
        open var clips = [NXAsset.Clip]()//具体的宽高比例
        open var duration : TimeInterval = 0.0//最大视频时长，0表示无限制
        open var resize = CGSize(width: 1920, height: 1920)//导出尺寸
        open var resizeBy = NXResize.side//导出size计算方法
        open var isOutputable = true //是否需要导出UIImage
        open var isOutputting  = false //是否正在导出UIImage
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
    
    open class Wrapped : Output {
        //创建相册信号量
        public static var semaphore = DispatchSemaphore(value: 1)
        //是否优先请求全高清图像
        public static var iCloud = true
        //容器视图
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
        open var completion : NX.Completion<Bool, NXAsset.Output>? = nil//最后的回调
        
        //操作按钮
        open var subviews : (preview:Bool, camera:Bool, output:Bool) = (false, false, false)
        
        //处理数据
        public func close(assets:[NXAsset]){
            let output = NXAsset.Output()
            output.assets = assets
            output.contentViewController = self.contentViewController
            self.completion?(true, output)
        }
    }
    
    open class Observer : NSObject, PHPhotoLibraryChangeObserver {
        open var completion : NX.Completion<String, Any?>? = nil//最后的回调
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
    open class func album(open: NX.Completion<Bool, NXAlbumViewController>?,
                          completion: NX.Completion<Bool, NXAsset.Output>?) {
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
    
    open class func camera(open:NX.Completion<Bool, NXCameraViewController>?,
                         completion:NX.Completion<Bool, NXAsset.Output>?) {
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
                            wrapped.add(asset)
                            break
                        }
                    }
                }
            }
        }
        
        completion?(accessAlbums)
    }
    
    public class  func outputAssets(_ assets:[NXAsset], _ wrapped: NXAsset.Wrapped, completion:NX.Completion<Bool, [NXAsset]>?){
        let outputAssets = assets.map { (nxAsset) -> NXAsset in
            let outputAsset = NXAsset(asset: nxAsset.asset, suffixes:wrapped.video.suffixes)
            outputAsset.thumbnail = nxAsset.thumbnail
            outputAsset.image = nxAsset.image
            return outputAsset
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
                    request.size = NXResize.resize(by: wrapped.resizeBy, CGSize(width: __phasset.pixelWidth, height: __phasset.pixelHeight), wrapped.resize, true)
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
