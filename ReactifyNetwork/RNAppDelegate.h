//
//  RNAppDelegate.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNCore.h"

@interface RNAppDelegate : UIResponder <UIApplicationDelegate> {
    RNCore *core;
}

@property (nonatomic, strong) RNCore *core;
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray *projectList;

@end
