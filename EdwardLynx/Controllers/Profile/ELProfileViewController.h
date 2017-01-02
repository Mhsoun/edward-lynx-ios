//
//  ELProfileViewController.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#import "ELBaseViewController.h"
#import "ELUsersAPIClient.h"

@interface ELProfileViewController : ELBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end
