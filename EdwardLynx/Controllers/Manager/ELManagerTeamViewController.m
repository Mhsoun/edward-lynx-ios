//
//  ELManagerTeamViewController.m
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 20/06/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import "ELManagerTeamViewController.h"
#import "ELCircleChartCollectionViewCell.h"
#import "ELManagerCategoryViewController.h"
#import "ELTeamDevelopmentPlan.h"
#import "ELTeamDevPlanDetailsViewController.h"
#import "ELTeamViewManager.h"

#pragma mark - Private Constants

static CGFloat const kELSpacing = 5;
static NSString * const kELCellIdentifier = @"CircleChartCell";
static NSString * const kELSegueIdentifier = @"ManagerCategory";

#pragma mark - Class Extension

@interface ELManagerTeamViewController ()

@property (nonatomic, strong) NSArray<ELTeamDevelopmentPlan *> *visibleItems;
@property (nonatomic, strong) NSMutableArray<ELTeamDevelopmentPlan *> *mItems;
@property (nonatomic, strong) ELTeamViewManager *viewManager;

@end

@implementation ELManagerTeamViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialization
    self.viewManager = [[ELTeamViewManager alloc] init];
    self.viewManager.delegate = self;
    
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    RegisterCollectionNib(self.collectionView, kELCellIdentifier);
    
    [self reloadPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    if (AppSingleton.needsPageReload) {
        [self reloadPage];
    }
    
    [super viewDidAppear:animated];
}

- (void)dealloc {
    DLog(@"%@", [self class]);
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kELSegueIdentifier]) {
        ELManagerCategoryViewController *controller = [segue destinationViewController];
        
        controller.mItems = self.mItems;
    }
}

#pragma mark - Protocol Methods (UICollectionView)

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.visibleItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ELCircleChartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kELCellIdentifier
                                                                                      forIndexPath:indexPath];
    
    [cell configure:self.visibleItems[indexPath.row] atIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ELTeamDevPlanDetailsViewController *controller = StoryboardController(@"DevelopmentPlan", @"TeamDevPlanDetails");
    
    controller.devPlanId = [self.visibleItems[indexPath.row] objectId];
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((CGRectGetWidth(collectionView.frame) / 3) - kELSpacing, 130);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kELSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kELSpacing;
}

#pragma mark - Protocol Methods (ELBaseViewController)

- (void)layoutPage {
    CGFloat iconHeight = 15;
    
    // Button
    [self.addCategoryButton setImage:[FontAwesome imageWithIcon:fa_pencil
                                                      iconColor:[UIColor blackColor]
                                                       iconSize:iconHeight
                                                      imageSize:CGSizeMake(iconHeight, iconHeight)]
                            forState:UIControlStateNormal];
}

#pragma mark - Protocol Methods (ELTeamViewManager)

- (void)onAPIResponseError:(NSDictionary *)errorDict {
    [self.indicatorView stopAnimating];
    [ELUtils presentToastAtView:self.view
                        message:NSLocalizedString(@"kELDetailsPageLoadError", nil)
                     completion:nil];
}

- (void)onAPIResponseSuccess:(NSDictionary *)responseDict {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.visible == 1"];
    
    for (NSDictionary *dict in responseDict[@"items"]) {
        [self.mItems addObject:[[ELTeamDevelopmentPlan alloc] initWithDictionary:dict error:nil]];
    }
    
    self.visibleItems = [self.mItems filteredArrayUsingPredicate:predicate];
    
    [self.indicatorView stopAnimating];
    [self.collectionView setHidden:NO];
    [self.collectionView reloadData];
}

#pragma mark - Protocol Methods (DZNEmptyDataSet)

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attributes = @{NSFontAttributeName: Font(@"Lato-Regular", 14.0f),
                                 NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"kELDevelopmentPlanEmptyMessage", nil)
                                           attributes:attributes];
}

#pragma mark - Protocol Methods (XLPagerTabStrip)

- (NSString *)titleForPagerTabStripViewController:(XLPagerTabStripViewController *)pagerTabStripViewController {
    return [NSLocalizedString(@"kELTabTitleTeam", nil) uppercaseString];
}

#pragma mark - Private Methods

- (void)reloadPage {
    self.mItems = [[NSMutableArray alloc] init];
    
    // Prepare for loading
    [self.collectionView setHidden:YES];
    [self.indicatorView startAnimating];
    
    [self.viewManager processRetrieveTeamDevPlans];
    
    AppSingleton.needsPageReload = NO;
}

#pragma mark - Interface Builder Actions

- (IBAction)onAddCategoryButtonClick:(id)sender {
    [self performSegueWithIdentifier:kELSegueIdentifier sender:self];
}

@end
