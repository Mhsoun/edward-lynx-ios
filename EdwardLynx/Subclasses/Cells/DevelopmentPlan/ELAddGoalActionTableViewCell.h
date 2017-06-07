//
//  ELAddGoalActionTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 07/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELAddGoalActionTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *addLink;

@property (weak, nonatomic) IBOutlet UIButton *addActionButton;
- (IBAction)onAddActionButtonClick:(id)sender;

@end
