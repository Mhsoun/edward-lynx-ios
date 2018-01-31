//
//  ELMenuItem.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ELMenuItem : JSONModel

@property (nonatomic) NSString *name;
@property (nonatomic) NSString *segueIdentifier;
@property (nonatomic) NSString *iconIdentifier;

@end
