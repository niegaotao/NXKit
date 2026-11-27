//
//  NXCollectionViewLayouter.swift
//  NXKit
//
//  Created by niegaotao on 2022/3/18.
//  Copyright (c) 2022 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionViewLayouter : UICollectionViewLayout {
    
    open class Column: NXAny {
        open var index = Int.zero //处在第几个列
        open var count = Int.zero //已经加入的对象的个数
        open var offset = CGPoint.zero //偏移
        open var width = CGFloat.zero//宽度
        init(index:Int, count:Int, offset:CGPoint){
            super.init()
            self.index = index
            self.count = count
            self.offset = offset
        }
        
        public required init() {
            super.init()
        }
    }
    
    open var size = CGSize(width: 0, height: 0)
    open var insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    open private(set) var numberOfColumns : Int = 1
    open private(set) var columns = [Column]()
    open private(set) var direction = UICollectionView.ScrollDirection.vertical
    open private(set) var added = 0;
    
    public init(size:CGSize, insets:UIEdgeInsets, numberOfColumns:Int, direction:UICollectionView.ScrollDirection){
        super.init()
        self.size = size
        self.insets = insets
        self.numberOfColumns = max(numberOfColumns, 1)
        self.direction = direction
        
        while(self.columns.count < self.numberOfColumns) {
            self.columns.append(Column(index: self.columns.count, count: 0, offset: CGPoint.zero))
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        while(self.columns.count < self.numberOfColumns) {
            self.columns.append(Column(index: self.columns.count, count: 0, offset: CGPoint.zero))
        }
    }
    
    open func clear() {
        self.added = 0
        self.columns.forEach { e in
            e.offset.y = 0
            e.count = 0
        }
    }
    
    open func sizeAttributes(type:String, section: NXSection) -> CGSize {
        var __size = CGSize.zero
        if self.direction == .vertical {
            if type == NXItem.View.cell.rawValue {
                let whitespace = self.insets.left + section.insets.left + section.interitemSpacing * CGFloat(self.numberOfColumns - 1) +  section.insets.right + self.insets.right
                __size.width = (self.size.width - whitespace)/CGFloat(self.numberOfColumns)
            }
            else {
                let whitespace = self.insets.left + self.insets.right
                __size.width = self.size.width - whitespace
            }
        }
        else if self.direction == .horizontal {
            if type == NXItem.View.cell.rawValue {
                let whitespace = self.insets.top + section.insets.top + section.interitemSpacing * CGFloat(self.numberOfColumns - 1) +  section.insets.bottom + self.insets.bottom
                __size.height = (self.size.height - whitespace)/CGFloat(self.numberOfColumns)
            }
            else {
                let whitespace = self.insets.top + self.insets.bottom
                __size.height = self.size.height - whitespace
            }
        }
        return __size
    }
    
    open func updateAttributes(_ attributes: UICollectionViewLayoutAttributes, type:String, size:CGSize, section: NXSection, sections:[NXSection]) {
        var __frame = CGRect.zero
        __frame.size = size
        
        if self.direction == .vertical {
            let index = sections.firstIndex(of: section) ?? -1
            
            if type == NXItem.View.cell.rawValue {
                //1.找出插入到哪一列
                var column = self.columns[0]
                for __column in self.columns {
                    if __column.offset.y < column.offset.y {
                        column = __column
                    }
                }
                
                //2.插入数据
                __frame.origin.x = self.insets.left +  section.insets.left + (__frame.width + section.interitemSpacing) * CGFloat(column.index)
                if column.count == 0 && section.header == nil{
                    if index == 0 {
                        column.offset.y = column.offset.y + self.insets.top + section.insets.top
                    }
                    else {
                        column.offset.y = column.offset.y + section.insets.top
                    }
                    __frame.origin.y = column.offset.y
                }
                else {
                    column.offset.y = column.offset.y + section.lineSpacing
                    __frame.origin.y = column.offset.y
                }
                column.offset.y = column.offset.y + __frame.size.height
                column.count = column.count + 1
                
                if index >= 0 {
                    attributes.indexPath = IndexPath(row: self.added, section: index)
                }
                else {
                    attributes.indexPath = IndexPath(row: self.added, section: 0)
                }
                attributes.frame = __frame
                self.added = self.added + 1
            }
            else if type == NXItem.View.header.rawValue {
                //1.找出插入到哪一列
                var column = self.columns[0]
                for __column in self.columns {
                    if __column.offset.y > column.offset.y {
                        column = __column
                    }
                }
                
                //2.插入数据
                __frame.origin.x = self.insets.left +  section.insets.left
                
                if index == 0 {
                    column.offset.y = self.insets.top + section.insets.top
                }
                else {
                    column.offset.y = section.insets.top
                }
                __frame.origin.y = column.offset.y
                column.offset.y = column.offset.y + __frame.size.height
                
                //3.更新其他列的偏移
                for e in self.columns {
                    e.offset.y = column.offset.y
                }
                if index >= 0 {
                    attributes.indexPath = IndexPath(index: index)
                }
                else {
                    attributes.indexPath = IndexPath(index: 0)
                }
                attributes.frame = __frame
            }
            else if type == NXItem.View.footer.rawValue {
                //1.找出插入到哪一列
                var column = self.columns[0]
                for __column in self.columns {
                    if __column.offset.y > column.offset.y {
                        column = __column
                    }
                }
                
                //2.插入数据
                __frame.origin.x = self.insets.left +  section.insets.left
                __frame.origin.y = column.offset.y
                column.offset.y = column.offset.y + __frame.size.height
                if index == sections.count-1 {
                    column.offset.y = column.offset.y + section.insets.bottom
                }
                
                //3.更新其他列的偏移
                for __column in self.columns {
                    __column.offset = column.offset
                }
                
                if index >= 0 {
                    attributes.indexPath = IndexPath(index: index)
                }
                else {
                    attributes.indexPath = IndexPath(index: 0)
                }
                attributes.frame = __frame
            }
        }
        else {
            //1.找出插入到哪一列
            var column = self.columns[0]
            for __column in self.columns {
                if __column.offset.x < column.offset.x {
                    column = __column
                }
            }
            
            //2.插入数据
            __frame.origin.y = self.insets.top +  section.insets.top + (__frame.height + section.interitemSpacing) * CGFloat(column.index)
            if column.count == 0 {
                column.offset.x = self.insets.left + section.insets.left
                __frame.origin.x = column.offset.x
            }
            else {
                column.offset.x = column.offset.x + section.lineSpacing
                __frame.origin.x = column.offset.x
            }
            column.offset.x = column.offset.x + __frame.size.width
            column.count = column.count + 1
            
            attributes.indexPath = IndexPath(row: self.added, section: 0)
            attributes.frame = __frame
            self.added = self.added + 1
        }
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attribute : UICollectionViewLayoutAttributes? = nil

        if let data = (self.collectionView as? NXCollectionView)?.data, let section = data[indexPath.section] {
            if elementKind == UICollectionView.elementKindSectionHeader {
                attribute = (section.header as? NXCollectionViewAttributesProtocol)?.attributes
            }
            if elementKind == UICollectionView.elementKindSectionFooter {
                attribute = (section.footer as? NXCollectionViewAttributesProtocol)?.attributes
            }
        }
        
        return attribute
    }
    
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let data = (self.collectionView as? NXCollectionView)?.data {
            return (data[indexPath] as? NXCollectionViewAttributesProtocol)?.attributes
        }
        return nil
    }
    
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if let data = (self.collectionView as? NXCollectionView)?.data {
            
            for section in data.elements {
                
                for item in section.elements {
                    if let item  = item as? NXCollectionViewAttributesProtocol {
                        if rect.intersects(item.attributes.frame) {
                            attributes.append(item.attributes)
                        }
                    }
                }
                
                if let item  = section.header as? NXCollectionViewAttributesProtocol {
                    if rect.intersects(item.attributes.frame) {
                        attributes.append(item.attributes)
                    }
                }
                
                if let item  = section.footer as? NXCollectionViewAttributesProtocol {
                    if rect.intersects(item.attributes.frame) {
                        attributes.append(item.attributes)
                    }
                }
            }
        }
        return attributes
    }

    
    
    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    open override var collectionViewContentSize: CGSize {
        var size = self.size
        var column = self.columns[0]
        for __column in self.columns {
            if __column.offset.y > column.offset.y {
                column = __column
            }
        }
        if let section = (self.collectionView as? NXCollectionView)?.data?.elements.last {
            if self.direction == .vertical {
                size.height = max(size.height, column.offset.y + section.insets.bottom + self.insets.bottom)
            }
            else {
                size.width = max(size.width, column.offset.y + section.insets.bottom + self.insets.right)
            }
        }
        else {
            if self.direction == .vertical {
                size.height = max(size.height, column.offset.x + self.insets.bottom)
            }
            else {
                size.width = max(size.width, column.offset.x + self.insets.right)
            }
        }
        
        return size
    }
}
