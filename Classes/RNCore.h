//
//  RNCore.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 25/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define kSavedRecipientsFilename @"savedRecipients.plist"

@interface RNCore : NSObject {
    CLLocationManager *locationManager;
}

@property (nonatomic, strong) NSMutableArray *queuedRecipients;
@property (nonatomic, strong) NSString *defaultEMailBody;
@property (nonatomic, strong) NSString *defaultEventName;
@property (nonatomic, strong) NSMutableArray *projects;
@property (nonatomic, strong) NSMutableArray *includedProjects;
@property (nonatomic, strong) NSMutableArray *savedRecipients;
@property (nonatomic, strong) NSMutableDictionary *savedRecipientsDict;
@property (nonatomic, retain) NSArray* paths;
@property (nonatomic, retain) NSString* documentsDirectory;

+ (RNCore *)core;
- (void)addRecipientToQueue:(NSString *)email;
- (void)removeRecipientFromQueue:(NSString *)email;
- (void)combineUnsavedAndSavedRecipients:(BOOL)save;
- (void)saveSentRecipients;
- (void)addNameToRecipient:(int)indexOfRecipient withName:(NSString *)name;
- (void)setDefaultEventName:(NSString *)eventName;

@end
