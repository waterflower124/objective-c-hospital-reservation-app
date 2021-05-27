//
//  Slider.m
//  Hospital
//
//  Created by Kiran Padhiyar on 27/01/18.
//  Copyright © 2018 Redixbit. All rights reserved.
//

#import "Slider.h"
#import "Constants.h"
#import "ViewController.h"

@interface Slider ()

@end

@implementation Slider

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    NSString * language = [[NSLocale preferredLanguages] firstObject];
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:DEFAULTS_KEY_LANGUAGE_CODE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        
        NSLog(@"CheRtl2");
         _icon1.image=[_icon1.image imageFlippedForRightToLeftLayoutDirection];
        _icon2.image=[_icon2.image imageFlippedForRightToLeftLayoutDirection];
        _icon3.image=[_icon3.image imageFlippedForRightToLeftLayoutDirection];

    }
    else
    {
        NSLog(@"CheRtl");
    }
    _sliderTitle1.text = NSLocalizedString(@"SliderTitle1", @"");
    _sliderDesc1.text = NSLocalizedString(@"SliderDesc1", @"");
    _sliderSubDesc1.text = NSLocalizedString(@"SliderSubDesc1", @"");
   
    
    _sliderTitle1.font = [UIFont fontWithName:relewayBold size:_sliderTitle1.font.pointSize];
    _sliderDesc1.font = [UIFont fontWithName:releway size:_sliderDesc1.font.pointSize];
    _sliderSubDesc1.font = [UIFont fontWithName:releway size:_sliderSubDesc1.font.pointSize];
    
    _sliderTitle2.text = NSLocalizedString(@"SliderTitle2", @"");
    _sliderDesc2.text = NSLocalizedString(@"SliderDesc2", @"");
    _sliderSubDesc2.text = NSLocalizedString(@"SliderSubDesc2", @"");
    
    
    _sliderTitle2.font = [UIFont fontWithName:relewayBold size:_sliderTitle2.font.pointSize];
    _sliderDesc2.font = [UIFont fontWithName:releway size:_sliderDesc2.font.pointSize];
    _sliderSubDesc2.font = [UIFont fontWithName:releway size:_sliderSubDesc2.font.pointSize];
    
    _sliderTitle3.text = NSLocalizedString(@"SliderTitle3", @"");
    _sliderDesc3.text = NSLocalizedString(@"SliderDesc3", @"");
    _sliderSubDesc3.text = NSLocalizedString(@"SliderSubDesc3", @"");
    
    
    _sliderTitle3.font = [UIFont fontWithName:relewayBold size:_sliderTitle3.font.pointSize];
    _sliderDesc3.font = [UIFont fontWithName:releway size:_sliderDesc3.font.pointSize];
    _sliderSubDesc3.font = [UIFont fontWithName:releway size:_sliderSubDesc3.font.pointSize];
   
    if (iPhoneVersion == 5) {
        btnBorder = 0.7;
        btnRound = 13;
    }
    else if(iPhoneVersion == 10)
    {
        btnBorder = 0.7;
        btnRound = 15;
    }
    else
    {
        btnBorder = 1;
        btnRound = 20;
    }
    [self.btnContinue.layer setBorderWidth:btnBorder];
    [self.btnContinue.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    _btnContinue.layer.cornerRadius = btnRound; // this value vary as per your desire
    _btnContinue.clipsToBounds = YES;
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"page_indicater"]];
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:
                                                      [UIImage imageNamed:@"page_indicater_selection"]];
    
    self.scrollView.contentSize=CGSizeMake(_scrollView.frame.size.width*3, _scrollView.frame.size.height);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *isSaved =  [[NSUserDefaults standardUserDefaults] stringForKey:@"loginSaved"];
    
    if (isSaved != nil)
    {
        ViewController *detail_page=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:detail_page animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate Method
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    currentIndex=_scrollView.contentOffset.x/_scrollView.frame.size.width;
    _pageControl.currentPage=(int)currentIndex;
    
    if (currentIndex==2)
    {
        _btn_skip.hidden=YES;
        [_btnContinue setTitle:@"I GOT IT" forState:UIControlStateNormal];
    }
    else
    {
        _btn_skip.hidden=NO;
        [_btnContinue setTitle:@"CONTINUE" forState:UIControlStateNormal];
    }
}

-(BOOL)prefersStatusBarHidden
{
    if(iPhoneVersion == 10)
        return NO;
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"viewDidDisappear");
    [[NSUserDefaults standardUserDefaults] setObject:@"Save" forKey:@"loginSaved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIButton Click Event
- (IBAction)didClickSkipButton:(id)sender
{
    ViewController *ps=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:ps animated:YES];
}

- (IBAction)didClickNextButton:(id)sender
{
    if (currentIndex==2)
    {
        [_btnContinue setTitle:@"I GOT IT" forState:UIControlStateNormal];
        NSLog(@"currentIndex %f",currentIndex);
        ViewController *ps=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        [self.navigationController pushViewController:ps animated:YES];
    }
    else
    {
        currentIndex++;
        if (currentIndex==2)
        {
             [_btnContinue setTitle:@"I GOT IT" forState:UIControlStateNormal];
            _btn_skip.hidden=YES;
        }
        else
        {
           [_btnContinue setTitle:@"CONTINUE" forState:UIControlStateNormal];
            _btn_skip.hidden=NO;
        }
        
        [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width*currentIndex, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
        _pageControl.currentPage=(int)currentIndex;
    }
}
@end
