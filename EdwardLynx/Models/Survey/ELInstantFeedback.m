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

@synthesize dateString = _dateString;
@synthesize searchTitle = _searchTitle;

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"objectId": @"id",
//                                                                  @"createdBy": @"name",
                                                                  @"participants": @"recipients",
                                                                  @"question": @"questions",
                                                                  @"answered": @"stats.answered",
                                                                  @"invited": @"stats.invited"}];
}

+ (BOOL)propertyIsIgnored:(NSString *)propertyName {
    return ([propertyName isEqualToString:@"noOfParticipantsAnswered"] ||
            [propertyName isEqualToString:@"searchTitle"]);
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

- (NSString *)searchTitle {
    return self.question.text;
}

- (void)setQuestionWithNSArray:(NSArray *)questions {
    if (questions.count == 0) {
        self.question = nil;
        
        return;
    }
    
    self.question = [[ELQuestion alloc] initWithDictionary:questions[0] error:nil];
}

- (NSString<Ignore> *)dateString {
    return [AppSingleton.printDateFormatter stringFromDate:self.createdAt];
}

@end
