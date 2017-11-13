//
//  ELSurveyTests.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 08/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ELQuestionsAPIClient.h"
#import "ELSurveysAPIClient.h"

@interface ELSurveyTests : XCTestCase

@property (nonatomic, strong) ELSurveysAPIClient *client;

@end

@implementation ELSurveyTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.client = [[ELSurveysAPIClient alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQuestionCategoriesRetrieval {
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    
    // When
    [[[ELQuestionCategoriesAPIClient alloc] init] categoriesOfUserWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(!error && !responseDict[@"error"]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testSurveysRetrieval {
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    
    // When
    [self.client currentUserSurveysWithQueryParams:@{@"filter": @"answerable", @"page": @1}
                                        completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(!error && !responseDict[@"error"]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
