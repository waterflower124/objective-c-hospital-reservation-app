//
//  AppointmentList.h
//  Hospital
//
//  Created by Water Flower on 10/31/20.
//  Copyright © 2020 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "SCLAlertView.h"
#import "MBProgressHUD.h"
#import "Utility.h"
#import "AppDelegate.h"
#import "AppointmentListTableViewCell.h"
#import "UIImageView+RJLoader.h"
#import "UIImageView+WebCache.h"
#import "Detail.h"
#import "PaymentConfirmation.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppointmentList : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UIImageView *imgBack;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *pendingButton;
    IBOutlet UIImageView *pendingLineImageView;
    IBOutlet UIButton *expiredButton;
    IBOutlet UIImageView *expiredLineImageView;
    
    IBOutlet UITableView *appointmentTableView;
    
    NSMutableArray *record_array;
    NSString *listType;
    NSMutableData *receivedData1;
    
}
- (IBAction)pendingButtonAction:(id)sender;
- (IBAction)expiredButtonAction:(id)sender;



@end

NS_ASSUME_NONNULL_END
