//
//  ELAddObjectTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 18/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@interface ELAddObjectTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) id<ELAddItemDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)onAddButtonClick:(id)sender;

@end
