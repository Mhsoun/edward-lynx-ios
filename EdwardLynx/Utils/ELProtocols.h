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

- (void)onAPIResponseError:(NSDictionary *)errorDict;
- (void)onAPIResponseSuccess:(NSDictionary *)responseDict;

@end

@protocol ELAPIPostResponseDelegate <NSObject>

- (void)onAPIPostResponseError:(NSDictionary *)errorDict;
- (void)onAPIPostResponseSuccess:(NSDictionary *)responseDict;

@end

@protocol ELAddItemDelegate <NSObject>

- (void)onAddNewItem:(NSString *)item;

@end

@protocol ELBaseViewControllerDelegate <NSObject>

@optional
- (void)layoutPage;

@end

@protocol ELConfigurableCellDelegate <NSObject>

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ELDashboardViewDelegate <NSObject>

- (void)viewTapToPerformControllerPushWithIdentifier:(NSString *)identifier;

@end

@protocol ELQuestionTypeDelegate <NSObject>

- (instancetype)initWithNibName:(NSString *)nib;
- (NSDictionary *)formValues;

@end

@protocol ELRowHandlerDelegate <NSObject>

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (void)handleObject:(id)object deselectionActionAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark - Class-specific Delegates

@protocol ELDevelopmentPlanGoalDelegate <NSObject>

@optional
- (void)onGoalAddition:(__kindof ELModel *)object;

- (void)onGoalOptions:(__kindof ELModel *)object sender:(UIButton *)sender;
- (void)onGoalUpdate:(__kindof ELModel *)object;

@end

@protocol ELDropdownDelegate <NSObject>

- (void)onDropdownSelectionValueChange:(NSString *)value index:(NSInteger)index;

@end

@protocol ELItemCellDelegate <NSObject>

@optional
- (void)onUpdateAtRow:(NSInteger)row;

- (void)onDeletionAtRow:(NSInteger)row;

@end

@protocol ELListPopupDelegate <NSObject>

- (void)onItemSelection:(NSString *)item index:(NSInteger)index;

@end

@protocol ELListViewControllerDelegate <NSObject>

- (void)onRowSelection:(__kindof ELModel *)object;

@end

#endif /* ELProtocols_h */
