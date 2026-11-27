//
//  NXItem.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit

public protocol NXAnyRepresentable: AnyObject, Equatable {
    var reuse: NXReuseDescriptor { get }
    var size: CGSize { get set }

    var additionalValue: [String: Any]? { get set }
    var backgroundColor: UIColor? { get set }
    var event: NXKit.Event<String, Any?>? { get set }
    var at: (first: Bool, last: Bool) { get set }
    var tag: Int { get set }
}

public extension NXAnyRepresentable {
    static func == (lhs: any NXAnyRepresentable, rhs: any NXAnyRepresentable) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func update(_ cls: AnyClass, _ reuse: String) {
        self.reuse.cls = cls
        self.reuse.id = reuse
    }
}

public protocol NXArrayRepresentable: NXAnyRepresentable {
    var header: (any NXAnyRepresentable)? { get set }
    var elements: [any NXAnyRepresentable] { get set }
    var footer: (any NXAnyRepresentable)? { get set }

    var lineSpacing: CGFloat { get set }
    var interitemSpacing: CGFloat { get set }
    var insets: UIEdgeInsets { get set }
}

public extension NXArrayRepresentable {
    subscript(index: Int) -> (any NXAnyRepresentable)? {
        if index >= 0, index < elements.count {
            return elements[index]
        }
        return nil
    }

    func append(_ newValue: (any NXAnyRepresentable)?) {
        if let value = newValue {
            elements.append(value)
        }
    }

    func append(contentsOf contents: [any NXAnyRepresentable]?) {
        if let contents = contents, contents.count > 0 {
            elements.append(contentsOf: contents)
        }
    }

    @discardableResult
    func insert(_ value: (any NXAnyRepresentable)?, at index: Int) -> Bool {
        if let value = value, index >= 0 && index <= elements.count {
            elements.insert(value, at: index)
            return true
        }
        return false
    }

    @discardableResult
    func remove(_ value: (any NXAnyRepresentable)?) -> Bool {
        if let value = value {
            let identifier = ObjectIdentifier(value)
            let count = elements.count
            elements.removeAll { loopValue in
                ObjectIdentifier(loopValue) == identifier
            }
            return elements.count != count
        }
        return false
    }

    @discardableResult
    func remove(at index: Int) -> Bool {
        if index >= 0 && index < elements.count {
            elements.remove(at: index)
            return true
        }
        return false
    }

    func removeAll() {
        elements.removeAll()
    }

    @discardableResult
    func replace(_ value: (any NXAnyRepresentable)?, at index: Int) -> Bool {
        if let value = value, index >= 0 && index < elements.count {
            elements.replaceSubrange(index ... index, with: [value])
            return true
        }
        return false
    }

    var count: Int {
        return elements.count
    }
}

public extension NXArrayRepresentable {
    // tableView 获取重用cell
    func dequeue(_ tableView: UITableView, _ indexPath: IndexPath) -> (element: any NXAnyRepresentable, cell: NXTableViewCell)? {
        guard indexPath.row >= 0, indexPath.row < elements.count else {
            return nil
        }
        let element = elements[indexPath.row]

        guard element.reuse.id.count > 0 else {
            return nil
        }

        if let cell = tableView.dequeueReusableCell(withIdentifier: element.reuse.id, for: indexPath) as? NXTableViewCell {
            return (element, cell)
        }
        return nil
    }

    // tableView 获取重用cell
    func dequeue(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> (element: any NXAnyRepresentable, cell: NXCollectionViewCell)? {
        guard indexPath.row >= 0, indexPath.row < elements.count else {
            return nil
        }
        let element = elements[indexPath.row]

        guard element.reuse.id.count > 0 else {
            return nil
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: element.reuse.id, for: indexPath) as? NXCollectionViewCell {
            return (element, cell)
        }
        return nil
    }
}

public protocol NX2DArrayRepresentable: AnyObject {
    var elements: [any NXArrayRepresentable] { get set }
}

public extension NX2DArrayRepresentable {
    subscript(index: Int) -> (any NXArrayRepresentable)? {
        if index >= 0, index < elements.count {
            return elements[index]
        }
        return nil
    }

    subscript(indexPath: IndexPath) -> (any NXAnyRepresentable)? {
        if indexPath.section >= 0, indexPath.section < elements.count {
            let __section = elements[indexPath.section]
            if indexPath.row >= 0, indexPath.row < __section.elements.count {
                return __section.elements[indexPath.row]
            }
        }
        return nil
    }

    func append(_ newValue: (any NXArrayRepresentable)?) {
        if let value = newValue {
            elements.append(value)
        }
    }

    func append(contentsOf contents: [any NXArrayRepresentable]?) {
        if let contents = contents, contents.count > 0 {
            elements.append(contentsOf: contents)
        }
    }

    @discardableResult
    func insert(_ value: (any NXArrayRepresentable)?, at index: Int) -> Bool {
        if let value = value, index >= 0 && index <= elements.count {
            elements.insert(value, at: index)
            return true
        }
        return false
    }

    @discardableResult
    func remove(_ value: (any NXArrayRepresentable)?) -> Bool {
        if let value = value {
            let identifier = ObjectIdentifier(value)
            let count = elements.count
            elements.removeAll { loopValue in
                ObjectIdentifier(loopValue) == identifier
            }
            return elements.count != count
        }
        return false
    }

    @discardableResult
    func remove(at index: Int) -> Bool {
        if index >= 0 && index < elements.count {
            elements.remove(at: index)
            return true
        }
        return false
    }

    @discardableResult
    func remove(at indexPath: IndexPath) -> Bool {
        if let section = self[indexPath.section] {
            section.elements.remove(at: indexPath.row)
            return true
        }
        return false
    }

    func removeAll() {
        elements.removeAll()
    }

    @discardableResult
    func replace(_ value: (any NXArrayRepresentable)?, at index: Int) -> Bool {
        if let value = value, index >= 0 && index < elements.count {
            elements.replaceSubrange(index ... index, with: [value])
            return true
        }
        return false
    }

    var count: Int {
        return elements.count
    }

    @discardableResult
    func indexPath(of element: (any NXAnyRepresentable)?) -> IndexPath? {
        guard let element = element, elements.count > 0 else {
            return nil
        }

        for (i, section) in elements.enumerated() {
            for (j, row) in section.elements.enumerated() {
                if ObjectIdentifier(row) == ObjectIdentifier(element) {
                    return IndexPath(row: j, section: i)
                }
            }
        }
        return nil
    }
}

public class NXReuseDescriptor {
    public var cls: AnyClass?
    public var id: String = ""
}

open class NXItem: NXAny, NXAnyRepresentable {
    public let reuse = NXReuseDescriptor()
    public var size = CGSize()

    public var additionalValue: [String: Any]?
    public var backgroundColor: UIColor?
    public var event: NXKit.Event<String, Any?>?
    public var at: (first: Bool, last: Bool) = (false, false)
    public var tag: Int = 0

    public enum View: String {
        case header
        case cell
        case footer
    }

    public required init() {
        super.init()
    }

    public init(value: [String: Any]?, completion: NXKit.Completion<NXItem>?) {
        super.init()
        additionalValue = value
        completion?(self)
    }
}

public protocol NXCollectionViewAttributesProtocol {
    var attributes: UICollectionViewLayoutAttributes { set get }
}

open class NXWrappable<T>: NXItem {
    open var wrappedValue: T
    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        super.init()
    }

    public required init() {
        fatalError("init() has not been implemented")
    }
}

// 分组基类
open class NXSection: NXItem, NXArrayRepresentable {
    open var header: (any NXAnyRepresentable)? = nil // 头部的块，默认为nil
    open var elements = [any NXAnyRepresentable]()
    open var footer: (any NXAnyRepresentable)? = nil // 尾部的块，默认为nil

    // 这三个属性在UICollectionView中会用到，在UITableView中不会用到
    open var lineSpacing = CGFloat.zero
    open var interitemSpacing = CGFloat.zero
    open var insets = UIEdgeInsets.zero
}

open class NXCollection<T: UIView>: NSObject, NX2DArrayRepresentable {
    open var elements = [any NXArrayRepresentable]()

    open weak var wrappedView: T? = nil

    public let placeholderView = NXPlaceholderView()

    open var showsFirstSectionHeader = false
    open var showsLastSectionFooter = false
    open var calcAt = false

    // UITableView 获取element/cell
    public func dequeue(_ tableView: UITableView?, _ indexPath: IndexPath) -> (element: any NXAnyRepresentable, cell: NXTableViewCell)? {
        guard let __tableView = tableView, indexPath.section >= 0 && indexPath.section < self.elements.count else {
            return nil
        }
        if let section = elements[indexPath.section] as? NXSection {
            return section.dequeue(__tableView, indexPath)
        }
        return nil
    }

    // UITableView header footer
    public func dequeue(_ tableView: UITableView?, _ index: Int, _ type: NXItem.View.RawValue) -> (element: any NXAnyRepresentable, reusableView: NXTableReusableView)? {
        guard let __tableView = tableView, index >= 0 && index < elements.count else {
            return nil
        }

        if type == NXItem.View.header.rawValue {
            guard let header = elements[index].header else { return nil }
            guard header.reuse.cls != nil && header.reuse.id.count > 0 else {
                return nil
            }
            if let reusableView = __tableView.dequeueReusableHeaderFooterView(withIdentifier: header.reuse.id) as? NXTableReusableView {
                return (header, reusableView)
            }
        } else if type == NXItem.View.footer.rawValue {
            guard let footer = elements[index].footer else { return nil }
            guard footer.reuse.cls != nil && footer.reuse.id.count > 0 else {
                return nil
            }
            if let reusableView = __tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.reuse.id) as? NXTableReusableView {
                return (footer, reusableView)
            }
        }

        return nil
    }

    // UICollectionView 获取element/cell
    public func dequeue(_ collectionView: UICollectionView?, _ indexPath: IndexPath) -> (element: any NXAnyRepresentable, cell: NXCollectionViewCell)? {
        guard let __collectionView = collectionView, indexPath.section >= 0 && indexPath.section < self.elements.count else {
            return nil
        }
        if let section = elements[indexPath.section] as? NXSection {
            return section.dequeue(__collectionView, indexPath)
        }
        return nil
    }

    // UICollectionView 获取header footer
    public func dequeue(_ collectionView: UICollectionView?, _ indexPath: IndexPath, _ type: NXItem.View.RawValue) -> (elelment: any NXAnyRepresentable, reusableView: NXCollectionReusableView)? {
        guard let __collectionView = collectionView, (indexPath as NSIndexPath).section >= 0 && (indexPath as NSIndexPath).section < self.elements.count else {
            return nil
        }
        if type == NXItem.View.header.rawValue {
            guard let element = elements[(indexPath as NSIndexPath).section].header else { return nil }
            guard element.reuse.cls != nil && element.reuse.id.count > 0 else {
                return nil
            }
            if let reusableView = __collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: element.reuse.id, for: indexPath) as? NXCollectionReusableView {
                return (element, reusableView)
            }
        } else if type == NXItem.View.footer.rawValue {
            guard let element = elements[(indexPath as NSIndexPath).section].footer else {
                return nil
            }
            guard element.reuse.cls != nil && element.reuse.id.count > 0 else {
                return nil
            }
            if let reusableView = __collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: element.reuse.id, for: indexPath) as? NXCollectionReusableView {
                return (element, reusableView)
            }
        }

        return nil
    }
}

public extension NXCollection where T == NXTableView {
    @discardableResult
    func addPlaceholderView(_ frame: CGRect) -> NXPlaceholderDescriptor {
        let e = NXPlaceholderDescriptor()
        e.placeholderView = placeholderView
        e.reuse.cls = NXTablePlaceholderViewCell.self
        e.reuse.id = "NXTablePlaceholderViewCell"
        e.size.width = frame.size.width
        e.size.height = frame.size.height
        addElementsToLastSection([e])
        wrappedView?.register(NXTablePlaceholderViewCell.self, forCellReuseIdentifier: "NXTablePlaceholderViewCell")
        return e
    }

    func heightForHeader(at index: Int) -> CGFloat {
        if let header = self[index]?.header {
            // 1.根据自身的高度赋值拿到header的高度
            if header.size.height > 0 {
                return header.size.height
            }
        }
        return 0.0
    }

    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if let element = self[indexPath] {
            // 1.根据自己对高度的赋值拿到相应的高度
            if element.size.height > 0 {
                return element.size.height
            }

            // 2.根据FD中的自适应返回单元格的高度
            if let height = NXKit.heightForRow(wrappedView, element, indexPath), height > 0 {
                return height
            }
        }

        return 0.0
    }

    func heightForFooter(at index: Int) -> CGFloat {
        if let footer = self[index]?.footer {
            if footer.size.height > 0 {
                return footer.size.height
            }
        }
        return 0.0
    }

    @discardableResult
    func addSection(cls: AnyClass, reuse: String, height: CGFloat) -> any NXArrayRepresentable {
        let section = NXSection()
        let header = NXItem()
        header.reuse.cls = cls
        header.reuse.id = reuse
        header.size.height = height
        section.header = header
        elements.append(section)
        return section
    }

    @discardableResult
    func getLastSection(cls: AnyClass, reuse: String, height: CGFloat) -> any NXArrayRepresentable {
        if let section = elements.last as? NXSection {
            return section
        }
        return addSection(cls: cls, reuse: reuse, height: height)
    }

    @discardableResult
    func addElementsToLastSection(_ items: [NXItem]?) -> any NXArrayRepresentable {
        let section = getLastSection(cls: NXTableReusableView.self, reuse: "NXTableReusableView", height: 10)
        section.append(contentsOf: items)
        return section
    }
}

public extension NXCollection where T == NXCollectionView {
    @discardableResult
    func addPlaceholderView(_ frame: CGRect) -> NXPlaceholderDescriptor {
        let e = NXPlaceholderDescriptor()
        e.placeholderView = placeholderView
        e.reuse.cls = NXCollectionPlaceholderViewCell.self
        e.reuse.id = "NXPlaceholderViewCell"
        e.size.width = frame.width
        e.size.height = frame.height
        addElementsToLastSection([e])

        wrappedView?.register(NXCollectionPlaceholderViewCell.self, forCellWithReuseIdentifier: "NXPlaceholderViewCell")
        return e
    }

    // 新增一个分组,并将新增的分组返回//_ cls: AnyClass = NXTableReusableView.self, _ reuse: String = "NXTableReusableView", _ h: CGFloat = 0.0
    @discardableResult
    func addSection(cls: AnyClass, reuse: String, height: CGFloat) -> NXSection {
        let section = NXSection()
        let header = NXItem()
        header.reuse.cls = cls
        header.reuse.id = reuse
        header.size.height = height
        section.header = header
        elements.append(section)
        return section
    }

    // 返回最后一个分组，没有则新增并返回最后一个分组
    @discardableResult
    func getLastSection(cls: AnyClass, reuse: String, height: CGFloat) -> NXSection {
        if let section = elements.last as? NXSection {
            return section
        }
        return addSection(cls: cls, reuse: reuse, height: height)
    }

    // 批量添加单元格到最后一个分组上
    @discardableResult
    func addElementsToLastSection(_ items: [NXItem]?) -> NXSection {
        var section = getLastSection(cls: NXCollectionReusableView.self, reuse: "NXCollectionReusableView", height: 0)
        section.append(contentsOf: items)
        return section
    }
}
