//
//  RNCore.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 25/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RNCore : NSObject {
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) NSMutableArray *queuedRecipients;
@property (nonatomic, strong) NSString *defaultEMailBody;
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) NSMutableArray *includedProjects;

+ (RNCore *)core;
- (void)addRecipientToQueue:(NSString *)email;

@end
