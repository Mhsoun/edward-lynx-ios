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

@protocol ELBaseViewControllerDelegate <NSObject>

@optional
- (void)layoutPage;

@end

@protocol ELConfigurableCellDelegate <NSObject>

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ELRowHandlerDelegate <NSObject>

- (void)handleObject:(id)object selectionActionAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol ELAPIResponseDelegate <NSObject>

- (void)onAPIResponseError:(NSDictionary *)errorDict;
- (void)onAPIResponseSuccess:(NSDictionary *)responseDict;

@end

#endif /* ELProtocols_h */
