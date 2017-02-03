//
//  ELParticipant.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

#import "ELModel.h"

@interface ELParticipant : ELModel

@property (nonatomic) BOOL isSelected;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *email;

@end
