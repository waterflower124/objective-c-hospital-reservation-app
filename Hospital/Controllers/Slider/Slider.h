//
//  Slider.h
//  Hospital
//
//  Created by Kiran Padhiyar on 27/01/18.
//  Copyright © 2018 Redixbit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Slider : UIViewController<UIScrollViewDelegate>
{
    CGFloat currentIndex;
    CGFloat btnBorder;
    CGFloat btnRound;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *btn_skip;

@property (weak, nonatomic) IBOutlet UILabel *sliderTitle1;
@property (weak, nonatomic) IBOutlet UILabel *sliderDesc1;
@property (weak, nonatomic) IBOutlet UILabel *sliderSubDesc1;

@property (weak, nonatomic) IBOutlet UILabel *sliderTitle2;
@property (weak, nonatomic) IBOutlet UILabel *sliderDesc2;
@property (weak, nonatomic) IBOutlet UILabel *sliderSubDesc2;

@property (weak, nonatomic) IBOutlet UILabel *sliderTitle3;
@property (weak, nonatomic) IBOutlet UILabel *sliderDesc3;
@property (weak, nonatomic) IBOutlet UILabel *sliderSubDesc3;

@property (weak, nonatomic) IBOutlet UIImageView *icon1;
@property (weak, nonatomic) IBOutlet UIImageView *icon2;
@property (weak, nonatomic) IBOutlet UIImageView *icon3;

@property (weak, nonatomic) IBOutlet UIButton *btnContinue;

- (IBAction)didClickSkipButton:(id)sender;
- (IBAction)didClickNextButton:(id)sender;

@end
