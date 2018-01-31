//
//  ELProtocols.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 13/12/2016.
//  Copyright © 2016 Ingenuity Global Consulting. All rights reserved.
//

#ifndef ELProtocols_h
#define ELProtocols_h

#pragma mark - Generic Delegates

@protocol ELAPIResponseDelegate <NSObject>

/**
 Protocol method called when handling API GET/DELETE request errors.

 @param errorDict Contain details regarding the error.
 */
- (void)onAPIResponseError:(NSDictionary *)errorDict;
/**
 Protocol method called when handling API GET/DELETE request on success.

 @param responseDict Contain details regarding the response.
 */
- (void)onAPIResponseSuccess:(NSDictionary *)responseDict;

@end

@protocol ELAPIPostResponseDelegate <NSObject>

/**
 Protocol method called when handling API POST/PUT request errors.
 
 @param errorDict Contain details regarding the error.
 */
- (void)onAPIPostResponseError:(NSDictionary *)errorDict;
/**
 Protocol method called when handling API POST/PUT request on success.
 
 @param responseDict Contain details regarding the response.
 */
- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict;

@end

@protocol ELAddItemDelegate <NSObject>

- (void)onAddNewItem:(NSString *)item;

@end

@protocol ELBaseViewControllerDelegate <NSObject>

@optional
/**
 Protocol method where view controller-specific UI additions are placed.
 */
- (void)layoutPage;

@end

@protocol ELConfigurableCellDelegate <NSObject>

/**
 Protocol method where UITableViewCell instances can pass any object to populate its details.

 @param object The object where the cell's content will be based.
 @param indexPath index of the current cell.
 */
- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ELDashboardViewDelegate <NSObject>

/**
 Protocol method triggered when user select either of the 3/4 main dashboard items and 4 dashboard actions.

 @param identifier The identifier of the selected item/action.
 */
- (void)viewTapToPerformControllerPushWithIdentifier:(NSString *)identifier;

@end

@protocol ELQuestionTypeDelegate <NSObject>

/**
 Protocol method used for ELBaseQuestionTypeView instances.

 @param nib Name of view's corresponding XIB file.
 @return ELBaseQuestionTypeView instance.
 */
- (instancetype)initWithNibName:(NSString *)nib;
/**
 @return NSDictionary containing the question's id, answer value (and/or explanation), and answer type.
 */
- (NSDictionary *)formValues;

@end

@protocol ELRowHandlerDelegate <NSObject>

/**
 Protocol method triggered when a UITableViewCell conforming to this protocol is selected.

 @param object Current object associated to the cell.
 @param indexPath Selected cell's index path.
 */
- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath;
@optional
/**
 Protocol method triggered when a UITableViewCell conforming to this protocol is deselected.
 
 @param object Current object associated to the cell.
 @param indexPath Deselected cell's index path.
 */
- (void)handleObject:(id)object deselectionActionAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - Class-specific Delegates

@protocol ELDevelopmentPlanGoalDelegate <NSObject>

@optional
/**
 Protocol method invoked when a goal is added

 @param object ELModel instance newly added.
 */
- (void)onGoalAddition:(__kindof ELModel *)object;
/**
 Protocol method invoked when a goal's options is accessed.
 
 @param object ELModel instance selected.
 @param sender Source of action.
 */
- (void)onGoalOptions:(__kindof ELModel *)object sender:(UIButton *)sender;
/**
 Protocol method invoked when a goal is updated.
 
 @param object ELModel instance updated.
 */
- (void)onGoalUpdate:(__kindof ELModel *)object;

@end

@protocol ELDropdownDelegate <NSObject>

/**
 Protocol method triggered when an ELDropdown instance's value changed.

 @param value The new value selected.
 @param index The selected value's index.
 */
- (void)onDropdownSelectionValueChange:(NSString *)value index:(NSInteger)index;

@end

@protocol ELItemCellDelegate <NSObject>

@optional
/**
 Protocol method trigger when an ELItemTableViewCell instance is updated.

 @param row Index of selected cell.
 */
- (void)onUpdateAtRow:(NSInteger)row;
/**
 Protocol method trigger when an ELItemTableViewCell instance is deleted.
 
 @param row Index of selected cell.
 */
- (void)onDeletionAtRow:(NSInteger)row;

@end

@protocol ELListPopupDelegate <NSObject>

/**
 Protocol method trigger when an item is selected in an ELListPopupViewController.
 
 @param item The item selected.
 @param index The selected row's index.
 */
- (void)onItemSelection:(NSString *)item index:(NSInteger)index;

@end

@protocol ELListViewControllerDelegate <NSObject>

/**
 Protocol method trigger when an item is selected in an ELListViewController.
 
 @param object ELModel instance selected.
 */
- (void)onRowSelection:(__kindof ELModel *)object;

@end

#endif /* ELProtocols_h */
