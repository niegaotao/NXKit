//
//  NXElement.swift
//  NXKit
//
//  Created by firelonely on 2018/5/23.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

extension NXItem {
    //记录单元格类型和重用ID的对象
    open class Wrapped {
        open var value : [String: Any]? = nil
        
        open var cls : AnyClass?        //单元格/视图类型, e.g. NXTableViewCell.self
        open var reuse : String = ""    //单元格重用ID
        open var type: Int = 0          //根据不同id来做不同单元格的区分
        
        open var x : CGFloat = 0.0
        open var y : CGFloat = 0.0
        open var w : CGFloat = 0.0
        open var h : CGFloat = 0.0
        
        open var completion : NXApp.Completion<String, Any?>? = nil  //点击等回调
        
        open var backgroundColor: UIColor? = nil //头部尾部的背景色
        open var at : (first:Bool, last:Bool) = (false, false) //是否是第一个，是否是最后一个
        
        public init(_ cls: AnyClass, _ reuse: String) {
            self.update(cls, reuse)
        }
        
        public init(){
        }
        
        open func update(_ cls: AnyClass, _ reuse: String){
            self.cls = cls
            self.reuse = reuse
        }
    }
}

extension NXItem.Wrapped {
    open var origin : CGPoint {
        set {
            self.x = newValue.x
            self.y = newValue.y
        }
        get {
            return CGPoint(x: self.x, y: self.y)
        }
    }
    
    open var size : CGSize {
        set {
            self.w = newValue.width
            self.h = newValue.height
        }
        get {
            return CGSize(width: self.w, height: self.h)
        }
    }
    
    open var frame : CGRect {
        set {
            self.x = newValue.origin.x
            self.y = newValue.origin.y
            self.w = newValue.size.width
            self.h = newValue.size.height
        }
        get {
            return CGRect(x: self.x, y: self.y, width: self.w, height: self.h)
        }
    }
}

//单元格model基类
open class NXItem : NSObject {
    public let ctxs = NXItem.Wrapped()
    
    public convenience init(value: [String: Any]?) {
        self.init()
        self.ctxs.value = value
        self.setup()
    }
    
    //子类按需重在该方法
    open func setup(){
        
    }
}

//分组基类
open class NXSection<Element: NXItem> : NXItem {
    open var elements = [Element]()              //分组下所有的单元格对象
    open var header = NXItem()                  //头部的分割线
    open var footer: NXItem? = nil              //尾部应该用不到，默认为nil
    
    //+便利构造函数
    public convenience init(_ cls: AnyClass, _ reuse:String, _ h: CGFloat) {
        self.init()
        self.header.ctxs.update(cls, reuse)
        self.header.ctxs.h = h
    }
    
    //+便利构造函数
    public convenience init(lineSpacing:CGFloat, interitemSpacing:CGFloat, insets:UIEdgeInsets) {
        self.init()
        self.lineSpacing = lineSpacing
        self.interitemSpacing = interitemSpacing
        self.insets = insets
    }
    
    //+便利构造函数
    public convenience init(elements:[Element]?) {
        self.init()
        if let __elements = elements, __elements.count > 0 {
            self.elements.append(contentsOf:__elements)
        }
    }
    
    //通过下标访问时加一层判断，防止越界crash
    open subscript(index: Int) -> Element? {
        if index >= 0 && index < elements.count {
            return self.elements[index]
        }
        return nil
    }
    
    //添加一个元素
    open func append(_ newElement: Element?){
        if let element = newElement {
            elements.append(element)
        }
    }

    //批量添加元素
    open func append(contentsOf contents: [Element]?){
        if let contents = contents, contents.count > 0 {
            elements.append(contentsOf:contents)
        }
    }
    
    //插入某个元素到指定索引位置
    //如果index=elements.count，则操作同append(_:)
    @discardableResult
    open func insert(_ element: Element?, at index:Int) -> Bool {
        if let element = element, index >= 0 && index <= elements.count {
            elements.insert(element, at: index)
            return true
        }
        return false
    }
    
    //移除一个元素，找到第一个就会移除,返回值true表示元素存在并且成功移除
    @discardableResult
    open func remove(_ element: Element?) -> Bool {
        if let element = element {
            if let index = elements.firstIndex(of: element) {
                return self.remove(at: index)
            }
        }
        return false
    }
    
    //按照索引取删除元素:返回值true表示成功移除
    @discardableResult
    open func remove(at index: Int) -> Bool {
        if index >= 0 && index < elements.count {
            elements.remove(at: index)
            return true
        }
        return false
    }
    
    //移除所有的elements中的所有NXItem元素
    open func removeAll() {
        elements.removeAll()
    }
    
    //替换某个元素
    @discardableResult
    open func replace(_ element: Element?, at index: Int) -> Bool {
        if let element = element, index >= 0 && index < elements.count {
            self.elements.replaceSubrange(index...index, with: [element])
            return true
        }
        return false
    }
    
    //elements中NXItem元素的个数
    open var count : Int {
        return elements.count
    }
    
    
    //这三个属性在UICollectionView中会用到，在UITableView中不会用到
    open var lineSpacing :CGFloat =  0.0
    open var interitemSpacing: CGFloat = 0.0
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
}

extension NXSection {
    //tableView 获取重用cell
    public func dequeue(_ tableView: UITableView, _ indexPath : IndexPath) -> (element: NXItem, cell:NXTableViewCell)? {
        guard indexPath.row >= 0 && indexPath.row < self.elements.count else {
            return nil
        }
        let element = self.elements[indexPath.row]
        
        guard element.ctxs.reuse.count > 0 else {
            return nil
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: element.ctxs.reuse, for: indexPath) as? NXTableViewCell {
            return (element, cell)
        }
        return nil
    }
    
    
    //tableView 获取重用cell
    public func dequeue(_ collectionView: UICollectionView, _ indexPath : IndexPath) -> (element: NXItem, cell:NXCollectionViewCell)? {
        guard indexPath.row >= 0 && indexPath.row < self.elements.count else {
            return nil
        }
        let element = self.elements[indexPath.row]
        
        guard element.ctxs.reuse.count > 0 else {
            return nil
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: element.ctxs.reuse, for: indexPath) as? NXCollectionViewCell {
            return (element, cell)
        }
        return nil
    }
}

//三维模型的基类：通用于 UITableView 数据模型和 UICollectionView 数据模型
open class NXCollection : NSObject {
    open var sections = [NXSection]()
    
    //通过下标访问一个分组对象
    open subscript(index: Int) -> NXSection<NXItem>? {
        if index >= 0 && index < sections.count {
            return self.sections[index]
        }
        return nil
    }
    
    //根据IndexPath访问一个元素
    open subscript(indexPath: IndexPath) -> NXItem? {
        if indexPath.section >= 0 && indexPath.section < sections.count {
            let __section = sections[indexPath.section]
            if indexPath.row >= 0 && indexPath.row < __section.elements.count {
                return __section.elements[indexPath.row]
            }
        }
        return nil
    }
    
    //添加一个分组
    open func append(_ newElement: NXSection<NXItem>?){
        if let element = newElement {
            sections.append(element)
        }
    }
    
    //批量添加分组
    open func append(contentsOf contents: [NXSection<NXItem>]?){
        if let contents = contents, contents.count > 0 {
            sections.append(contentsOf:contents)
        }
    }
    
    //插入某个分组到指定索引位置
    //如果index=sections.count，则操作同append(_:)
    @discardableResult
    open func insert(_ element: NXSection<NXItem>?, at index:Int) -> Bool {
        if let element = element, index >= 0 && index <= sections.count {
            sections.insert(element, at: index)
            return true
        }
        return false
    }
    
    //移除一个分组，找到第一个就会移除,返回值true表示分组存在并且成功移除
    @discardableResult
    open func remove(_ element: NXSection<NXItem>?) -> Bool {
        if let element = element {
            if let index = sections.firstIndex(of: element) {
                return self.remove(at: index)
            }
        }
        return false
    }
    
    //按照索引去删除分组:返回值true表示成功移除
    @discardableResult
    open func remove(at index: Int) -> Bool {
        if index >= 0 && index < sections.count {
            sections.remove(at: index)
            return true
        }
        return false
    }
    
    //移除所有的sections中的所有NXSection元素
    open func removeAll() {
        sections.removeAll()
    }
    
    //替换某个分组
    @discardableResult
    open func replace(_ element: NXSection<NXItem>?, at index: Int) -> Bool {
        if let element = element, index >= 0 && index < sections.count {
            self.sections.replaceSubrange(index...index, with: [element])
            return true
        }
        return false
    }
    
    //sections中NXSection对象的个数
    open var count : Int {
        return sections.count
    }
}

extension NXCollection {
    public enum Dequeue : String{
        case header = "header"
        case cell = "cell"
        case footer = "footer"
    }
    
    //UITableView 获取element/cell
    public func dequeue(_ tableView: UITableView?, _ indexPath : IndexPath) -> (element: NXItem, cell:NXTableViewCell)? {
        guard let __tableView = tableView, indexPath.section >= 0 && indexPath.section < self.sections.count else {
            return nil
        }
        let section = self.sections[indexPath.section]
        return section.dequeue(__tableView, indexPath)
    }
    
    //UITableView header footer
    public func dequeue(_ tableView:UITableView?, _ index:Int, _ type:NXCollection.Dequeue.RawValue) -> (element:NXItem, reusableView:NXTableReusableView)?{
        guard let __tableView = tableView, index >= 0 && index < self.sections.count else {
            return nil
        }
        if type == NXCollection.Dequeue.header.rawValue {
            let header = self.sections[index].header
            guard header.ctxs.cls != nil && header.ctxs.reuse.count > 0 else {
                return nil
            }
            if let reusableView = __tableView.dequeueReusableHeaderFooterView(withIdentifier: header.ctxs.reuse) as? NXTableReusableView {
                return (header, reusableView)
            }
        }
        else if type == NXCollection.Dequeue.footer.rawValue {
            guard let footer = self.sections[index].footer else {
                return nil
            }
            guard footer.ctxs.cls != nil && footer.ctxs.reuse.count > 0 else {
                return nil
            }
            if let reusableView = __tableView.dequeueReusableHeaderFooterView(withIdentifier: footer.ctxs.reuse) as? NXTableReusableView {
                return (footer, reusableView)
            }
        }
        
        return nil
    }
    
    //UICollectionView 获取element/cell
    public func dequeue(_ collectionView: UICollectionView?, _ indexPath : IndexPath) -> (element: NXItem, cell:NXCollectionViewCell)? {
        guard let __collectionView = collectionView, indexPath.section >= 0 && indexPath.section < self.sections.count else {
            return nil
        }
        let section = self.sections[indexPath.section]
        return section.dequeue(__collectionView, indexPath)
    }
    
    //UICollectionView 获取header footer
    public func dequeue(_ collectionView: UICollectionView?, _ indexPath:IndexPath, _ type:NXCollection.Dequeue.RawValue) -> (elelment:NXItem, reusableView:NXCollectionReusableView)? {
        guard let __collectionView = collectionView, indexPath.section >= 0 && indexPath.section < self.sections.count else {
            return nil
        }
        if type == NXCollection.Dequeue.header.rawValue {
            let element = self.sections[indexPath.section].header
            guard element.ctxs.cls != nil && element.ctxs.reuse.count > 0 else {
                return nil
            }
            if let reusableView = __collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: element.ctxs.reuse, for: indexPath) as? NXCollectionReusableView {
                return (element, reusableView)
            }
        }
        else if type == NXCollection.Dequeue.footer.rawValue {
            guard let element = self.sections[indexPath.section].footer else {
                return nil
            }
            guard element.ctxs.cls != nil && element.ctxs.reuse.count > 0 else {
                return nil
            }
            if let reusableView = __collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: element.ctxs.reuse, for: indexPath) as? NXCollectionReusableView {
                return (element, reusableView)
            }
        }
        
        return nil
    }
}

//对分组操作的一层封装
extension NXCollection {
    
    //根据indexPath去删除单元格
    @discardableResult
    open func remove(at indexPath: IndexPath) -> Bool {
        if let section = self[indexPath.section] {
            return section.remove(at: indexPath.row)
        }
        return false
    }
    
    //元素所在的索引
    @discardableResult
    open func indexPath(of element: NXItem?) -> IndexPath? {
        guard let element  = element else {
            return nil;
        }
        
        if sections.count == 0 {return nil}
        
        for (section_index, section) in sections.enumerated() {
            
            for (row_index, row) in section.elements.enumerated() {
                if row == element {
                    return IndexPath(row: row_index, section: section_index)
                }
            }
        }
        return nil
    }
    
    //根据indexPath插入一个元素
    @discardableResult
    open func insert(_ element: NXItem?, at indexPath: IndexPath) -> Bool {
        if let section = self[indexPath.section] {
            return section.insert(element, at: indexPath.row)
        }
        return false
    }
    
    //移除不带单元格的分组
    open func removeEmptySection(){
        for (index, section) in sections.reversed().enumerated(){
            if section.elements.count == 0 {
                sections.remove(at: index)
            }
        }
    }
    
    //新增一个分组,并将新增的分组返回
    @discardableResult
    open func addSection(_ cls: AnyClass = NXTableReusableView.self, _ reuse:String = "NXTableReusableView", _ h:CGFloat = 10.0) -> NXSection<NXItem> {
        let section = NXSection(cls, reuse, h)
        self.append(section)
        return section
    }
    
    //返回最后一个分组，没有则新增并返回最后一个分组
    @discardableResult
    open func getLastSection(_ cls: AnyClass = NXTableReusableView.self, _ reuse:String = "NXTableReusableView", _ h:CGFloat = 10.0) -> NXSection<NXItem> {
        if let section = self.sections.last {
            return section
        }
        return addSection(cls, reuse, h)
    }
    
    //添加一个单元格到最后一个分组上，如果没有分组则创建
    open func addElementToLastSection(_ element: NXItem?) {
        let section = self.getLastSection()
        section.append(element)
    }
    
    //批量添加单元格到最后一个分组上
    open func addElementsToLastSection(_ elements: [NXItem]?) {
        let section = self.getLastSection()
        section.append(contentsOf: elements)
    }
}
