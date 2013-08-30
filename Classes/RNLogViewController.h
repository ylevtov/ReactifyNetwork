//
//  RNLog2ViewController.h
//  ReactifyNetwork
//
//  Created by Yuli A Levtov on 24/08/2013.
//  Copyright (c) 2013 Reactify. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface RNLogViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate, ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate> {
    int indexOfPersonAdded;
}

@property (nonatomic, weak) IBOutlet UITableView *logTableView;

@property (nonatomic, strong) NSMutableArray *persons;

- (void)addPerson:(id)sender;

@end
