//
//  ELDevelopmentPlanTests.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 08/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ELDevelopmentPlanAPIClient.h"
#import "ELDevelopmentPlanViewManager.h"

@interface ELDevelopmentPlanTests : XCTestCase

@property (nonatomic, strong) ELDevelopmentPlanAPIClient *client;
@property (nonatomic, strong) ELDevelopmentPlanViewManager *viewManager;

@end

@implementation ELDevelopmentPlanTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.client = [[ELDevelopmentPlanAPIClient alloc] init];
    self.viewManager = [[ELDevelopmentPlanViewManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateDevelopmentPlanFormValuesInvalid {
    BOOL isValid;
    ELFormItemGroup *group1;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateDevelopmentPlanFormValues:@{@"name": group1}];
    
    // Then
    XCTAssert(!isValid);
}

- (void)testCreateDevelopmentPlanFormValuesValid {
    BOOL isValid;
    ELFormItemGroup *group1;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"Development Plan from iOS Unit Testing" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateDevelopmentPlanFormValues:@{@"name": group1}];
    
    // Then
    XCTAssert(isValid);
}

- (void)testCreateDevelopmentPlanFail {
    NSDictionary *formDict;
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    formDict = @{@"name": @"",
                 @"target": @(-1),
                 @"goals": @[]};
    
    // When
    [self.client createDevelopmentPlansWithParams:formDict
                                       completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testCreateDevelopmentPlanSuccess {
    NSDictionary *formDict;
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    formDict = @{@"name": @"Development Plan from iOS Unit Testing",
                 @"target": @1,
                 @"goals": @[@{@"title": @"Unit test Accounts",
                               @"description": @"",
                               @"dueDate": @"2017-08-31T06:54:33+01:00",
                               @"position": @0,
                               @"actions": @[@{@"title": @"Test login",
                                               @"position": @0},
                                             @{@"title": @"Test change password",
                                               @"position": @1}]}]};
    
    // When
    [self.client createDevelopmentPlansWithParams:formDict
                                       completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
