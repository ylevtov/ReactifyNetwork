//
//  RNViewController.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface RNViewController : UIViewController <MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *metadata;

@end
