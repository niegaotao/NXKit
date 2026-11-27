//
//  NXAlbum.swift
//  NXKit
//
//  Created by niegaotao on 2022/1/5.
//  Copyright (c) 2022 niegaotao. All rights reserved.
//

import Photos
import UIKit

open class NXAlbum: NXAbstract {
    public var assets = [NXAsset]() // 保存自己之前生成的model

    public convenience init(title: String, fetchResult: PHFetchResult<AnyObject>?, wrapped: NXAsset.Wrapped) {
        self.init(title: title, value: nil, completion: nil)
        reuse.cls = NXActionViewCell.self
        reuse.id = "NXActionViewCell"

        // 生成NXAsset对象
        if let __fetchResult = fetchResult as? PHFetchResult<PHAsset> {
            for index in 0 ..< __fetchResult.count {
                let phasset = __fetchResult[index]
                let __asset = NXAsset(wrappedValue: phasset, suffixes: wrapped.video.suffixes)
                assets.append(__asset)
            }
        }

        // 获取封面
        if let __asset = assets.last, let phasset = __asset.wrappedValue as? PHAsset {
            if let __thumbnail = __asset.thumbnail {
                asset.image = __thumbnail
            } else {
                PHCachingImageManager.default().requestImage(for: phasset,
                                                             targetSize: NXAsset.Wrapped.size,
                                                             contentMode: .aspectFill,
                                                             options: nil)
                { [weak self] image, _ in
                    __asset.thumbnail = image
                    self?.asset.image = image
                }
            }
        }

        size = CGSize(width: NXKit.width, height: 80)
        asset.frame = CGRect(x: 16, y: 1, width: 78, height: 78)
        asset.cornerRadius = 0.0
        asset.isHidden = false

        self.title.frame = CGRect(x: 106, y: 19, width: NXKit.width - 136, height: 22)
        self.title.value = title
        self.title.textAlignment = .left
        self.title.font = NXKit.font(16, .bold)
        self.title.isHidden = false

        subtitle.frame = CGRect(x: 106, y: 43, width: NXKit.width - 136, height: 18)
        subtitle.value = "\(assets.count)张"
        subtitle.font = NXKit.font(14, .regular)
        subtitle.textAlignment = .left
        subtitle.isHidden = false

        value.isHidden = true

        arrow.isHidden = false
        arrow.frame = CGRect(x: size.width - 16 - 6, y: (size.height - 12) / 2.0, width: 6, height: 12)
        arrow.image = NXKit.image(named: "icon-arrow.png")

        raw.separator.insets = UIEdgeInsets(top: 0, left: 106, bottom: 0, right: 0)
        raw.separator.ats = .maxY
    }
}
