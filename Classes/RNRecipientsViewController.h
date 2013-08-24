//
//  RNRecipientsViewController.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RNRecipientsViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *recipientsTableView;

@property (weak, nonatomic) IBOutlet UITextField *inputEMailField;

@end
