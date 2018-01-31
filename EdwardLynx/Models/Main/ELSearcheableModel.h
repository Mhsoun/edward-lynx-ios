//
//  ELSearcheableModel.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 06/04/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELModel.h"

@interface ELSearcheableModel : ELModel

/**
 Returns the attribute to be based on when searching an instance of its subclass.
 */
@property (nonatomic) NSString *searchTitle;

@end
