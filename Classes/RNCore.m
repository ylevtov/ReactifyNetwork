//
//  RNCore.m
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 25/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import "RNCore.h"
#import "RNConstants.h"

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
    
    NSString *staticMapURL = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/staticmap?center=%@&zoom=14&size=150x100&key=AIzaSyDsKakbooD25RlSH-BX_H7VG5VlDkQyHjU&sensor=true&&markers=size:mid%%7Ccolor:blue%%7C%@", [self deviceLocation], [self deviceLocation]];
    
    defaultEMailBody = [NSString stringWithFormat:@"<p>Recent projects:</p><p>%@</p>We met here:</br><img src=\"%@\">", [includedProjects objectAtIndex:0], staticMapURL];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsKey_SavedRecipientsDict]) {
        savedRecipientsDict = (NSMutableDictionary*) [[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsKey_SavedRecipientsDict]] mutableCopy];
        NSLog(@"savedRecipientsDict has loaded with previous contents");
    }else{
        savedRecipientsDict = [[NSMutableDictionary alloc] init];
        NSLog(@"savedRecipientsDict has been initialized for the first time");
    }
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:kDefaultsKey_DefaultEventName] != nil) {
        NSLog(@"Setting previous default event name of %@", [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsKey_DefaultEventName]);
        defaultEventName = [[NSUserDefaults standardUserDefaults] objectForKey:kDefaultsKey_DefaultEventName];
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

-(void)combineUnsavedAndSavedRecipients:(BOOL)save {
    NSMutableDictionary *unsavedRecipientsDict = [[NSMutableDictionary alloc] init];
    
    NSString *currentDate = [self getCurrentDateAsString];
    NSString *meetingPlace;
    if (defaultEventName) {
        meetingPlace = defaultEventName;
    }else{
        meetingPlace = @"";
    }
    
    NSDictionary* info = [[NSDictionary alloc] init];
    for (int i = 0; i < [queuedRecipients count]; i++) {
        info = [NSDictionary dictionaryWithObjectsAndKeys:
                [queuedRecipients objectAtIndex:i],
                @"email",
                [NSNumber numberWithBool:NO],
                @"added",
                @"",
                @"name",
                meetingPlace,
                @"meetingPlace",
                currentDate,
                @"meetingDate",
                nil];
        [unsavedRecipientsDict setObject:info forKey:[NSNumber numberWithInt:i+savedRecipientsDict.count]];
    }
    
    NSLog(@"unsavedRecipients = %@", unsavedRecipientsDict);
    [savedRecipientsDict addEntriesFromDictionary:unsavedRecipientsDict];
//    NSLog(@"savedRecipientsDict = %@", savedRecipientsDict);
    [unsavedRecipientsDict removeAllObjects];
    [queuedRecipients removeAllObjects];
    
    if (save) {
        [self saveSentRecipients];
    }
}

-(void)saveSentRecipients {
    NSData *saveableData = [NSKeyedArchiver archivedDataWithRootObject:savedRecipientsDict];
    [[NSUserDefaults standardUserDefaults] setObject:saveableData forKey:kDefaultsKey_SavedRecipientsDict];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString*)getCurrentDateAsString {
    NSDate *date = [[NSDate alloc] init];
    NSLog(@"%@", date);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSLog(@"%@", dateString);
    
    return dateString;
}

-(void)addNameToRecipient:(int)indexOfRecipient withName:(NSString *)name{
//    NSLog(@"savedRecipients from %s BEFORE: %@", __func__, savedRecipientsDict);
    NSMutableDictionary *recipientToUpdate = [[savedRecipientsDict objectForKey:[NSNumber numberWithInt:indexOfRecipient]] mutableCopy];
//    NSLog(@"About to update this recipient: %@", recipientToUpdate);
    [recipientToUpdate setObject:name forKey:@"name"];
    [recipientToUpdate setObject:@1 forKey:@"added"];
//    NSLog(@"Updated this recipient to: %@", recipientToUpdate);
    [savedRecipientsDict setObject:recipientToUpdate forKey:[NSNumber numberWithInt:indexOfRecipient]];
//    NSLog(@"savedRecipients from %s AFTER: %@", __func__, savedRecipientsDict);
    
    [self saveSentRecipients];
}

-(void)editDefaultEMailBody {
    defaultEMailBody = [NSString stringWithFormat:@"<p>Nice to meet you!</p></br><p>Find attached my details, as well as some information on some of the projects we've been working on recently.</p>"];
}

- (void)setDefaultEventName:(NSString *)eventName {
    defaultEventName = eventName;
    NSLog(@"defaultEventName = %@", defaultEventName);
    
    [[NSUserDefaults standardUserDefaults] setValue:defaultEventName forKey:kDefaultsKey_DefaultEventName];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void)editIncludedProjects {
//    includedProjects = [NSMutableArray arrayWithObjects:@"<a href\"www.google.com\">Google</a>", "<a href\"www.faceboook.com\">Facebook</a>", nil];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    NSLog(@"appWillResignActive code has run");
//    [unlockedPhotosArray2 writeToFile:[self dataFilePath] atomically:YES];
}

@end
