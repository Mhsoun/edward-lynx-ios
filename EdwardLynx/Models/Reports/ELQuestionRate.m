//
//  ELQuestionRate.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELQuestionRate.h"

@implementation ELQuestionRate

@synthesize candidates = _candidates;
@synthesize others = _others;

- (double)candidates {
    return _candidates > 1.0f ? _candidates / 100.0 : _candidates;
}

- (double)others {
    return _others > 1.0f ? _others / 100.0 : _others;
}

@end
