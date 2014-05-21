//
//  SubmitVC.m
//  Onesie
//
//  Created by Laurent Rivard on 5/21/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "SubmitVC.h"
#import <Parse/Parse.h>
#import "SWRevealViewController.h"

#define MAX_TITLE_LENGTH 33
#define MAX_BODY_LENGTH 2500
#define VIEW_TRANSLATION 250

@interface SubmitVC ()
@property (strong, nonatomic) UIBarButtonItem *menuBtn;

@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (strong, nonatomic) UIImage *pickedImg;
@property (strong, nonatomic) UILabel *charCount;
@end

@implementation SubmitVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _menuBtn = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.navigationItem.leftBarButtonItem = _menuBtn;
    //setting up drawer menu
    _menuBtn.target = self.revealViewController;
    _menuBtn.action = @selector(revealToggle:);
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    _titleTextView.delegate = self;
    _bodyTextView.delegate = self;
    
    
    UITapGestureRecognizer *imgDoubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadImagePicker)];
    imgDoubleTap.numberOfTapsRequired = 2;
    [_imageView addGestureRecognizer:imgDoubleTap];
    
    UITapGestureRecognizer *imgSingleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    imgSingleTap.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:imgSingleTap];

    
}
-(void) loadImagePicker {
    NSLog(@"double tap clicked");
    if(!_imgPicker) {
        _imgPicker = [[UIImagePickerController alloc] init];
        _imgPicker.delegate = self;
        _imgPicker.mediaTypes = @[(NSString *) kUTTypeImage];
        _imgPicker.allowsEditing = NO;
    }
    
    UIActionSheet *imgAction = [[UIActionSheet alloc] initWithTitle:@"Image" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Choose from Library",@"Take Picture", nil];
    imgAction.tag = 101;
    [imgAction showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet.tag == 101) {
        switch (buttonIndex) {
            case 0:
                _imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:_imgPicker animated:YES completion:nil];
                break;
            case 1:
                _imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:_imgPicker animated:YES completion:nil];
                break;
            default:
                break;
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    _pickedImg = [[UIImage alloc] init];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        _pickedImg = info[UIImagePickerControllerOriginalImage];
    }
    [self dismissViewControllerAnimated:YES completion:^() {
        _imageView.image = _pickedImg;
        [_placeholderLabel setHidden:YES];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"picker canceled");
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)cancelBtnPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)postBtnPressed:(id)sender {
    //check to see there's an image and text/title
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setDateFormat:@"dd MMM"];
    
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSLog(@"date: %@", date);
    PFObject *submission = [PFObject objectWithClassName:@"Submissions"];
    submission[@"body"] = _bodyTextView.text;
    submission[@"title"] = _titleTextView.text;
    submission[@"date"] = date;
    NSData *imageData = UIImageJPEGRepresentation(_imageView.image, 1);
    NSString *imageName = [NSString stringWithFormat:@"%@_%@",@"hello",@"bye"];
    PFFile *imageFile = [PFFile fileWithName:imageName data:imageData];
    submission[@"image"] = imageFile;
    
    [submission saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
            NSLog(@"save successful!");
        else
            NSLog(@"error: %@", [error localizedDescription]);
    }];
    
}

#pragma mark UITEXTVIEW delegate functions
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.tag == 1) {
        if([[textView text] length] > MAX_TITLE_LENGTH -1)
            return NO;
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    int len = textView.text.length;
    //for title text view
    if(textView.tag == 1) {
        _charCount.text = [NSString stringWithFormat:@"%d characters left", (MAX_TITLE_LENGTH -len)];
        if(MAX_TITLE_LENGTH - len < 5)
            _charCount.textColor = [UIColor redColor];
        else
            _charCount.textColor = [UIColor blackColor];
        
        NSUInteger maxNumberOfLines = 1;
        NSUInteger numLines = textView.contentSize.height/textView.font.lineHeight;
        if (numLines > maxNumberOfLines)
        {
            textView.text = [textView.text substringToIndex:textView.text.length - 1];
        }
    }
    //for body text view
    else if(textView.tag == 2) {
        _charCount.text = [NSString stringWithFormat:@"%d characters left", (MAX_BODY_LENGTH -len)];
        if(MAX_BODY_LENGTH - len < 25)
            _charCount.textColor = [UIColor redColor];
        else
            _charCount.textColor = [UIColor blackColor];
    }

}

-(BOOL)textViewShouldBeginEditing: (UITextView *)textView
{
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    keyboardToolBar.barStyle = UIBarStyleDefault;

    UILabel *tmpChar;
    tmpChar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    _charCount = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    UIBarButtonItem *countBtn = [[UIBarButtonItem alloc] initWithCustomView:_charCount];
    UIBarButtonItem *dismissBtn = [[UIBarButtonItem alloc]initWithTitle:@"Dismiss" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    UIBarButtonItem *characterLabel;
    int len = textView.text.length;

    if(textView.tag == 1) {
        if([textView.text isEqualToString: @"Enter Title"]) {
            textView.text = @"";
        }
        
        tmpChar.text = @"characters left";
        _charCount.text = [NSString stringWithFormat:@"%d characters left", MAX_TITLE_LENGTH - len];
        characterLabel = [[UIBarButtonItem alloc] initWithCustomView:tmpChar];
        dismissBtn.tag = 10;
    }
    else if(textView.tag == 2) {
        if([textView.text isEqualToString: @"Enter Description"]) {
            textView.text = @"";
        }
        //move view up
        [UIView animateWithDuration:0.2 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = -VIEW_TRANSLATION;
            self.view.frame = f;
        }];
        tmpChar.text = @"words left";
        _charCount.text = [NSString stringWithFormat:@"%d characters left", MAX_BODY_LENGTH - len];

        characterLabel = [[UIBarButtonItem alloc] initWithCustomView:tmpChar];
        dismissBtn.tag = 11;

    }
    [keyboardToolBar setItems: [NSArray arrayWithObjects:countBtn,
                                dismissBtn,
                                nil]];
    

    textView.inputAccessoryView = keyboardToolBar;
    return YES;
}
-(void) resignKeyboard {
    [_titleTextView resignFirstResponder];
    [_bodyTextView resignFirstResponder];
    if(self.view.frame.origin.y != 0) {
        NSLog(@"not equal!");
        [UIView animateWithDuration:0.1 animations:^{
            CGRect f = self.view.frame;
            f.origin.y = 0;
            self.view.frame = f;
        }];
    }
}



@end
