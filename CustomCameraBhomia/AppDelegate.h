//
//  AppDelegate.h
//  CustomCameraBhomia
//
//  Created by NOTOITSOLUTIONS on 14/11/14.
//  Copyright (c) 2014 NOTO SOLUTIONS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>
{
    UINavigationController *tempNav;
    OverlayViewController *rootClass;
    
}

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)UINavigationController *tempNav;
@property(nonatomic,retain) OverlayViewController *rootClass;

@end
