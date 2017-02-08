//
//  ELAccountsTests.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 08/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ELAccountsViewManager.h"
#import "ELUsersAPIClient.h"

@interface ELAccountsTests : XCTestCase

@property (nonatomic, strong) ELAccountsViewManager *viewManager;
@property (nonatomic, strong) ELUsersAPIClient *client;

@end

@implementation ELAccountsTests

#pragma mark - Test Methods

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.client = [[ELUsersAPIClient alloc] init];
    self.viewManager = [[ELAccountsViewManager alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoginFormValuesInvalid {
    BOOL isValid;
    ELFormItemGroup *group1, *group2;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateLoginFormValues:@{@"username": group1,
                                                          @"password": group2}];
    
    // Then
    XCTAssert(!isValid);
}

- (void)testLoginFormValuesValid {
    BOOL isValid;
    ELFormItemGroup *group1, *group2;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"username" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"password" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateLoginFormValues:@{@"username": group1,
                                                          @"password": group2}];
    
    // Then
    XCTAssert(isValid);
}

- (void)testLoginCredentialsFail {
    NSString *username, *password;
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asynchronous API request"];
    
    username = @"test";
    password = @"test";
    
    // When
    [self.client loginWithUsername:username
                          password:password
                        completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testLoginCredentialsSuccess {
    NSString *username, *password;
    
    // Given
    XCTestExpectation *expectation = [self expectationWithDescription:@"Asynchronous API request"];
    
    username = @"admin@edwardlynx.com";
    password = @"password123";
    
    // When
    [self.client loginWithUsername:username
                          password:password
                        completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testChangePasswordValuesInvalid {
    BOOL isValid;
    ELFormItemGroup *group1, *group2, *group3;
    
    // Case 1: Empty field(s)
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group3 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateChangePasswordFormValues:@{@"currentPassword": group1,
                                                                   @"password": group2,
                                                                   @"confirmPassword": group3}];
    
    // Then
    XCTAssert(!isValid);
    
    // Case 2: Password and Confirm Password not the same
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"somepassword" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"newpassword" icon:nil errorLabel:nil];
    group3 = [[ELFormItemGroup alloc] initWithText:@"newpasswordupdate" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateChangePasswordFormValues:@{@"currentPassword": group1,
                                                                   @"password": group2,
                                                                   @"confirmPassword": group3}];
    
    // Then
    XCTAssert(!isValid);
}

- (void)testChangePasswordValuesValid {
    BOOL isValid;
    ELFormItemGroup *group1, *group2, *group3;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"somepassword" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"newpassword" icon:nil errorLabel:nil];
    group3 = [[ELFormItemGroup alloc] initWithText:@"newpassword" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateChangePasswordFormValues:@{@"currentPassword": group1,
                                                                   @"password": group2,
                                                                   @"confirmPassword": group3}];
    
    // Then
    XCTAssert(isValid);
}

- (void)testChangePasswordFail {
    NSDictionary *formDict;
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    formDict = @{@"password": @"somepassword",
                 @"currentPassword": @"newpasword"};
    
    // When
    [self.client updateUserInfoWithParams:formDict
                               completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testChangePasswordSuccess {
    NSDictionary *formDict;
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    formDict = @{@"password": @"somepassword",
                 @"currentPassword": @"newpasword"};
    
    // When
    [self.client updateUserInfoWithParams:formDict
                               completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testProfileUpdateFormValuesInvalid {
    BOOL isValid;
    ELFormItemGroup *group1, *group2, *group3, *group4, *group5, *group6, *group7;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group3 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group4 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group5 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group6 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    group7 = [[ELFormItemGroup alloc] initWithText:@"" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateProfileUpdateFormValues:@{@"name": group1,
                                                                  @"gender": group2,
                                                                  @"info": group3,
                                                                  @"role": group4,
                                                                  @"department": group5,
                                                                  @"city": group6,
                                                                  @"country": group7}];
    
    // Then
    XCTAssert(!isValid);
}

- (void)testProfileUpdateFormValuesValid {
    BOOL isValid;
    ELFormItemGroup *group1, *group2, *group3, *group4, *group5, *group6, *group7;
    
    // Given
    group1 = [[ELFormItemGroup alloc] initWithText:@"Some Name" icon:nil errorLabel:nil];
    group2 = [[ELFormItemGroup alloc] initWithText:@"Male" icon:nil errorLabel:nil];
    group3 = [[ELFormItemGroup alloc] initWithText:@"Some Info" icon:nil errorLabel:nil];
    group4 = [[ELFormItemGroup alloc] initWithText:@"Some Role" icon:nil errorLabel:nil];
    group5 = [[ELFormItemGroup alloc] initWithText:@"Some Departments" icon:nil errorLabel:nil];
    group6 = [[ELFormItemGroup alloc] initWithText:@"Some City" icon:nil errorLabel:nil];
    group7 = [[ELFormItemGroup alloc] initWithText:@"Some Country" icon:nil errorLabel:nil];
    
    // When
    isValid = [self.viewManager validateProfileUpdateFormValues:@{@"name": group1,
                                                                  @"gender": group2,
                                                                  @"info": group3,
                                                                  @"role": group4,
                                                                  @"department": group5,
                                                                  @"city": group6,
                                                                  @"country": group7}];
    
    // Then
    XCTAssert(isValid);
}

- (void)testProfileUpdateFail {
    NSDictionary *formDict;
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    formDict = @{@"name": @"Some Name",
                 @"info": @"Some Info",
                 @"role": @"Some Role",
                 @"department": @"Some Department",
                 @"gender": @"Male",
                 @"city": @"Some City",
                 @"country": @"Some Country"};
    
    // When
    [self.client updateUserInfoWithParams:formDict
                               completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssert(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testProfileUpdateSuccess {
    NSDictionary *formDict;
    XCTestExpectation *expectation;
    
    // Given
    expectation = [self expectationWithDescription:@"Asynchronous API request"];
    formDict = @{@"name": @"Some Name",
                 @"info": @"Some Info",
                 @"role": @"Some Role",
                 @"department": @"Some Department",
                 @"gender": @"Male",
                 @"city": @"Some City",
                 @"country": @"Some Country"};
    
    // When
    [self.client updateUserInfoWithParams:formDict
                               completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
        // Then
        XCTAssertNil(error);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

@end
