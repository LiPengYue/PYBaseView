
pod 'PYBaseView'
# PYBaseView

[掘金](https://juejin.im/post/5d62a41e6fb9a06b1f143b7f)

[Demo](https://github.com/LiPengYue/PYBaseView)

封装了很多比较常用的控件:

1. [BaseGradientView:渐变视图](https://juejin.im/post/5d636cd06fb9a06b0703ca7f)
2. [PYTableMainView:对tableView的封装](https://juejin.im/post/5d60a3b85188252373305a09)（[其他TableView工具的推荐**ZHTableViewGroup**](https://github.com/josercc/ZHTableViewGroup)）
3. [PYBaseView:切圆角视图](https://juejin.im/post/5d6370e46fb9a06b112acb22)
4. [BasePointProgressView:进度条](https://juejin.im/post/5d60ffc9f265da03c8152b8f)
5. PYSize:对一些常用宽高的管理

## BaseGradientView渐变视图



![屏幕快照 2019-08-26 下午1.20.40](https://tva1.sinaimg.cn/large/006y8mN6gy1g6d0ethjsmj30cm06qwg7.jpg)

- 面向对象化色彩渐变工具

  - 线性渐变`PYGradientViewLineConfig`
    `PYGradientView`对象调用方法 `drawLineGradient` 设置线性config，并立马绘制渐变

    ```objective-c
    [self.gradientView drawLineGradient:^(PYGradientViewLineConfig *lineConfig) {
                lineConfig
                .setUpScaleEndCenter(CGPointMake(0, 0))
                .setUpScaleStartCenter(CGPointMake(1, 1))
                .setUpColorArray(@[
                                   UIColor.redColor,
                                   UIColor.cyanColor
                                   ])
                .setUpLocationArray(@[
                                      @0,@1
                                      ]);
        
    }];
    ```

    

  - 扩散渐变`PYGradientViewDrawRadialConfig`
    `PYGradientView`对象调用方法 `drawRadialGradient` 设置线性config，并立马绘制渐变

    ```objective-c
    [self.gradientView drawRadialGradient:^(PYGradientViewDrawRadialConfig *radialConfig) {
            radialConfig
            .setUpScaleEndCenter(CGPointMake(0.5, 0.5))
            .setUpScaleStartCenter(CGPointMake(0.5, 0.5))
            .setUpColorArray(@[
                               UIColor.redColor,
                               UIColor.blueColor
                               ])
            .setUpStartRadius(0)
            .setUpEndRadius(1000)
            .setUpLocationArray(@[@0.1,@1]);
    }];
    ```

    

## PYTableMainView

1. 高聚合代码。

2. 抛弃了组的限制，用类型或者key来区分cell、header、footer

3. 懒加载形式自动缓存每个cell、header、footer的frame

4. 动态注册 header、cell、footer

5. 其他推荐：[ZHTableViewGroup](https://github.com/josercc/ZHTableViewGroup)

   

## PYBaseView切圆角视图



![屏幕快照 2019-08-26 下午2.23.20](https://tva1.sinaimg.cn/large/006y8mN6gy1g6d27tox38j30dy0date7.jpg)

```objective-c
- (PYBaseView *)roundView {
    if (!_roundView) {
        _roundView = [PYBaseView new];
        _roundView
        
        .config
        
        .setUpLeftTopAddRadius(6)//左上角追加圆角半径
        .setUpLeftBottomAddRadius(20)//左下角追加圆角半径
        .setUpRightTopAddRadius(35)//右上角追加圆角半径
        .setUpRightBottomAddRadius(50)//右下角追加圆角半径
        
        .setUpShadowAlpha(1)//阴影alpha
        .setUpShadowColor(UIColor.redColor)//阴影颜色
        .setUpShadowRadius(10)//模糊程度
        .setUpShadowOffset(CGSizeMake(10, 10))/
        .setUpRightBottomAddRadius(50)
        .setUpShadowAlpha(1)
        .setUpShadowColor(UIColor.redColor)
        .setUpShadowRadius(10)
        .setUpShadowOffset(CGSizeMake(10, 10));
        _roundView.isDrawShadow = true;
       
    }
    return _roundView;
}
```



## BasePointProgressView进度条

![屏幕快照 2019-08-24 下午2.41.20](https://user-gold-cdn.xitu.io/2019/8/24/16cc2e727a4317e2?w=630&h=302&f=jpeg&s=10882)

## PYSize对一些常用宽高的管理

提供了一些常用的高度、宽度。

```objective-c
@interface PYSize : NSObject
/// 导航条总高度  iphoneX 以下为64，以上为88
@property(class, nonatomic, readonly) CGFloat navTotalH;
/// 导航条高度
@property(class, nonatomic, readonly) CGFloat navBarH;
/// 电池栏高度
@property(class, nonatomic, readonly) CGFloat statusBarH;
/// 底部的homelBar高度
@property(class, nonatomic, readonly) CGFloat homeBarH;
/// 底部的导航栏高度
@property(class, nonatomic, readonly) CGFloat tabbarH;
/// 屏幕最大宽度
@property(class, nonatomic, readonly) CGFloat screenW;
/// 屏幕最大高度
@property(class, nonatomic, readonly) CGFloat screenH;
/// 祛除导航栏h 后的最大高度 screenH - NavTotalH
@property(class, nonatomic, readonly) CGFloat screen_navH;
/// 祛除导航栏与tabbar的高度
@property(class, nonatomic, readonly) CGFloat screen_nav_tabBarH;


/// 需要调用，就可以拿到正确的值
+ (void) setNavTotalH: (CGFloat) h;
+ (void) setNavBarH: (CGFloat) h;
+ (void) setStatusBarH: (CGFloat) h;
+ (void) setHomeBarH: (CGFloat) h;
@end

```

```objective-c
#import "PYSize.h"

@implementation PYSize
static CGFloat navTotalH = 0;
static CGFloat navBarH = 0;
static CGFloat statusBarH = 0;
static CGFloat homeBarH = 0;
static CGFloat tabbarH = 0;
static CGFloat screenW = 0;
static CGFloat screenH = 0;
static CGFloat screen_navH = 0;
static CGFloat screen_nav_tabBarH = 0;

+ (CGFloat)navBarH {
    if (navBarH <= 0) {
        UINavigationController *baseNavc = [[UINavigationController alloc]init];
        navBarH = baseNavc.navigationBar.bounds.size.height;
        
    }
    return navBarH;
}
+ (CGFloat) navTotalH {
    if (navTotalH <= 0) {
        navTotalH = PYSize.navBarH + PYSize.statusBarH;
    }
    return navTotalH;
}
+ (CGFloat)homeBarH {
    if (homeBarH <= 0) {
        homeBarH = PYSize.statusBarH>20?34:0;
    }
    return homeBarH;
}
+ (CGFloat) tabbarH {
    if (tabbarH <= 0) {
        tabbarH  = [[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49;
    }
    return tabbarH;
}

+ (CGFloat) screenW {
    if (screenW <= 0) {
        screenW = [UIScreen mainScreen].bounds.size.width;
    }
    return screenW;
}
+ (CGFloat) screenH {
    if (screenH <= 0) {
        screenH = [UIScreen mainScreen].bounds.size.height;
    }
    return screenH;
}
+ (CGFloat)screen_navH {
    if (screen_navH <= 0) {
        screen_navH = PYSize.screenH - PYSize.navTotalH;
    }
    return screen_navH;
}
+ (CGFloat)screen_nav_tabBarH {
    if (screen_nav_tabBarH <= 0) {
        screen_nav_tabBarH = PYSize.screen_navH - PYSize.tabbarH;
    }
    return screen_nav_tabBarH;
}



+ (CGFloat)statusBarH {
    if (statusBarH <= 0) {
        statusBarH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
    return statusBarH;
}

+ (void) setNavBarH: (CGFloat) h {
    navBarH = h;
}

+ (void) setNavTotalH: (CGFloat) h {
    navTotalH = h;
}

+ (void) setStatusBarH: (CGFloat) h {
    statusBarH = h;
}

+ (void) setHomeBarH: (CGFloat) h {
    homeBarH = h;
}
@end
```

