//
//  ELInstantFeedbackTests.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 08/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ELFeedbackViewManager.h"
#import "ELSurveysAPIClient.h"

@interface ELInstantFeedbackTests : XCTestCase

@property (nonatomic, strong) ELFeedbackViewManager *viewManager;
@property (nonatomic, strong) ELSurveysAPIClient *client;

@end

@implementation ELInstantFeedbackTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.client = [[ELSurveysAPIClient alloc] init];
    self.viewManager = [[ELFeedbackViewManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateInstantFeedbackFormValuesInvalid {
    BOOL isValid;
    ELFormItemGroup *group1, *group2;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"No type selected" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"Is this a question?" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateCreateInstantFeedbackFormValues:@{@"type": group1,
                                                                          @"question": group2,
                                                                          @"anonymous": @NO,
                                                                          @"isNA": @NO}];
    
    // Then
    XCTAssert(!isValid);
}

- (void)testCreateInstantFeedbackFormValuesValid {
    BOOL isValid;
    ELFormItemGroup *group1, *group2;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"Yes/No Scale" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"Is this a question?" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateCreateInstantFeedbackFormValues:@{@"type": group1,
                                                                          @"question": group2,
                                                                          @"anonymous": @NO,
                                                                          @"isNA": @NO}];
    
    // Then
    XCTAssert(isValid);
}

- (void)testCreateInstantFeedbackFail {
    NSDictionary *formDict;
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    formDict = @{@"lang": @"en",
                 @"anonymous": @NO,
                 @"questions": @[],
                 @"recipients": @[]};
    
    // When
    [self.client createInstantFeedbackWithParams:formDict
                                      completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testCreateInstantFeedbackSuccess {
    NSDictionary *formDict;
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    formDict = @{@"lang": @"en",
                 @"anonymous": @NO,
                 @"questions": @[@{@"text": @"Is this a question from iOS Unit test?",
                                   @"isNA": @NO,
                                   @"answer": @{@"type": @3}}],
                 @"recipients": @[@{@"name": @"Test User",
                                    @"email": @"test@test.com"}]};
    
    // When
    [self.client createInstantFeedbackWithParams:formDict
                                      completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
