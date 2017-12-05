//
//  ELTeamDevelopmentPlanTests.m
//  EdwardLynxTests
//
//  Created by Jason Jon E. Carreos on 04/12/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ELTeamAPIClient.h"
#import "ELTeamViewManager.h"

@interface ELTeamDevelopmentPlanTests : XCTestCase

@property (nonatomic) NSTimeInterval timeout;

@property (nonatomic, strong) ELTeamAPIClient *client;
@property (nonatomic, strong) ELTeamViewManager *viewManager;

@end

@implementation ELTeamDevelopmentPlanTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.timeout = 10;
    self.client = [[ELTeamAPIClient alloc] init];
    self.viewManager = [[ELTeamViewManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchManagerIndividualPlansSuccess {
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    
    // When
    [self.client linkedUsersDevPlansWithParams:nil completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(!error && !responseDict[@"error"]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testTeamDevPlansSuccess {
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    
    // When
    [self.client teamDevPlansWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(!error && !responseDict[@"error"]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

- (void)testTeamReportsSuccess {
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    
    // When
    [self.client managerReportsWithCompletion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(!error && !responseDict[@"error"]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}


- (void)testTeamDevPlanCreationSuccess {
    XCTestExpectation *expectation;
    NSDictionary *params = @{@"name": @"Test Category", @"lang": @"en"};
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    
    // When
    [self.client createTeamDevPlanWithParams:params
                                  completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(!error && !responseDict[@"error"]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:self.timeout handler:nil];
}

@end
