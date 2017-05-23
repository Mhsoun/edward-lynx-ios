//
//  ELNotification.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 09/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <JSONModel/JSONModel.h>

static NSString * const kELNotificationTypeDevPlan = @"dev-plan";
static NSString * const kELNotificationTypeInstantFeedbackRequest = @"instant-feedback-request";
static NSString * const kELNotificationTypeSurvey = @"survey";

@interface ELNotification : JSONModel

@property (nonatomic) int64_t objectId;
@property (nonatomic) NSInteger badge;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *body;
@property (nonatomic) NSString *type;

@end
