//
//  ELManagerCategoryViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 21/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerCategoryViewController.h"

static NSString * const kELCellIdentifier = @"ManagerCategoryCell";

@interface ELManagerCategoryViewController ()

@property (nonatomic, strong) NSMutableArray *mCategories;

@end

@implementation ELManagerCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.mCategories = [[NSMutableArray alloc] initWithArray:@[@"Test 1",
                                                               @"Test 2",
                                                               @"Test 3",
                                                               @"Test 4"]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = YES;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Protocol Methods (UITableView)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mCategories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kELCellIdentifier
                                                            forIndexPath:indexPath];
    
    cell.textLabel.font = Font(@"Lato-Regular", 14.0f);
    cell.textLabel.text = self.mCategories[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSString *category = self.mCategories[sourceIndexPath.row];
    
    [self.mCategories removeObjectAtIndex:sourceIndexPath.row];
    [self.mCategories insertObject:category atIndex:destinationIndexPath.row];
}

@end
