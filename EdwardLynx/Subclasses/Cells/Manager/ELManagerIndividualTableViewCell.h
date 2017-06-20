//
//  ELManagerIndividualTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELManagerIndividualTableViewCell : UITableViewCell<ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *chartViews;
- (IBAction)onSeeMoreButtonClick:(id)sender;

@end
