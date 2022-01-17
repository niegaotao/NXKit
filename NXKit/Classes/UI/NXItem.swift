//
//  NXElement.swift
//  NXKit
//
//  Created by niegaotao on 2021/5/23.
//  Copyright © 2018年 无码科技. All rights reserved.
//

import UIKit

extension NXItem {
    //记录单元格类型和重用ID的对象
    open class Association : NX.Rect {
        open var value : [String: Any]? = nil
        
        open var cls : AnyClass?        //单元格/视图类型, e.g. NXTableViewCell.self
        open var reuse : String = ""    //单元格重用ID
        open var tag: Int = 0           //根据不同tag来做不同单元格的区分
        
        open var completion : NX.Completion<String, Any?>? = nil  //点击等回调
        
        open var backgroundColor: UIColor? = nil //头部尾部的背景色
        open var at : (first:Bool, last:Bool) = (false, false) //是否是第一个，是否是最后一个
        
        convenience public init(_ cls: AnyClass, _ reuse: String) {
            self.init()
            self.update(cls, reuse)
        }
        
        open func update(_ cls: AnyClass, _ reuse: String){
            self.cls = cls
            self.reuse = reuse
        }
    }
}

//单元格基类

open class NXItem : NXAny {
    
    open var ctxs = NXItem.Association()
    
    public override init() {
        super.init()
    }
    
    public init(value:[String:Any]?) {
        super.init()
        self.ctxs.value = value
    }
    
    public init(completion:NX.Completion<String, NXItem>?) {
        super.init()
        completion?("init", self)
    }
}

//分组基类
open class NXSection<Value: NXItem> : NXItem {
    open var items = [Value]()                  //分组下所有的单元格对象
    open var header = NXItem()                  //头部的分割线
    open var footer: NXItem? = nil              //尾部应该用不到，默认为nil
    
    //+便利构造函数
    public convenience init(cls: AnyClass, reuse:String, height: CGFloat) {
        self.init()
        self.header.ctxs.update(cls, reuse)
        self.header.ctxs.height = height
    }
    
    //+便利构造函数
    public convenience init(lineSpacing:CGFloat, interitemSpacing:CGFloat, insets:UIEdgeInsets) {
        self.init()
        self.lineSpacing = lineSpacing
        self.interitemSpacing = interitemSpacing
        self.insets = insets
    }
    
    //通过下标访问时加一层判断，防止越界crash
    open subscript(index: Int) -> Value? {
        if index >= 0 && index < items.count {
            return self.items[index]
        }
        return nil
    }
    
    //添加一个元素
    open func append(_ newValue: Value?){
        if let value = newValue {
            items.append(value)
        }
    }

    //批量添加元素
    open func append(contentsOf contents: [Value]?){
        if let contents = contents, contents.count > 0 {
            items.append(contentsOf:contents)
        }
    }
    
    //插入某个元素到指定索引位置
    //如果index=elements.count，则操作同append(_:)
    @discardableResult
    open func insert(_ value: Value?, at index:Int) -> Bool {
        if let value = value, index >= 0 && index <= items.count {
            items.insert(value, at: index)
            return true
        }
        return false
    }
    
    //移除一个元素，找到第一个就会移除,返回值true表示元素存在并且成功移除
    @discardableResult
    open func remove(_ value: Value?) -> Bool {
        if let value = value, let index = items.firstIndex(of: value) {
            return self.remove(at: index)
        }
        return false
    }
    
    //按照索引取删除元素:返回值true表示成功移除
    @discardableResult
    open func remove(at index: Int) -> Bool {
        if index >= 0 && index < items.count {
            items.remove(at: index)
            return true
        }
        return false
    }
    
    //移除所有的elements中的所有NXItem元素
    open func removeAll() {
        items.removeAll()
    }
    
    //替换某个元素
    @discardableResult
    open func replace(_ value: Value?, at index: Int) -> Bool {
        if let value = value, index >= 0 && index < items.count {
            self.items.replaceSubrange(index...index, with: [value])
            return true
        }
        return false
    }
    
    //elements中NXItem元素的个数
    open var count : Int {
        return items.count
    }
    
    
    //这三个属性在UICollectionView中会用到，在UITableView中不会用到
    open var lineSpacing :CGFloat =  0.0
    open var interitemSpacing: CGFloat = 0.0
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
}

extension NXSection {
    //tableView 获取重用cell
    public func dequeue(_ tableView: UITableView, _ indexPath : IndexPath) -> (element: NXItem, cell:NXTableViewCell)? {
        guard indexPath.row >= 0 && indexPath.row < self.items.count else {
            return nil
        }
        let element = self.items[indexPath.row]
        
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
        guard indexPath.row >= 0 && indexPath.row < self.items.count else {
            return nil
        }
        let element = self.items[indexPath.row]
        
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
open class NXCollection<T:UIScrollView> : NSObject {
    open weak var wrappedView : T? = nil
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
            if indexPath.row >= 0 && indexPath.row < __section.items.count {
                return __section.items[indexPath.row]
            }
        }
        return nil
    }
    
    //添加一个分组
    open func append(_ newValue: NXSection<NXItem>?){
        if let value = newValue {
            sections.append(value)
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
    open func insert(_ value: NXSection<NXItem>?, at index:Int) -> Bool {
        if let value = value, index >= 0 && index <= sections.count {
            sections.insert(value, at: index)
            return true
        }
        return false
    }
    
    //移除一个分组，找到第一个就会移除,返回值true表示分组存在并且成功移除
    @discardableResult
    open func remove(_ value: NXSection<NXItem>?) -> Bool {
        if let value = value, let index = sections.firstIndex(of: value) {
            return self.remove(at: index)
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
            
            for (row_index, row) in section.items.enumerated() {
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
            if section.items.count == 0 {
                sections.remove(at: index)
            }
        }
    }
    
    //新增一个分组,并将新增的分组返回//_ cls: AnyClass = NXTableReusableView.self, _ reuse:String = "NXTableReusableView", _ h:CGFloat = 10.0
    @discardableResult
    open func addSection(cls: AnyClass, reuse:String, height:CGFloat) -> NXSection<NXItem> {
        let section = NXSection(cls:cls, reuse:reuse, height: height)
        self.append(section)
        return section
    }
    
    //返回最后一个分组，没有则新增并返回最后一个分组
    @discardableResult
    open func getLastSection(cls: AnyClass, reuse:String, height:CGFloat) -> NXSection<NXItem> {
        if let section = self.sections.last {
            return section
        }
        return addSection(cls:cls, reuse:reuse, height: height)
    }
    
    //添加一个单元格到最后一个分组上，如果没有分组则创建
    @discardableResult
    open func addElementToLastSection(_ item: NXItem?) -> NXSection<NXItem> {
        let section = self.getLastSection(cls: NXTableReusableView.self, reuse: "NXTableReusableView", height: 10)
        section.append(item)
        return section
    }
    
    //批量添加单元格到最后一个分组上
    @discardableResult
    open func addElementsToLastSection(_ items: [NXItem]?) -> NXSection<NXItem> {
        let section = self.getLastSection(cls: NXTableReusableView.self, reuse: "NXTableReusableView", height: 10)
        section.append(contentsOf: items)
        return section
    }
}
