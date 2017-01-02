//
//  ELQuestionTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 02/01/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

@interface ELQuestionTableViewCell : UITableViewCell<ELConfigurableCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UIView *questionTypeView;

@end
