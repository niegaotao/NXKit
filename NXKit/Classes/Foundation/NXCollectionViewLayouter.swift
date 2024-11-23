//
//  NXCollectionViewLayouter.swift
//  NXKit
//
//  Created by niegaotao on 2022/3/18.
//  Copyright (c) 2022 niegaotao. All rights reserved.
//

import UIKit

open class NXCollectionViewLayouter: UICollectionViewLayout {
    open class Column: NXAny {
        open var index = Int.zero // 处在第几个列
        open var count = Int.zero // 已经加入的对象的个数
        open var offset = CGPoint.zero // 偏移
        open var width = CGFloat.zero // 宽度
        init(index: Int, count: Int, offset: CGPoint) {
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
    open private(set) var numberOfColumns: Int = 1
    open private(set) var columns = [Column]()
    open private(set) var direction = UICollectionView.ScrollDirection.vertical
    open private(set) var added = 0

    public init(size: CGSize, insets: UIEdgeInsets, numberOfColumns: Int, direction: UICollectionView.ScrollDirection) {
        super.init()
        self.size = size
        self.insets = insets
        self.numberOfColumns = max(numberOfColumns, 1)
        self.direction = direction

        while columns.count < self.numberOfColumns {
            columns.append(Column(index: columns.count, count: 0, offset: CGPoint.zero))
        }
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        while columns.count < numberOfColumns {
            columns.append(Column(index: columns.count, count: 0, offset: CGPoint.zero))
        }
    }

    open func clear() {
        added = 0
        for e in columns {
            e.offset.y = 0
            e.count = 0
        }
    }

    open func sizeAttributes(type: String, section: NXSection) -> CGSize {
        var __size = CGSize.zero
        if direction == .vertical {
            if type == NXItem.View.cell.rawValue {
                let whitespace = insets.left + section.insets.left + section.interitemSpacing * CGFloat(numberOfColumns - 1) + section.insets.right + insets.right
                __size.width = (size.width - whitespace) / CGFloat(numberOfColumns)
            } else {
                let whitespace = insets.left + insets.right
                __size.width = size.width - whitespace
            }
        } else if direction == .horizontal {
            if type == NXItem.View.cell.rawValue {
                let whitespace = insets.top + section.insets.top + section.interitemSpacing * CGFloat(numberOfColumns - 1) + section.insets.bottom + insets.bottom
                __size.height = (size.height - whitespace) / CGFloat(numberOfColumns)
            } else {
                let whitespace = insets.top + insets.bottom
                __size.height = size.height - whitespace
            }
        }
        return __size
    }

    open func updateAttributes(_ attributes: UICollectionViewLayoutAttributes, type: String, size: CGSize, section: any NXArrayRepresentable, sections: [any NXArrayRepresentable]) {
        var __frame = CGRect.zero
        __frame.size = size

        if direction == .vertical {
            let index = sections.firstIndex { loopValue in ObjectIdentifier(loopValue) == ObjectIdentifier(section) } ?? -1

            if type == NXItem.View.cell.rawValue {
                // 1.找出插入到哪一列
                var column = columns[0]
                for __column in columns {
                    if __column.offset.y < column.offset.y {
                        column = __column
                    }
                }

                // 2.插入数据
                __frame.origin.x = insets.left + section.insets.left + (__frame.width + section.interitemSpacing) * CGFloat(column.index)
                if column.count == 0 && section.header == nil {
                    if index == 0 {
                        column.offset.y = column.offset.y + insets.top + section.insets.top
                    } else {
                        column.offset.y = column.offset.y + section.insets.top
                    }
                    __frame.origin.y = column.offset.y
                } else {
                    column.offset.y = column.offset.y + section.lineSpacing
                    __frame.origin.y = column.offset.y
                }
                column.offset.y = column.offset.y + __frame.size.height
                column.count = column.count + 1

                if index >= 0 {
                    attributes.indexPath = IndexPath(row: added, section: index)
                } else {
                    attributes.indexPath = IndexPath(row: added, section: 0)
                }
                attributes.frame = __frame
                added = added + 1
            } else if type == NXItem.View.header.rawValue {
                // 1.找出插入到哪一列
                var column = columns[0]
                for __column in columns {
                    if __column.offset.y > column.offset.y {
                        column = __column
                    }
                }

                // 2.插入数据
                __frame.origin.x = insets.left + section.insets.left

                if index == 0 {
                    column.offset.y = insets.top + section.insets.top
                } else {
                    column.offset.y = section.insets.top
                }
                __frame.origin.y = column.offset.y
                column.offset.y = column.offset.y + __frame.size.height

                // 3.更新其他列的偏移
                for e in columns {
                    e.offset.y = column.offset.y
                }
                if index >= 0 {
                    attributes.indexPath = IndexPath(index: index)
                } else {
                    attributes.indexPath = IndexPath(index: 0)
                }
                attributes.frame = __frame
            } else if type == NXItem.View.footer.rawValue {
                // 1.找出插入到哪一列
                var column = columns[0]
                for __column in columns {
                    if __column.offset.y > column.offset.y {
                        column = __column
                    }
                }

                // 2.插入数据
                __frame.origin.x = insets.left + section.insets.left
                __frame.origin.y = column.offset.y
                column.offset.y = column.offset.y + __frame.size.height
                if index == sections.count - 1 {
                    column.offset.y = column.offset.y + section.insets.bottom
                }

                // 3.更新其他列的偏移
                for __column in columns {
                    __column.offset = column.offset
                }

                if index >= 0 {
                    attributes.indexPath = IndexPath(index: index)
                } else {
                    attributes.indexPath = IndexPath(index: 0)
                }
                attributes.frame = __frame
            }
        } else {
            // 1.找出插入到哪一列
            var column = columns[0]
            for __column in columns {
                if __column.offset.x < column.offset.x {
                    column = __column
                }
            }

            // 2.插入数据
            __frame.origin.y = insets.top + section.insets.top + (__frame.height + section.interitemSpacing) * CGFloat(column.index)
            if column.count == 0 {
                column.offset.x = insets.left + section.insets.left
                __frame.origin.x = column.offset.x
            } else {
                column.offset.x = column.offset.x + section.lineSpacing
                __frame.origin.x = column.offset.x
            }
            column.offset.x = column.offset.x + __frame.size.width
            column.count = column.count + 1

            attributes.indexPath = IndexPath(row: added, section: 0)
            attributes.frame = __frame
            added = added + 1
        }
    }

    override open func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        var attribute: UICollectionViewLayoutAttributes? = nil

        if let data = (collectionView as? NXCollectionView)?.data, let section = data[indexPath.section] {
            if elementKind == UICollectionView.elementKindSectionHeader {
                attribute = (section.header as? NXCollectionViewAttributesProtocol)?.attributes
            }
            if elementKind == UICollectionView.elementKindSectionFooter {
                attribute = (section.footer as? NXCollectionViewAttributesProtocol)?.attributes
            }
        }

        return attribute
    }

    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let data = (collectionView as? NXCollectionView)?.data {
            return (data[indexPath] as? NXCollectionViewAttributesProtocol)?.attributes
        }
        return nil
    }

    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        if let data = (collectionView as? NXCollectionView)?.data {
            for section in data.elements {
                for item in section.elements {
                    if let item = item as? NXCollectionViewAttributesProtocol {
                        if rect.intersects(item.attributes.frame) {
                            attributes.append(item.attributes)
                        }
                    }
                }

                if let item = section.header as? NXCollectionViewAttributesProtocol {
                    if rect.intersects(item.attributes.frame) {
                        attributes.append(item.attributes)
                    }
                }

                if let item = section.footer as? NXCollectionViewAttributesProtocol {
                    if rect.intersects(item.attributes.frame) {
                        attributes.append(item.attributes)
                    }
                }
            }
        }
        return attributes
    }

    override open func shouldInvalidateLayout(forBoundsChange _: CGRect) -> Bool {
        return true
    }

    override open var collectionViewContentSize: CGSize {
        var size = self.size
        var column = columns[0]
        for __column in columns {
            if __column.offset.y > column.offset.y {
                column = __column
            }
        }
        if let section = (collectionView as? NXCollectionView)?.data?.elements.last {
            if direction == .vertical {
                size.height = max(size.height, column.offset.y + section.insets.bottom + insets.bottom)
            } else {
                size.width = max(size.width, column.offset.y + section.insets.bottom + insets.right)
            }
        } else {
            if direction == .vertical {
                size.height = max(size.height, column.offset.x + insets.bottom)
            } else {
                size.width = max(size.width, column.offset.x + insets.right)
            }
        }

        return size
    }
}
