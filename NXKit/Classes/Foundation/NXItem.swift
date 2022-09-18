//
//  NXItem.swift
//  NXKit
//
//  Created by niegaotao on 2020/5/23.
//  Copyright (c) 2020年 niegaotao. All rights reserved.
//

import UIKit


//单元格基类
open class NXItem : NXAny {
    
    //视图类型
    public enum View : String{
        case header = "header"
        case cell = "cell"
        case footer = "footer"
    }
    
    //记录单元格类型和重用ID的对象
    open class Contexts : NX.Rect {
        open var value : [String: Any]? = nil
        
        open var cls : AnyClass?        //单元格/视图类型, e.g. NXTableViewCell.self
        open var reuse : String = ""    //单元格重用ID
        open var tag: Int = 0           //根据不同tag来做不同单元格的区分
        
        open var event: NX.Completion<String, Any?>? = nil  //点击等回调
        
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
    
    public let ctxs = NXItem.Contexts()

    public required init() {
        super.init()
    }
    
    public init(value:[String:Any]?, completion:NX.Completion<String, NXItem>?) {
        super.init()
        self.ctxs.value = value
        completion?("init", self)
    }
}

public protocol NXCollectionViewAttributesProtocol {
    var attributes : UICollectionViewLayoutAttributes {set get}
}


open class NXElementArray<Element:NXItem> : NXItem {
    //分组下所有的单元格对象
    open var elements = [Element]()
    
    //通过下标访问时加一层判断，防止越界crash
    open subscript(index: Int) -> Element? {
        if index >= 0 && index < elements.count {
            return self.elements[index]
        }
        return nil
    }
    
    //添加一个元素
    open func append(_ newValue: Element?){
        if let value = newValue {
            elements.append(value)
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
    open func insert(_ value: Element?, at index:Int) -> Bool {
        if let value = value, index >= 0 && index <= elements.count {
            elements.insert(value, at: index)
            return true
        }
        return false
    }
    
    //移除一个元素，找到第一个就会移除,返回值true表示元素存在并且成功移除
    @discardableResult
    open func remove(_ value: Element?) -> Bool {
        if let value = value, let index = elements.firstIndex(of: value) {
            elements.remove(at: index)
            return true
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
    
    //移除所有的elements中的所有元素
    open func removeAll() {
        elements.removeAll()
    }
    
    //替换某个元素
    @discardableResult
    open func replace(_ value: Element?, at index: Int) -> Bool {
        if let value = value, index >= 0 && index < elements.count {
            self.elements.replaceSubrange(index...index, with: [value])
            return true
        }
        return false
    }
    
    //elements中NXItem元素的个数
    open var count : Int {
        return elements.count
    }
}

//分组基类
open class NXSection : NXElementArray<NXItem> {
    open var header : NXItem? = nil             //头部的块，默认为nil
    //elements
    open var footer: NXItem? = nil              //尾部的块，默认为nil
    
    //这三个属性在UICollectionView中会用到，在UITableView中不会用到
    open var lineSpacing = CGFloat.zero
    open var interitemSpacing = CGFloat.zero
    open var insets = UIEdgeInsets.zero

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
open class NXCollection<T:UIView> : NXElementArray<NXSection> {
    open weak var wrappedView : T? = nil
    
    public let placeholderView = NXPlaceholderView()
    
    //是否展示第一个section的头部
    open var showsFirstSectionHeader = false
    //是否显示最后一个section的尾部
    open var showsLastSectionFooter = false
    //计算相对位置关系:默认不计算
    open var calcAt = false
    
    //根据IndexPath访问一个元素
    open subscript(indexPath: IndexPath) -> NXItem? {
        if indexPath.section >= 0 && indexPath.section < elements.count {
            let __section = elements[indexPath.section]
            if indexPath.row >= 0 && indexPath.row < __section.elements.count {
                return __section.elements[indexPath.row]
            }
        }
        return nil
    }
    
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
        guard let element  = element, elements.count > 0 else {
            return nil;
        }
                
        for (i, section) in elements.enumerated() {
            for (j, row) in section.elements.enumerated() {
                if row == element {
                    return IndexPath(row: j, section: i)
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
    open func removeEmpty(){
        self.elements.removeAll { section in
            return section.elements.count == 0
        }
    }
    

    //UITableView 获取element/cell
    public func dequeue(_ tableView: UITableView?, _ indexPath : IndexPath) -> (element: NXItem, cell:NXTableViewCell)? {
        guard let __tableView = tableView, indexPath.section >= 0 && indexPath.section < self.elements.count else {
            return nil
        }
        let section = self.elements[indexPath.section]
        return section.dequeue(__tableView, indexPath)
    }
    
    //UITableView header footer
    public func dequeue(_ tableView:UITableView?, _ index:Int, _ type:NXItem.View.RawValue) -> (element:NXItem, reusableView:NXTableReusableView)?{
        guard let __tableView = tableView, index >= 0 && index < self.elements.count else {
            return nil
        }
                
        if type == NXItem.View.header.rawValue {
            guard let header = self.elements[index].header else {return nil}
            guard header.ctxs.cls != nil && header.ctxs.reuse.count > 0 else {
                return nil
            }
            if let reusableView = __tableView.dequeueReusableHeaderFooterView(withIdentifier: header.ctxs.reuse) as? NXTableReusableView {
                return (header, reusableView)
            }
        }
        else if type == NXItem.View.footer.rawValue {
            guard let footer = self.elements[index].footer else { return nil}
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
        guard let __collectionView = collectionView, indexPath.section >= 0 && indexPath.section < self.elements.count else {
            return nil
        }
        let section = self.elements[indexPath.section]
        return section.dequeue(__collectionView, indexPath)
    }
    
    //UICollectionView 获取header footer
    public func dequeue(_ collectionView: UICollectionView?, _ indexPath:IndexPath, _ type:NXItem.View.RawValue) -> (elelment:NXItem, reusableView:NXCollectionReusableView)? {
        guard let __collectionView = collectionView, (indexPath as NSIndexPath).section >= 0 && (indexPath as NSIndexPath).section < self.elements.count else {
            return nil
        }
        if type == NXItem.View.header.rawValue {
            guard let element = self.elements[(indexPath as NSIndexPath).section].header else {return nil}
            guard element.ctxs.cls != nil && element.ctxs.reuse.count > 0 else {
                return nil
            }
            if let reusableView = __collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: element.ctxs.reuse, for: indexPath) as? NXCollectionReusableView {
                return (element, reusableView)
            }
        }
        else if type == NXItem.View.footer.rawValue {
            guard let element = self.elements[(indexPath as NSIndexPath).section].footer else {
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

extension NXCollection where T == NXTableView {
    @discardableResult
    public func addPlaceholderView(_ frame: CGRect) -> NXPlaceholderElement {
        let e = NXPlaceholderElement()
        e.placeholderView = self.placeholderView
        e.ctxs.update(NXTablePlaceholderViewCell.self, "NXTablePlaceholderViewCell")
        e.ctxs.frame = frame
        self.addElementsToLastSection([e])
        self.wrappedView?.register(NXTablePlaceholderViewCell.self, forCellReuseIdentifier: "NXTablePlaceholderViewCell")
        return e
    }

    
    public func heightForHeader(at index: Int) -> CGFloat {
        if let header = self[index]?.header {
            
            //1.根据自身的高度赋值拿到header的高度
            if header.ctxs.height > 0 {
                return header.ctxs.height
            }
        }
        return 0.0
    }
    
    
    public func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if let element = self[indexPath] {
            
            //1.根据自己对高度的赋值拿到相应的高度
            if element.ctxs.height > 0 {
                return element.ctxs.height
            }
            
            //2.根据FD中的自适应返回单元格的高度
            if let height = NX.heightForRow(self.wrappedView, element, indexPath), height > 0 {
                return height
            }
        }
        
        return 0.0
    }
    
    
    public func heightForFooter(at index: Int) -> CGFloat {
        if let footer = self[index]?.footer {
            //1.根据自身的高度赋值拿到header的高度
            if footer.ctxs.height > 0 {
                return footer.ctxs.height
            }
        }
        return 0.0
    }
    
    //新增一个分组,并将新增的分组返回//_ cls: AnyClass = NXTableReusableView.self, _ reuse:String = "NXTableReusableView", _ h:CGFloat = 10.0
    @discardableResult
    public func addSection(cls: AnyClass, reuse:String, height:CGFloat) -> NXSection {
        let section = NXSection()
        section.header = NXItem()
        section.header?.ctxs.update(cls, reuse)
        section.header?.ctxs.height = height
        self.append(section)
        return section
    }
    
    //返回最后一个分组，没有则新增并返回最后一个分组
    @discardableResult
    public func getLastSection(cls: AnyClass, reuse:String, height:CGFloat) -> NXSection {
        if let section = self.elements.last {
            return section
        }
        return addSection(cls:cls, reuse:reuse, height: height)
    }
    
    //批量添加单元格到最后一个分组上
    @discardableResult
    public func addElementsToLastSection(_ items: [NXItem]?) -> NXSection {
        let section = self.getLastSection(cls: NXTableReusableView.self, reuse: "NXTableReusableView", height: 10)
        section.append(contentsOf: items)
        return section
    }
}


extension NXCollection where T == NXCollectionView {
    @discardableResult
    public func addPlaceholderView(_ frame: CGRect) -> NXPlaceholderElement {
        let e = NXPlaceholderElement()
        e.placeholderView = self.placeholderView
        e.ctxs.update(NXCollectionPlaceholderViewCell.self, "NXPlaceholderViewCell")
        e.ctxs.frame = frame
        self.addElementsToLastSection([e])
        
        self.wrappedView?.register(NXCollectionPlaceholderViewCell.self, forCellWithReuseIdentifier: "NXPlaceholderViewCell")
        return e
    }
    
    //新增一个分组,并将新增的分组返回//_ cls: AnyClass = NXTableReusableView.self, _ reuse:String = "NXTableReusableView", _ h:CGFloat = 0.0
    @discardableResult
    public func addSection(cls: AnyClass, reuse:String, height:CGFloat) -> NXSection {
        let section = NXSection()
        section.header = NXItem()
        section.header?.ctxs.update(cls, reuse)
        section.header?.ctxs.height = height
        self.append(section)
        return section
    }
    
    //返回最后一个分组，没有则新增并返回最后一个分组
    @discardableResult
    public func getLastSection(cls: AnyClass, reuse:String, height:CGFloat) -> NXSection {
        if let section = self.elements.last {
            return section
        }
        return addSection(cls:cls, reuse:reuse, height: height)
    }
    
    //批量添加单元格到最后一个分组上
    @discardableResult
    public func addElementsToLastSection(_ items: [NXItem]?) -> NXSection {
        let section = self.getLastSection(cls: NXCollectionReusableView.self, reuse: "NXCollectionReusableView", height: 0)
        section.append(contentsOf: items)
        return section
    }
}
