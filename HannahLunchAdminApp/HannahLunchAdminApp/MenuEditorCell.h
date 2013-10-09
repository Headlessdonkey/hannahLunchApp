//
//  MenuEditorCell.h
//  HannahLunchAdminApp
//
//  Created by Jason Pepas on 10/8/13.
//  Copyright (c) 2013 uShip. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuEditorCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *dayOfWeekLabel;

@property (strong, nonatomic) IBOutlet UILabel *mainDishLabel;
@property (strong, nonatomic) IBOutlet UITextField *mainDishTextField;

@property (strong, nonatomic) IBOutlet UILabel *sideDishesLabel;
@property (strong, nonatomic) IBOutlet UITextField *sideDishesTextField;

+ (NSString*)reuseIdentifier;

- (id)init;

@end
