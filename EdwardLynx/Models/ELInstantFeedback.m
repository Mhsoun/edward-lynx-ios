//
//  ELInstantFeedback.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 17/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELInstantFeedback.h"
#import "ELParticipant.h"

@implementation ELInstantFeedback

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
                                                                  @"participants": @"recipients",
                                                                  @"question": @"questions"}];
}

- (void)setParticipantsWithNSArray:(NSArray<Optional,ELParticipant> *)participants {
    NSMutableArray *mParticipants = [[NSMutableArray alloc] init];
    
    for (NSDictionary *participantDict in participants) {
        ELParticipant *participant = [[ELParticipant alloc] initWithDictionary:participantDict error:nil];
        
        [participant setIsSelected:YES];
        [participant setIsAlreadyInvited:YES];
        [mParticipants addObject:participant];
    }
    
    self.participants = [mParticipants copy];
}

- (void)setQuestionWithNSArray:(NSArray *)questions {
    if (questions.count == 0) {
        self.question = nil;
        
        return;
    }
    
    self.question = [[ELQuestion alloc] initWithDictionary:questions[0] error:nil];
}

@end
