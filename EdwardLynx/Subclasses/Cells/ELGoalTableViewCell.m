//
//  ELGoalTableViewCell.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 01/02/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELGoalTableViewCell.h"

#pragma mark - Private Constants

static NSString * const kELCellIdentifier = @"ActionCell";

#pragma mark - Class Extension

@interface ELGoalTableViewCell ()

@property (nonatomic, strong) ELGoal *goal;

@end

@implementation ELGoalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.tintColor = [[RNThemeManager sharedManager] colorForKey:kELGreenColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Protocol Methods

- (void)configure:(id)object atIndexPath:(NSIndexPath *)indexPath {
    self.goal = (ELGoal *)object;
    
    // Content
    [self updateContent];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goal.actions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier];
    ELGoalAction *action = self.goal.actions[indexPath.row];
    
    action.urlLink = [NSString stringWithFormat:@"%@/actions/%@", self.goal.urlLink, @(action.objectId)];
    
    cell.textLabel.text = action.title;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    [cell setAccessoryType:action.checked ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController *controller;
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableArray *mActions = [[NSMutableArray alloc] initWithArray:self.goal.actions];
    ELGoalAction *goalAction = mActions[indexPath.row];
    __kindof UIViewController *visibleController = [delegate visibleViewController:self.window.rootViewController];
    void (^actionBlock)(UIAlertAction *) = ^(UIAlertAction *action) {
        ELDevelopmentPlanAPIClient *client = [[ELDevelopmentPlanAPIClient alloc] init];
        
        goalAction.checked = YES;
        
        [client updateGoalActionWithParams:[goalAction apiPatchDictionary]
                                      link:goalAction.urlLink
                                completion:^(NSURLResponse *response, NSDictionary *responseDict, NSError *error) {
            UITableViewCell *cell;
            
            if (error) {
                return;
            }
            
            cell = [tableView cellForRowAtIndexPath:indexPath];
            goalAction.checked = YES;
            
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [mActions replaceObjectAtIndex:indexPath.row withObject:goalAction];
            [self.goal setActions:[mActions copy]];
            [self updateContent];
            
            [ELUtils presentToastAtView:visibleController.view
                                message:@"Action successfully updated."
                             completion:^{}];
        }];
    };
    
    // FIX Cell being need to be clicked twice to invoke method
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (goalAction.checked) {
        return;
    }
    
    controller = [UIAlertController alertControllerWithTitle:@"Complete Action"
                                                     message:@"Is this action completed?"
                                              preferredStyle:UIAlertControllerStyleAlert];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Complete"
                                                   style:UIAlertActionStyleDefault
                                                 handler:actionBlock]];
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                   style:UIAlertActionStyleCancel
                                                 handler:nil]];
    
    [visibleController presentViewController:controller
                                    animated:YES
                                  completion:nil];
}

#pragma mark - Private Methods

- (void)updateContent {
    self.goalLabel.text = self.goal.title;
    self.completedLabel.text = [self.goal progressDetails][@"text"];
    self.descriptionLabel.text = self.goal.shortDescription.length == 0 ? @"No description added." :
                                                                          self.goal.shortDescription;
    
    [self.tableView reloadData];
}

@end
