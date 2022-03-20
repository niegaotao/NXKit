//
//  NXCollectionViewLinearWorker.swift
//  NXKit
//
//  Created by 聂高涛 on 2022/3/18.
//

import UIKit

open class NXCollectionViewLinearWorker : UICollectionViewLayout {
    
    open class Column: NXAny {
        open var index = 0 //处在第几个列
        open var count = 0 //已经加入的对象的个数
        open var offset : CGFloat = 0 //偏移
        init(index:Int, count:Int, offset:CGFloat){
            super.init()
            self.index = index
            self.count = count
            self.offset = offset
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
            self.columns.append(Column(index: self.columns.count, count: 0, offset: 0.0))
        }
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        while(self.columns.count < self.numberOfColumns) {
            self.columns.append(Column(index: self.columns.count, count: 0, offset: 0.0))
        }
    }
    
    open func clear() {
        self.added = 0
        self.columns.forEach { e in
            e.offset = 0
            e.count = 0
        }
    }
    
    open func updateAttributes(_ attributes: UICollectionViewLayoutAttributes, type:String, size:CGSize, section: NXSection<NXItem>, sections:[NXSection<NXItem>]) {
        var __frame = CGRect.zero
        
        if self.direction == .vertical {
            let index = sections.firstIndex(of: section) ?? -1
            
            if type == NXCollectionDequeue.cell.rawValue {
                //1.确定元素显示的大小
                let whitespace = self.insets.left + section.insets.left + section.interitemSpacing * CGFloat(self.numberOfColumns - 1) +  section.insets.right + self.insets.right
                __frame.size.width = (self.size.width - whitespace)/CGFloat(self.numberOfColumns)
                __frame.size.height = __frame.width * (size.height / size.width)
                
                //2.找出插入到哪一列
                var target = self.columns[0]
                for e in self.columns {
                    if e.offset < target.offset {
                        target = e
                    }
                }
                
                //3.插入数据
                __frame.origin.x = self.insets.left +  section.insets.left + (__frame.width + section.interitemSpacing) * CGFloat(target.index)
                if target.count == 0 && section.header == nil{
                    if index == 0 {
                        target.offset = target.offset + self.insets.top + section.insets.top
                    }
                    else {
                        target.offset = target.offset + section.insets.top
                    }
                    __frame.origin.y = target.offset
                }
                else {
                    target.offset = target.offset + section.lineSpacing
                    __frame.origin.y = target.offset
                }
                target.offset = target.offset + __frame.size.height
                target.count = target.count + 1
                
                if index >= 0 {
                    attributes.indexPath = IndexPath(row: self.added, section: index)
                }
                else {
                    attributes.indexPath = IndexPath(row: self.added, section: 0)
                }
                attributes.frame = __frame
                self.added = self.added + 1
            }
            else if type == NXCollectionDequeue.header.rawValue {
                //1.确定元素显示的大小
                let whitespace = self.insets.left + section.insets.left + section.insets.right + self.insets.right
                __frame.size.width = self.size.width - whitespace
                __frame.size.height = size.height
                
                //2.找出插入到哪一列
                var target = self.columns[0]
                for e in self.columns {
                    if e.offset > target.offset {
                        target = e
                    }
                }
                
                //3.插入数据
                __frame.origin.x = self.insets.left +  section.insets.left
                
                if index == 0 {
                    target.offset = self.insets.top + section.insets.top
                }
                else {
                    target.offset = section.insets.top
                }
                __frame.origin.y = target.offset
                target.offset = target.offset + __frame.size.height
                
                //更新其他列的偏移
                for e in self.columns {
                    e.offset = target.offset
                }
                if index >= 0 {
                    attributes.indexPath = IndexPath(index: index)
                }
                else {
                    attributes.indexPath = IndexPath(index: 0)
                }
                attributes.frame = __frame
            }
            else if type == NXCollectionDequeue.footer.rawValue {
                //1.确定元素显示的大小
                let whitespace = self.insets.left + section.insets.left + section.insets.right + self.insets.right
                __frame.size.width = self.size.width - whitespace
                __frame.size.height = size.height
                
                //2.找出插入到哪一列
                var target = self.columns[0]
                for e in self.columns {
                    if e.offset > target.offset {
                        target = e
                    }
                }
                
                //3.插入数据
                __frame.origin.x = self.insets.left +  section.insets.left
                __frame.origin.y = target.offset
                target.offset = target.offset + __frame.size.height
                if index == sections.count-1 {
                    target.offset = target.offset + section.insets.bottom
                }
                
                //更新其他列的偏移
                for e in self.columns {
                    e.offset = target.offset
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
            //1.确定元素现实的大小
            let whitespace = self.insets.top + section.insets.top + section.interitemSpacing * CGFloat(self.numberOfColumns - 1) +  section.insets.bottom + self.insets.bottom
            __frame.size.height = (self.size.height - whitespace)/CGFloat(self.numberOfColumns)
            __frame.size.width = __frame.height * (size.width / size.height)
            
            //2.找出插入到哪一列
            var target = self.columns[0]
            for e in self.columns {
                if e.offset < target.offset {
                    target = e
                }
            }
            
            //3.插入数据
            __frame.origin.y = self.insets.top +  section.insets.top + (__frame.height + section.interitemSpacing) * CGFloat(target.index)
            if target.count == 0 {
                target.offset = self.insets.left + section.insets.left
                __frame.origin.x = target.offset
            }
            else {
                target.offset = target.offset + section.lineSpacing
                __frame.origin.x = target.offset
            }
            target.offset = target.offset + __frame.size.width
            target.count = target.count + 1
            
            attributes.indexPath = IndexPath(row: self.added, section: 0)
            attributes.frame = __frame
            self.added = self.added + 1
        }
        
        
    }
    
    open override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attribute : UICollectionViewLayoutAttributes? = nil

        if let wrappedData = (self.collectionView as? NXCollectionView)?.wrappedData, let section = wrappedData[indexPath.section] {
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
        if let wrappedData = (self.collectionView as? NXCollectionView)?.wrappedData {
            return (wrappedData[indexPath] as? NXCollectionViewAttributesProtocol)?.attributes
        }
        return nil
    }
    
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if let wrappedData = (self.collectionView as? NXCollectionView)?.wrappedData {
            
            for section in wrappedData.sections {
                
                
                
                for item in section.items {
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
        var target = self.columns[0]
        for e in self.columns {
            if e.offset > target.offset {
                target = e
            }
        }
        if let section = (self.collectionView as? NXCollectionView)?.wrappedData?.sections.last {
            if self.direction == .vertical {
                size.height = max(size.height, target.offset + section.insets.bottom + self.insets.bottom)
            }
            else {
                size.width = max(size.width, target.offset + section.insets.bottom + self.insets.right)
            }
        }
        else {
            if self.direction == .vertical {
                size.height = max(size.height, target.offset + self.insets.bottom)
            }
            else {
                size.width = max(size.width, target.offset + self.insets.right)
            }
        }
        
        return size
    }
}
