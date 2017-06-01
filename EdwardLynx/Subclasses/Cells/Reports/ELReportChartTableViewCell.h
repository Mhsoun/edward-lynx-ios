//
//  ELReportChartTableViewCell.h
//  EdwardLynx
//
//  Created by Jason Jon E. Carreos on 25/05/2017.
//  Copyright © 2017 Ingenuity Global Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kELReportChartType) {
    kELReportChartTypeBarCategory,
    kELReportChartTypeBarResponseRate,
    kELReportChartTypeComments,
    kELReportChartTypeHorizontalBar,
    kELReportChartTypeHorizontalBarBlindspot,
    kELReportChartTypeHorizontalBarBreakdown,
    kELReportChartTypeHorizontalBarHighestLowest,
    kELReportChartTypeRadar,
    kELReportChartTypePie
};

@interface ELReportChartTableViewCell : UITableViewCell<ELConfigurableCellDelegate>

@property (nonatomic) kELReportChartType chartType;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *chartContainerView;

@end
