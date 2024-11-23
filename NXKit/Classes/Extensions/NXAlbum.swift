//
//  NXAlbum.swift
//  NXKit
//
//  Created by niegaotao on 2022/1/5.
//  Copyright (c) 2022 niegaotao. All rights reserved.
//

import UIKit
import Photos


open class NXAlbum : NXAbstract {
    public var assets = [NXAsset]() //保存自己之前生成的model
        
    convenience public init(title: String, fetchResult: PHFetchResult<AnyObject>?, wrapped: NXAsset.Wrapped) {
        self.init(title: title, value: nil, completion:nil)
        self.reuse.cls = NXActionViewCell.self
        self.reuse.id = "NXActionViewCell"
        
        //生成NXAsset对象
        if let __fetchResult = fetchResult as? PHFetchResult<PHAsset> {
            for index in 0 ..< __fetchResult.count {
                let phasset = __fetchResult[index]
                let __asset = NXAsset(wrappedValue: phasset, suffixes:wrapped.video.suffixes)
                self.assets.append(__asset)
            }
        }
        
        //获取封面
        if let __asset = self.assets.last, let phasset = __asset.wrappedValue as? PHAsset {
            if let __thumbnail = __asset.thumbnail {
                self.asset.image = __thumbnail
            }
            else{
                PHCachingImageManager.default().requestImage(for: phasset,
                                                                targetSize: NXAsset.Wrapped.size,
                                                             contentMode: .aspectFill,
                                                             options: nil) {[weak self](image, info) in
                    __asset.thumbnail = image
                    self?.asset.image = image
                }
            }
        }
                
        self.size = CGSize(width: NXKit.width, height: 80)
        self.asset.frame = CGRect(x: 16, y: 1, width: 78, height: 78)
        self.asset.cornerRadius = 0.0
        self.asset.isHidden = false
        
        self.title.frame = CGRect(x: 106, y: 19, width: NXKit.width-136, height: 22)
        self.title.value = title
        self.title.textAlignment = .left
        self.title.font = NXKit.font(16, .bold)
        self.title.isHidden = false
        
        self.subtitle.frame = CGRect(x: 106, y: 43, width: NXKit.width-136, height: 18)
        self.subtitle.value = "\(self.assets.count)张"
        self.subtitle.font = NXKit.font(14, .regular)
        self.subtitle.textAlignment = .left
        self.subtitle.isHidden = false
        
        self.value.isHidden = true
        
        self.arrow.isHidden = false
        self.arrow.frame = CGRect(x: self.size.width - 16 - 6, y: (self.size.height - 12)/2.0, width: 6, height: 12)
        self.arrow.image = NXKit.image(named:"icon-arrow.png")
        
        self.raw.separator.insets = UIEdgeInsets(top: 0, left: 106, bottom: 0, right: 0)
        self.raw.separator.ats = .maxY
    }
}


