

#import "PYBaseSize.h"

@implementation PYBaseSize
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
        navTotalH = PYBaseSize.navBarH + PYBaseSize.statusBarH;
    }
    return navTotalH;
}
+ (CGFloat)homeBarH {
    if (homeBarH <= 0) {
        homeBarH = PYBaseSize.statusBarH>20?34:0;
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
        screen_navH = PYBaseSize.screenH - PYBaseSize.navTotalH;
    }
    return screen_navH;
}
+ (CGFloat)screen_nav_tabBarH {
    if (screen_nav_tabBarH <= 0) {
        screen_nav_tabBarH = PYBaseSize.screen_navH - PYBaseSize.tabbarH;
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
