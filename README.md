# NXKit

[![CI Status](https://img.shields.io/travis/niegaotao/NXKit.svg?style=flat)](https://travis-ci.org/niegaotao/NXKit)
[![Version](https://img.shields.io/cocoapods/v/NXKit.svg?style=flat)](https://cocoapods.org/pods/NXKit)
[![License](https://img.shields.io/cocoapods/l/NXKit.svg?style=flat)](https://cocoapods.org/pods/NXKit)
[![Platform](https://img.shields.io/cocoapods/p/NXKit.svg?style=flat)](https://cocoapods.org/pods/NXKit)

## 一、功能介绍
根据功能分为基础部分、扩展部分共两个部分：

### 1、基础部分

##### 1.1.基础结构
- `NX`：全局变量和方法，封装跟`UIView`、`UILabel`、`UIImageView`、`CALayer`对等的模型,设备、屏幕、颜色、字号等信息。
- `NXAny`：遵守`Equatable`协议的类类型的基类
- `NXItem`：渲染`UITableView`、`UICollectionView`的单元格的模型基类。
- `NXCollection`：封装`UITableView`数据，封装`UICollectionView`数据
- `NXAbstract`：：封装通用表单单元格的数据模型

##### 1.2.基础UI
- `NXView`：`setupSubviews`、`updateSubviews`方法用于初始化视图和刷新视图
- `NXCView<C:UIView>`：包含`C`类型的`contentView`内容视图属性
- `NXLRView<L:UIView, R:UIView>`：包含`L`类型的`lhsView`、`R`类型的`rhsView`属性
- `NXLCRView<L:UIView, C:UIView, R:UIView>`：包`lhsView`、`centerView`、`rhsView`属性
- `NXAutoresizeView<C:UIView>`
- `NXBackgroundView<B:UIView, C:UIView>`：包含`B`类型的`backgroundView`背景视图属性、`C`类型的`contentView`内容视图属性
- `NXNavigationView`：自定义导航栏，仿系统的`UINavigationBar`,被`NXViewController`持有
- `NXToolView`：自定义底部工具栏
- `NXSwipeView`：自定义左右滑动视图，与`NXSwipeViewController`配合使用
- `NXWebView`
- `NXTableView`
- `NXTableViewCell`
- `NXTableReusableView`
- `NXCollectionView`
- `NXCollectionViewCell`
- `NXCollectionReusableView`
- `NXAnimationView`：动画视图
- `NXAbstractView`
- `NXAbstractTableViewCell<T:UIView>`
- `NXAbstractCollectionViewCell<T:UIView>`
- `NXAbstractViewCell`
- `NXActionViewCell`

##### 1.3.控制器
- `NXViewController`：视图控制器基本，包含导航栏、内容视图、加载动画等功能
- `NXTableViewController`：`NXTableView`视图控制器
- `NXCollectionViewController`：`NXCollectionView`视图控制器
- `NXWebViewController`：`NXWebView`视图控制器
- `NXNavigationController`：导航控制器
- `NXContainerController`：容器控制器
- `NXToolViewController`：仿系统`UITabBarController`
- `NXSwipeViewController`：仿系统`UIPageViewController`

##### 1.4.弹框
- `NXOverlay`
- `NXActionView`：仿系统`UIAlertController`
- `NXHUD`：弱提示

##### 1.5.扩展
- `DispatchQueue+NXKit`
- `String+NXKit`
- `UIButton+NXKit`
- `UIImage+NXKit`
- `UILabel+NXKit`
- `UIView+NXKit`

##### 1.6.服务
- `NXObserver`：应用内通知
- `NXKVOObserver`：`KVO`封装
- `NXStorage`：基于`UserDefaults`存储的封装
- `NXFS`：本地文件的读写
- `NXRouter`：路由管理器
- `NXRequest`：基于网络请求的封装

##### 1.7.资源文件
- `NXKit.bundle`：包含图片资源和json文件

### 2、扩展部分

##### 2.1.相册选图功能封装
- `NXAsset`
- `NXAlbum`
- `NXAlbumViewController`
- `NXAlbumAssetsViewController`
- `NXCameraViewController`
- `NXCameraCaptureController`
- `NXClipboardView`
- `NXAssetClipViewController`

## 二、如何使用
代码全部开源，[点击查看代码](https://github.com/niegaotao/NXKit.git)。
```
//仅使用Foundation部分功能：
pod 'NXKit/Foundation'

//或使用全部功能
pod 'NXKit'
```
你也可以下载代码后修改作为本地`pod`去使用。
使用案例，可以下载查看`Example`.

## 三、其他
- Author：niegaotao, 247268158@qq.com
- License ：NXKit is available under the MIT license. See the LICENSE file for more info.
