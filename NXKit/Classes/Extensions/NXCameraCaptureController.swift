//
//  NXCameraCaptureController.swift
//  NXKit
//
//  Created by 聂高涛 on 2022/3/5.
//

import UIKit

open class NXCameraCaptureController: UIImagePickerController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func getWrapped() -> NXAsset.Wrapped { self.wrapped}
    
    private let wrapped = NXAsset.Wrapped()
    
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
                    let nxAsset = NXAsset(asset: __asset)
                    nxAsset.image = __image
                    nxAsset.thumbnail = __image
                    
                    self.wrapped.close(assets: [nxAsset])
                }
                else {
                    self.wrapped.close(assets: [])
                }
            }
        }
        else {
            self.wrapped.close(assets: [])
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.wrapped.close(assets: [])
    }
}
