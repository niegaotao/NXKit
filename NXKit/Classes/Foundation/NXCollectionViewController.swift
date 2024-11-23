//
//  NXCollectionViewController.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionViewController: NXViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public var collectionView = NXCollectionView(frame: CGRect.zero)
    public let data = NXCollection<NXCollectionView>()

    override open func viewDidLoad() {
        super.viewDidLoad()

        collectionView.frame = contentView.bounds
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = NXKit.viewBackgroundColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        contentView.addSubview(collectionView)
        collectionView.data = data
        data.wrappedView = collectionView
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }

    /// 代理方法数据源方法
    open func numberOfSections(in _: UICollectionView) -> Int {
        return data.count
    }

    open func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section]?.count ?? 0
    }

    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let rs = data.dequeue(collectionView, indexPath, NXItem.View.header.rawValue) {
                rs.reusableView.updateSubviews(rs.elelment)
                return rs.reusableView
            }
            //
        } else if kind == UICollectionView.elementKindSectionFooter {
            if let rs = data.dequeue(collectionView, indexPath, NXItem.View.footer.rawValue) {
                rs.reusableView.updateSubviews(rs.elelment)
                return rs.reusableView
            }
        }
        return UICollectionReusableView()
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let rs = data.dequeue(collectionView, indexPath) {
            rs.cell.updateSubviews(rs.element)
            return rs.cell
        }
        return NXCollectionViewCell()
    }

    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return data[section]?.insets ?? UIEdgeInsets.zero
    }

    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return data[section]?.lineSpacing ?? 0.0
    }

    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return data[section]?.interitemSpacing ?? 0.0
    }

    open func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return data[indexPath]?.size ?? CGSize(width: 1, height: 1)
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return data[section]?.header?.size ?? CGSize.zero
    }

    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return data[section]?.footer?.size ?? CGSize.zero
    }

    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
