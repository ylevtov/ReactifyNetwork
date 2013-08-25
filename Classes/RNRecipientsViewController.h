//
//  RNRecipientsViewController.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>

@interface RNRecipientsViewController : UIViewController <UITextFieldDelegate> {
    NSMutableArray *recipients;
}

@property (nonatomic, weak) IBOutlet UITableView *recipientsTableView;
@property (weak, nonatomic) IBOutlet UITextField *inputEMailField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

-(IBAction)sendButtonPressed:(id)sender;

@end
