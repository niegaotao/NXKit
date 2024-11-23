//
//  NXCameraCaptureController.swift
//  NXKit
//
//  Created by niegaotao on 2022/3/5.
//  Copyright (c) 2022 niegaotao. All rights reserved.
//

import UIKit

open class NXCameraCaptureController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func getWrapped() -> NXAsset.Wrapped { wrapped }

    private let wrapped = NXAsset.Wrapped()

    public func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // 拍照
        var image: UIImage? = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let __image = image, let fixed = UIImage.fixedOrientation(image: __image) {
            image = fixed
        }

        if let __image = image {
            NXKit.showLoading("正在保存", .center, view)
            NXAsset.saveImage(image: __image) { [weak self] _, asset in
                guard let self = self else { return }
                NXKit.hideLoading(superview: self.view)

                if let __asset = asset {
                    let nxAsset = NXAsset(wrappedValue: __asset)
                    nxAsset.image = __image
                    nxAsset.thumbnail = __image

                    self.wrapped.close(assets: [nxAsset])
                } else {
                    self.wrapped.close(assets: [])
                }
            }
        } else {
            wrapped.close(assets: [])
        }
    }

    public func imagePickerControllerDidCancel(_: UIImagePickerController) {
        wrapped.close(assets: [])
    }
}
