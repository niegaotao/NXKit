//
//  NXAssetClipViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/11/1.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXAssetClipViewController: NXViewController {
    open var image: UIImage? = nil

    open var clips = NXKit.Wrappable<Int, [NXClip], [NXClip]> { __sender in
        __sender.key = -1
        __sender.value = []
    }

    public let backgroundView = NXCView<UIImageView>(frame: CGRect(x: 10, y: 10, width: NXKit.width - 20, height: NXKit.height - NXKit.safeAreaInsets.top - 44.0 - NXKit.safeAreaInsets.bottom - 20))
    public let clipboardView = NXClipboardView(frame: CGRect.zero)
    public let footerView = NXCView<UIScrollView>(frame: CGRect(x: 0, y: 0, width: NXKit.width, height: 80 + NXKit.safeAreaInsets.bottom))
    public var componentViews = [UILabel]()

    override open func viewDidLoad() {
        super.viewDidLoad()

        navigationView.title = "裁剪"

        contentView.clipsToBounds = true
        navigationView.rightView = NXNavigationView.Bar.forward(image: nil, title: "保存", completion: { [weak self] _ in
            self?.dispose("forward", nil)
        })

        setupSubviews()
    }

    override open func setupSubviews() {
        contentView.backgroundColor = NXKit.color(0x181818)

        backgroundView.backgroundColor = NXKit.color(0x181818)
        backgroundView.contentView.image = image
        backgroundView.contentView.contentMode = .scaleAspectFit
        contentView.addSubview(backgroundView)

        footerView.frame = CGRect(x: 0, y: contentView.height - footerView.height, width: footerView.width, height: footerView.height)
        footerView.backgroundColor = NXKit.color(0x181818)
        footerView.contentView.backgroundColor = NXKit.color(0x181818)
        footerView.setupSeparator(color: NXKit.separatorColor, ats: [])
        contentView.addSubview(footerView)

        if let image = image, image.size.width > 0 && image.size.height > 0, clips.value.count >= 1 {
            if clips.key < 0 || clips.key >= clips.value.count {
                clips.key = 0
            }

            if clips.value.count >= 2 {
                // 有多项可选
                var offset = CGRect(x: 15, y: 8, width: 52, height: 60)
                var ctx = CGRect(x: 15, y: 0, width: CGFloat(clips.value.count) * offset.size.width + CGFloat(clips.value.count - 1) * 10.0, height: offset.size.height)
                if (contentView.bounds.width - ctx.size.width) / 2.0 > ctx.origin.x {
                    ctx.origin.x = (contentView.bounds.width - ctx.size.width) / 2.0
                }
                offset.origin.x = ctx.origin.x

                for (index, clip) in clips.value.enumerated() {
                    let componentView = UILabel(frame: CGRect(x: offset.origin.x, y: offset.origin.y, width: offset.size.width, height: offset.size.height))
                    componentView.tag = index
                    componentView.font = NXKit.font(13)
                    componentView.textAlignment = .center
                    componentView.text = clip.name
                    componentView.layer.cornerRadius = 2.0
                    componentView.layer.masksToBounds = true
                    componentView.setupEvent(.tap) { [weak self] _, sender in
                        self?.dispose("footer", sender, nil)
                    }
                    if index == clips.key {
                        componentView.backgroundColor = UIColor.white
                        componentView.textColor = NXKit.color(0x181818)
                    } else {
                        componentView.backgroundColor = NXKit.color(0x3D3D3D)
                        componentView.textColor = UIColor.white
                    }
                    footerView.contentView.addSubview(componentView)
                    componentViews.append(componentView)

                    if index == clips.value.count - 1 {
                        offset.origin.x = offset.origin.x + componentView.frame.size.width
                    } else {
                        offset.origin.x = offset.origin.x + componentView.frame.size.width + 10
                    }
                }
                offset.origin.x = offset.origin.x + ctx.origin.x
                footerView.isHidden = false
                footerView.contentView.frame = CGRect(x: 0, y: 0, width: contentView.bounds.width, height: 80)
                footerView.contentView.contentSize = CGSize(width: max(footerView.contentView.frame.size.width, offset.origin.x), height: 80)
            } else {
                // 仅有一项
                footerView.isHidden = true
            }

            clipboardView.backgroundColor = UIColor.clear
            backgroundView.addSubview(clipboardView)
            layoutCropViews()
            let imageSize = clipboardView.bounds.size

            let clip = clips.value[clips.key]
            clipboardView.ctxs.clip.isResizable = clip.isResizable
            clipboardView.ctxs.clip.width = clip.width
            clipboardView.ctxs.clip.height = clip.height
            if clipboardView.ctxs.clip.width <= 0 || clipboardView.ctxs.clip.height <= 0 {
                clipboardView.ctxs.clip.width = imageSize.width
                clipboardView.ctxs.clip.height = imageSize.height
            }
            clipboardView.ctxs.clip.isHidden = clip.isHidden

            clipboardView.updateSubviews(nil)

        } else {
            clipboardView.isHidden = true
            footerView.isHidden = true
        }
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutCropViews()
    }

    private func layoutCropViews() {
        guard let image = image, image.size.width > 0, image.size.height > 0,
              !clips.value.isEmpty else { return }
        let width = contentView.bounds.width
        let height = contentView.bounds.height
        let bottom = view.safeAreaInsets.bottom
        let optionsHeight: CGFloat = clips.value.count > 1 ? 80 : 0
        let footerHeight = min(height, optionsHeight + bottom)
        footerView.frame = CGRect(x: 0, y: height - footerHeight, width: width, height: footerHeight)
        footerView.contentView.frame = CGRect(x: 0, y: 0, width: width, height: optionsHeight)
        let itemsWidth = CGFloat(componentViews.count) * 62 - 10
        let itemStartX = max(15, (width - itemsWidth) / 2)
        for (index, item) in componentViews.enumerated() {
            item.frame.origin.x = itemStartX + 62 * CGFloat(index)
        }
        footerView.contentView.contentSize = CGSize(width: max(width, itemStartX + itemsWidth + 15),
                                                   height: optionsHeight)

        let available = CGRect(x: 10, y: 10, width: max(0, width - 20),
                               height: max(0, height - footerHeight - 20))
        let scale = min(available.width / image.size.width, available.height / image.size.height)
        guard scale > 0 else { return }
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let imageFrame = CGRect(x: (available.width - size.width) / 2,
                                y: (available.height - size.height) / 2,
                                width: size.width, height: size.height)
        let oldSize = clipboardView.bounds.size
        backgroundView.frame = available
        backgroundView.contentView.frame = imageFrame
        clipboardView.frame = imageFrame
        clipboardView.ctxs.size = size

        // 保留用户在原图中的选区，随显示比例同步缩放。
        if oldSize.width > 0, oldSize.height > 0, oldSize != size {
            let transform = CGAffineTransform(scaleX: size.width / oldSize.width,
                                              y: size.height / oldSize.height)
            let selection = clipboardView.ctxs.frame
            selection.oldValue = selection.oldValue.applying(transform)
            selection.value = selection.value.applying(transform)
            clipboardView.wrappedView.frame = selection.value
        }
    }

    override open func dispose(_ action: String, _ value: Any?, _: NXKit.Event<String, Any?>? = nil) {
        if action == "forward" {
            guard let image = image, image.size.width > 0 && image.size.height > 0, clipboardView.frame.size.width > 0 else {
                ctxs.event?("", nil)
                return
            }

            var pfsValue: (size: CGSize, scale: CGFloat, frame: CGRect) = (CGSize.zero, 1.0, CGRect.zero)
            pfsValue.size.width = image.size.width * image.scale
            pfsValue.size.height = image.size.height * image.scale
            pfsValue.scale = pfsValue.size.width / clipboardView.frame.size.width
            pfsValue.frame = clipboardView.wrappedView.frame
            pfsValue.frame.origin.x = floor(pfsValue.frame.origin.x * pfsValue.scale)
            pfsValue.frame.origin.y = floor(pfsValue.frame.origin.y * pfsValue.scale)
            pfsValue.frame.size.width = floor(pfsValue.frame.size.width * pfsValue.scale)
            pfsValue.frame.size.height = floor(pfsValue.frame.size.height * pfsValue.scale)

            guard let cgImage = image.cgImage?.cropping(to: pfsValue.frame) else {
                ctxs.event?("", nil)
                return
            }
            let uiImage = UIImage(cgImage: cgImage)
            ctxs.event?("", uiImage)
        } else if action == "footer" {
            guard let sender = value as? UILabel, sender.tag != self.clips.key else {
                return
            }
            clips.key = sender.tag

            for (index, componentView) in componentViews.enumerated() {
                if index == clips.key {
                    componentView.backgroundColor = UIColor.white
                    componentView.textColor = NXKit.color(0x181818)
                } else {
                    componentView.backgroundColor = NXKit.color(0x3D3D3D)
                    componentView.textColor = UIColor.white
                }
            }

            clipboardView.ctxs.clip.isResizable = clips.value[clips.key].isResizable
            clipboardView.ctxs.clip.width = clips.value[clips.key].width
            clipboardView.ctxs.clip.height = clips.value[clips.key].height
            clipboardView.ctxs.clip.isHidden = clips.value[clips.key].isHidden

            clipboardView.updateSubviews(nil)
        }
    }
}
