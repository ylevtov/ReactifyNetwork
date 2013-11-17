//
//  RNAppDelegate.m
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import "RNAppDelegate.h"
#import "RNPerson.h"
#import "RNLogViewController.h"
#import "RNProjectsViewController.h"

#define kProjectsFilename @"defaultProjects.plist"

@implementation RNAppDelegate {
    NSMutableArray *persons;
    NSMutableArray *projects;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    core = [RNCore core];
    
    projects = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Projects" ofType:@"plist"]];
//                    arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"Projects" ofType:@"plist"]];
//    NSLog(@"Projects: %@", self.projectList);
    
    persons = [NSMutableArray arrayWithCapacity:20];
    
    RNPerson *person = [[RNPerson alloc] init];
    person.firstName = @"Yuli";
    person.lastName = @"Levtov";
    person.eMailAddress = @"yuli@reactifymusic.com";
    [persons addObject:person];
    
    person = [[RNPerson alloc] init];
    person.firstName = @"Ragnar";
    person.lastName = @"Hrafnkelsson";
    person.eMailAddress = @"ragnar@reactifymusic.com";
    [persons addObject:person];
    
    person = [[RNPerson alloc] init];
    person.firstName = @"Mikey";
    person.lastName = @"Erskine";
    person.eMailAddress = @"mikey@reactifymusic.com";
    [persons addObject:person];
    
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    
	RNLogViewController *logViewController = [[tabBarController viewControllers] objectAtIndex:3];
	logViewController.persons = persons;
    
    RNProjectsViewController *projectsViewController = [[tabBarController viewControllers] objectAtIndex:1];
    projectsViewController.projects = projects;
    
    RNProjectsViewController *settingsViewController = [[tabBarController viewControllers] objectAtIndex:2];
    settingsViewController.projects = projects;
    
    [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        [application setStatusBarStyle:UIStatusBarStyleBlackOpaque];
//        self.window.clipsToBounds =YES;
//        self.window.frame =  CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height);
//        self.window.bounds = CGRectMake(0,0, self.window.frame.size.width, self.window.frame.size.height);
//    }
    
    // Override point for customization after application launch.
    return YES;
}


- (NSString *)dataFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kProjectsFilename];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
