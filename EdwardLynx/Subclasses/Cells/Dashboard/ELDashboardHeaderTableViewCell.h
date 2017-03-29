//
//  ELDashboardHeaderTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/03/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELDashboardHeaderTableViewCell : UITableViewCell<ELDashboardViewDelegate>

@property (nonatomic, strong) id<ELDashboardViewDelegate> delegate;

- (void)setupHeaderContent;

@end
