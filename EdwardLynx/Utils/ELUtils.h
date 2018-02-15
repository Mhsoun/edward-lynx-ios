//
//  ELUtils.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 12/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

@class ELBaseQuestionTypeView;
@class ELDevelopmentPlan;
@class ELListPopupViewController;
@class ELPopupViewController;
@class PNCircleChart;

#import <MessageUI/MessageUI.h>

#import "ELQuestion.h"

@interface ELFormItemGroup : NSObject

/**
 Custom init method for ELFormItemGroup.
 
 @param textField UITextField where the input text is .
 @param icon UIImageView of the icon.
 @param errorLabel UILabel of the error message of.
 @return ELFormItemGroup instance
 */
- (instancetype)initWithInput:(__kindof UIView<UITextInput> *)textField
                         icon:(UIImageView *)icon
                   errorLabel:(UILabel *)errorLabel;
/**
 Custom init method for ELFormItemGroup.
 
 @param text Input text.
 @param icon UIImageView of the icon.
 @param errorLabel UILabel of the error message of.
 @return ELFormItemGroup instance
 */
- (instancetype)initWithText:(NSString *)text
                        icon:(UIImageView *)icon
                  errorLabel:(UILabel *)errorLabel;
/**
 @return Text from textField or actual text value.
 */
- (NSString *)textValue;
/**
 Checks if the input corresponds to an error or not. Toggles state of field, icon, and error message based on its status.
 
 @param errors List of NSError instances or actual error messages.
 */
- (void)toggleValidationIndicatorsBasedOnErrors:(NSArray *)errors;

@end

@interface ELUtils : NSObject

/**
 Returns an app-specific object from NSUserDefaults storage given its corresponding key.
 
 @param key Identifier of the object.
 @return An id instance of the retrieved object.
 */
+ (id)getUserDefaultsCustomObjectForKey:(NSString *)key;
/**
 Returns a NSObject from NSUserDefaults storage given its corresponding key.
 
 @param key Identifier of the object.
 @return An id instance of the retrieved object.
 */
+ (id)getUserDefaultsObjectForKey:(NSString *)key;
/**
 Returns a value from NSUserDefaults storage given its corresponding key.
 
 @param key Identifier of the object.
 @return An id instance of the retrieved object.
 */
+ (id)getUserDefaultsValueForKey:(NSString *)key;
/**
 Stores an app-specific object to NSUserDefaults storage with its identifier.
 
 @param object A NSObject subcleass to be stored.
 @param key Object identifier.
 */
+ (void)setUserDefaultsCustomObject:(__kindof NSObject *)object key:(NSString *)key;
/**
 Stores an NSObject to NSUserDefaults storage with its identifier.
 
 @param object A NSObject subcleass to be stored.
 @param key Object identifier.
 */
+ (void)setUserDefaultsObject:(__kindof NSObject *)object key:(NSString *)key;
/**
 Stores a value to NSUserDefaults storage with its identifier.
 
 @param value Any value to be stored.
 @param key Identifier.
 */
+ (void)setUserDefaultsValue:(id)value key:(NSString *)key;

/**
 Performs authentication request given the user's stored credentials.
 
 @param completion Block where the completion of request is handled.
 */
+ (void)processReauthenticationWithCompletion:(void (^)(NSURLResponse *, NSDictionary *, NSError *))completion;

+ (void)fabricForceCrash;
+ (void)fabricLogUserInformation:(NSDictionary *)infoDict;

/**
 Preliminary setup for Fabric library
 */
+ (void)setupFabric;
/**
 Preliminary setup for HockeyApp library
 */
+ (void)setupHockeyApp;
/**
 Preliminary setup for IQKeyboardManager library
 */
+ (void)setupIQKeyboardManager;

/**
 Performs a shake animation to a cell.
 
 @param cell Cel to be animated.
 */
+ (void)animateCell:(__kindof UITableViewCell *)cell;
/**
 Returns a kELAnswerType instance based on provided text.
 
 @param label String representation of desired kELAnswerType instance.
 @return Corresponding kELAnswerType.
 */
+ (kELAnswerType)answerTypeByLabel:(NSString *)label;
/**
 Sets up a PNCircleChart instance to its basic configuration
 
 @param chart PNCircleChart to be configured.
 @param progress Progress of the chart to be displayed.
 */
+ (void)circleChart:(PNCircleChart *)chart progress:(CGFloat)progress;
/**
 Presents a MFMailComposeViewController instance to current page prepopulated with provided details.
 
 @param controller Where the MFMailComposeViewController instance will be presented.
 @param detailsDict NSDictionary where e-mail details are provided.
 */
+ (void)composeMailForController:(__kindof UIViewController *)controller details:(NSDictionary *)detailsDict;
/**
 Reads a JSON file.
 
 @param filename Name of the file (excluding its extension).
 @return A dictionary representation of the JSON file.
 */
+ (NSDictionary *)dictionaryFromJSONAtFile:(NSString *)filename;
/**
 Presents a ELPopupViewController instance.
 
 @param controller Where the popup controller is presented.
 @param type Popup type to be presented
 @param detailsDict Details to be fed to the popup controller.
 */
+ (void)displayPopupForViewController:(__kindof UIViewController *)controller
                                 type:(kELPopupType)type
                              details:(NSDictionary *)detailsDict;
/**
 Handles result of the MFMailComposeViewController instance presented.
 
 @param result Result returned by the MFMailComposeViewController instance.
 @param controller Where the MFMailComposeViewController instance is presented.
 */
+ (void)handleMailResult:(MFMailComposeResult)result fromParentController:(__kindof UIViewController *)controller;
/**
 Returns a string representation of a kELAnswerType instance.
 
 @param type Where the string to be returned is based.
 @return NSString instance of the corresponding type.
 */
+ (NSString *)labelByAnswerType:(kELAnswerType)type;
/**
 Returns a string representation of a kELListFilter instance.
 
 @param filter Where the string to be returned is based.
 @return NSString instance of the corresponding type.
 */
+ (NSString *)labelByListFilter:(kELListFilter)filter;
/**
 Returns a string representation of a kELSurveyStatus instance.
 
 @param status Where the string to be returned is based.
 @return NSString instance of the corresponding type.
 */
+ (NSString *)labelBySurveyStatus:(kELSurveyStatus)status;
/**
 Returns a string representation of a kELSurveyType instance.
 
 @param type Where the string to be returned is based.
 @return NSString instance of the corresponding type.
 */
+ (NSString *)labelBySurveyType:(kELSurveyType)type;
/**
 Returns a string representation of a kELUserRole instance.
 
 @param role Where the string to be returned is based.
 @return NSString instance of the corresponding type.
 */
+ (NSString *)labelByUserRole:(kELUserRole)role;
/**
 @return Generic UIAlertController instance indicating loading process.
 */
+ (UIAlertController *)loadingAlert;
/**
 Returns an ordered set of keys based on its presentation order for the Report Details page.
 
 @param keys List of keys to be reordered.
 @return Ordered list of keys.
 */
+ (NSArray *)orderedReportKeysArray:(NSArray *)keys;
/**
 Performs download of a PDF file, storing it to app's sandbox Documents directory.
 
 @param link PDF file link.
 @param filename Desired filename of the downloaded PDF.
 */
+ (void)PDFDownloadFromLink:(NSString *)link filename:(NSString *)filename;
/**
 Retrieves PDF file from specified path for displaying.
 
 @param path Where the file is located.
 @return A NSURLRequest instance to be fed to a web view for viewing.
 */
+ (NSURLRequest *)PDFViewRequestFromPath:(NSString *)path;
/**
 Presents a toast view with details provided.
 
 @param view Where the toast will be presented.
 @param message The actual message to be displayed as a toast.
 @param completion Block where completion of display is handled.
 */
+ (void)presentToastAtView:(UIView *)view
                   message:(NSString *)message
                completion:(void (^)())completion;
/**
 Generates a ELQuestion instance based on specified kELAnswerType.
 
 @param answerType Type where the ELQuestion is based.
 @return ELQuestion instance with default values.
 */
+ (ELQuestion *)questionTemplateForAnswerType:(kELAnswerType)answerType;
/**
 Extracts a ELBaseQuestionTypeView instance from its parent view.
 
 @param view Refers to a parent view.
 @return ELBaseQuestionTypeView instance if any, else nil.
 */
+ (__kindof ELBaseQuestionTypeView *)questionViewFromSuperview:(UIView *)view;
/**
 Configure REValidation instances to be used for forms.
 */
+ (void)registerValidators;
/**
 Given two sets, generates a unique list of ELParticipant instances.
 
 @param subset Smaller set of ELParticipant instances.
 @param superset Larger set of ELParticipant instances.
 @return A unique list of ELParticipant instances.
 */
+ (NSArray *)removeDuplicateUsers:(NSArray *)subset superset:(NSArray *)superset;
/**
 Animated scroll view to scroll to its bottom-most section.
 
 @param scrollView UIScrollView to be scrolled.
 */
+ (void)scrollViewToBottom:(UIScrollView *)scrollView;
/**
 Collection of app-wide manipulation of app UIKit properties and styles.
 */
+ (void)setupGlobalUIChanges;
/**
 Determines whether a given kELAnswerType needs to be expanded or not
 
 @param type The type to check.
 @return BOOL value based on condition.
 */
+ (BOOL)toggleQuestionTypeViewExpansionByType:(kELAnswerType)type;
/**
 Returns a kELUserRole instance based on provided text.
 
 @param label String representation of kELUserRole.
 @return kELUserRole instance.
 */
+ (kELUserRole)userRoleByLabel:(NSString *)label;
/**
 Returns a ELBaseQuestionTypeView instance based on provided kELAnswerType.
 
 @param type The type to base the ELBaseQuestionTypeView instance.
 @return ELBaseQuestionTypeView instance.
 */
+ (__kindof ELBaseQuestionTypeView *)viewByAnswerType:(kELAnswerType)type;

@end
