//
//  RNCore.m
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 25/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import "RNCore.h"

static RNCore *sharedCore;

@implementation RNCore

@synthesize queuedRecipients, defaultEMailBody, projects, includedProjects, paths, documentsDirectory, savedRecipients, savedRecipientsDict, defaultEventName;

+(void)initialize {
	static BOOL initialised = NO;
	if (!initialised)
	{
		initialised = YES;
		sharedCore = [[RNCore alloc] init];
	}
}

+(RNCore *)core {
	@synchronized(self) {
		if (sharedCore == NULL)
            sharedCore = [[self alloc] init];
	}
	return sharedCore;
}

- (NSString *)dataFilePath{
    paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kSavedRecipientsFilename];
}

-(id)init {
    
    self = [super init];
    
    NSLog(@"PSCore init CODE HAS RUN!");
    
    // Location services
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [locationManager startUpdatingLocation];
    
//    UIApplication *app = [UIApplication sharedApplication];
    
    projects = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Projects" ofType:@"plist"]];
    
//    NSLog(@"Projects = %@", projects);
    
    queuedRecipients = [[NSMutableArray alloc] init];
    
    includedProjects = [[NSMutableArray alloc] init];
    
    NSDictionary *temp = [projects objectAtIndex: 0];
    [includedProjects addObject:[NSString stringWithFormat:@"%@", [temp objectForKey:@"HTML"]]];
    
//    [includedProjects addObject:@"<a href=\"www.facebook.com\">Facebook</a>"];
    
    NSString *staticMapURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@&zoom=14&size=150x100&key=AIzaSyDsKakbooD25RlSH-BX_H7VG5VlDkQyHjU&sensor=true&&markers=size:mid%%7Ccolor:blue%%7C%@", [self deviceLocation], [self deviceLocation]];
    
    defaultEMailBody = [NSString stringWithFormat:@"<p>Recent projects:</p><p>%@</p>We met here:</br><img src=\"%@\">", [includedProjects objectAtIndex:0], staticMapURL];
    
//    NSLog(@"%@", [self deviceLocation]);
    
    NSString *filePath = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        savedRecipientsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
        NSLog(@"savedRecipientsDict has loaded with contents of filePath: %@", savedRecipientsDict);
    }else{
        savedRecipientsDict = [[NSMutableDictionary alloc] init];
        NSLog(@"savedRecipientsDict has been initialized for the first time");
    }
    
    return self;
}

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"%f,%f", locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
}

-(void)addRecipientToQueue:(NSString *)email {
    [queuedRecipients addObject:email];
    
    NSLog(@"Queued recipients array: %@", queuedRecipients);
}

-(void)saveSentRecipients {
    
//    NSMutableArray *unsavedRecipients = [[NSMutableArray alloc] init];
    NSMutableDictionary *unsavedRecipientsDict = [[NSMutableDictionary alloc] init];
    
    NSDictionary* info = [[NSDictionary alloc] init];    
    for (int i = 0; i < [queuedRecipients count]; i++) {
        info = [NSDictionary dictionaryWithObjectsAndKeys:
                [queuedRecipients objectAtIndex:i],
                @"email",
                [NSNumber numberWithBool:NO],
                @"added",
                @"",
                @"name",
                @"",
                @"meetingPlace",
                @"",
                @"meetingDate",
                nil];
        
//        [unsavedRecipients addObject:info];
        [unsavedRecipientsDict setObject:info forKey:[NSNumber numberWithInt:i+savedRecipientsDict.count]];
    }
    
    NSLog(@"unsavedRecipients = %@", unsavedRecipientsDict);
    [savedRecipientsDict addEntriesFromDictionary:unsavedRecipientsDict];
    NSLog(@"savedRecipientsDict = %@", savedRecipientsDict);
    [unsavedRecipientsDict removeAllObjects];
    [queuedRecipients removeAllObjects];
    
    id plist = [NSPropertyListSerialization dataFromPropertyList:(id)savedRecipientsDict
                                                          format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    
    NSError *error = nil;
    [savedRecipientsDict writeToFile:[self dataFilePath] atomically:YES];
    if (error) {
        NSLog(@"Fail: %@", [error localizedDescription]);
    }
    NSLog(@"File saved successfully? %i", [plist writeToFile:[self dataFilePath] atomically:YES]);
}

-(void)addNameToRecipient:(int)indexOfRecipient:(NSString *)name{
    NSMutableDictionary *recipientToUpdate = [savedRecipients objectAtIndex:indexOfRecipient];
    NSLog(@"About to update this recipient: %@", recipientToUpdate);
    [recipientToUpdate setObject:name forKey:@"name"];
    [recipientToUpdate setObject:@1 forKey:@"added"];
    NSLog(@"Updated this recipient to: %@", recipientToUpdate);
}

-(void)editDefaultEMailBody {
    defaultEMailBody = [NSString stringWithFormat:@"<p>Nice to meet you!</p></br><p>Find attached my details, as well as some information on some of the projects we've been working on recently.</p>"];
}

- (void)setDefaultEventName:(NSString *)eventName {
    defaultEventName = eventName;
    NSLog(@"defaultEventName = %@", defaultEventName);
}

-(void)editIncludedProjects {
//    includedProjects = [NSMutableArray arrayWithObjects:@"<a href\"www.google.com\">Google</a>", "<a href\"www.faceboook.com\">Facebook</a>", nil];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    NSLog(@"appWillResignActive code has run");
//    [unlockedPhotosArray2 writeToFile:[self dataFilePath] atomically:YES];
}

@end
