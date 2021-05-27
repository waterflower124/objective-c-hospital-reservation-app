//
//  OrderMedicine.m
//  Hospital
//
//  Created by Kiran Padhiyar on 27/01/18.
//  Copyright © 2018 Redixbit. All rights reserved.
//

#import "OrderMedicine.h"
#import "Constants.h"
#import "AppDelegate.h"
@interface OrderMedicine ()
{
      AppDelegate *app;
    NSString *language;
}
@end

@implementation OrderMedicine

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    language=[[NSUserDefaults standardUserDefaults] stringForKey:DEFAULTS_KEY_LANGUAGE_CODE];
    language=[language substringToIndex:character];
    if ([language isEqualToString:country]) {
        NSLog(@"CheRtl2");
        imgBack.image = [imgBack.image imageFlippedForRightToLeftLayoutDirection];
        imgMobile.image = [imgMobile.image imageFlippedForRightToLeftLayoutDirection];
        imgDesc.image = [imgDesc.image imageFlippedForRightToLeftLayoutDirection];
        txt_mobile.textAlignment = UITextAlignmentRight;
         txt_desc.textAlignment = UITextAlignmentRight;
    }
    [_scrollView setContentSize:CGSizeMake(_scrollView.frame.size.width, orderMedicine_btn.frame.origin.y+orderMedicine_btn.frame.size.height)];
    app=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"]);
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"mail"]);
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Profile"];
    UIImage* image = [UIImage imageWithData:imageData];
    profile_imageview.layer.cornerRadius=profile_imageview.frame.size.height/2;
        profile_imageview.clipsToBounds=YES;
    
    name_lbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"];
    mail_lbl.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"Mail"];
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"User_id"]length]>0)
    {
        [profile_imageview setBackgroundImage:image forState:UIControlStateNormal];
    }
    else
    {
        [profile_imageview setBackgroundImage:[UIImage imageNamed:@"default_round.png"] forState:UIControlStateNormal];
    }
    lbl_Note.text = NSLocalizedString(@"lblNote1", @"");
    lbl_note1.text = NSLocalizedString(@"lbl_note11", @"");
    lbl_note2.text = NSLocalizedString(@"lbl_note22", @"");
    lbl_note3.text = NSLocalizedString(@"lbl_note33", @"");

    lbl_Note.font = [UIFont fontWithName:releway size:lbl_Note.font.pointSize];
    lbl_note1.font = [UIFont fontWithName:releway size:lbl_note1.font.pointSize];
    lbl_note2.font = [UIFont fontWithName:releway size:lbl_note2.font.pointSize];
    lbl_note3.font = [UIFont fontWithName:releway size:lbl_note3.font.pointSize];
    
    lbl_1.font = [UIFont fontWithName:releway size:lbl_1.font.pointSize];
    lbl_2.font = [UIFont fontWithName:releway size:lbl_2.font.pointSize];
    lbl_3.font = [UIFont fontWithName:releway size:lbl_3.font.pointSize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Textfield Delegate Method
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(self.view.frame.origin.y==0)
    {
//        [self up_view];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self down_view];
    [textField resignFirstResponder];
    
    return YES;
}
#pragma mark Textview DElegate Method
-(void)textViewDidBeginEditing:(UITextView *)textView
{
        
    textView.text=nil;
    if(self.view.frame.origin.y==0)
    {
//        [self up_view];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
//        [self down_view];
        if(textView.text.length==0)
        {
            textView.text=@"Description";
        }
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(BOOL)prefersStatusBarHidden
{
    if(iPhoneVersion == 10)
        return NO;
    return YES;
}
#pragma mark UIButton ClickEvent
-(IBAction)Btn_back:(id)sender
{
    NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
    if (_AlreadyLogin)
    {
        [navigationArray removeObjectAtIndex: navigationArray.count- (2)];  // You can pass your index here
        self.navigationController.viewControllers = navigationArray;
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)didClickOrderMedicine:(id)sender {
    if (_select_Image.image != nil)
    {
        
        if (txt_mobile.text.length>0)
        {
            if (![txt_desc.text isEqualToString:@"Description"])
            {
                
                [self send_mail];
            }
            else
            {
                   [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"descAlere", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
            }
        }
        else
        {
           [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"mobileAlert", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
        }
    }
    else
    {
         [app Show_Alert:NSLocalizedString(@"LoginAlert_title", @"") SubTitle:NSLocalizedString(@"imageAlert", @"") CloseTitle:NSLocalizedString(@"LoginAlert_closetitle", @"")];
    }
    
}
#pragma mark Set Image Method
-(IBAction)Btn_Gallry:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
    
}
-(IBAction)Btn_Camera:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    _select_Image.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
//    _select_Image.hidden=YES;
   
}
-(void)send_mail
{
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    [mailComposer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail])
    {
 
        NSString *strNote=[NSString stringWithFormat:@"Hello, Here i am ordering medicine, prescription is attached below."];
        NSString *strName=[NSString stringWithFormat:@"Name: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Name"]];
        NSString *strMail=[NSString stringWithFormat:@"Mail id: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"Mail"]];
        NSString *strContact=[NSString stringWithFormat:@"Contact no: %@",txt_mobile.text];
        NSString *strDesc=[NSString stringWithFormat:@"Description: %@",txt_desc.text];
        
        NSString *htmlMsg = [NSString stringWithFormat:@"<html><body><p>%@</p><p>%@</p><p>%@</p><p>%@</p><p>%@</p></body></html>",strNote,strName,strMail,strContact,strDesc];
        
        NSData *jpegData = UIImageJPEGRepresentation(_select_Image.image, 1.0);
        
        NSString *fileName = @"test";
        fileName = [fileName stringByAppendingPathExtension:@"jpeg"];
        [mailComposer addAttachmentData:jpegData mimeType:@"image/jpeg" fileName:fileName];
        
        [mailComposer setSubject:@"email subject"];
        [mailComposer setMessageBody:htmlMsg isHTML:YES];
        [mailComposer setToRecipients:@[_EmailId]];
   
        [self presentViewController:mailComposer animated:YES completion:nil];
    }
    //    [self presentModalViewController:mailComposer animated:YES];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Extra Method
-(void)up_view
{
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.frame=CGRectMake(self.view.frame.origin.x, -215, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished)
     {}];
}
-(void)down_view
{
    [UIView animateWithDuration:.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.view.frame=CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished)
     {     }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
