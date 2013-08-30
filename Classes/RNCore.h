//
//  RNCore.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 25/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kFilename @"savedRecipients.plist"

@interface RNCore : NSObject {
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) NSMutableArray *queuedRecipients;
@property (nonatomic, strong) NSString *defaultEMailBody;
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) NSMutableArray *includedProjects;
@property (nonatomic, strong) NSMutableArray *savedRecipients;
@property (nonatomic, retain) NSArray* paths;
@property (nonatomic, retain) NSString* documentsDirectory;

+ (RNCore *)core;
- (void)addRecipientToQueue:(NSString *)email;
- (void)saveSentRecipients;
- (void)addNameToRecipient:(int)indexOfRecipient:(NSString *)name;

@end
