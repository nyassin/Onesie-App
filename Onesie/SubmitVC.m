//
//  SubmitVC.m
//  Onesie
//
//  Created by Laurent Rivard on 5/21/14.
//  Copyright (c) 2014 Nuseir Yassin. All rights reserved.
//

#import "SubmitVC.h"
#define MAX_TITLE_LENGTH 33
@interface SubmitVC ()
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
    
    _titleTextView.delegate = self;
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
    
}

#pragma mark UITEXTVIEW delegate functions
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    if([text length] == 0)
//    {
//        if([textView.text length] != 0)
//        {
//            return YES;
//        }
//    }
//    else if([[textView text] length] > 139)
//    {
//        return NO;
//    }
//    return YES;
    
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
    }
    //for body text view
    else if(textView.tag == 2) {
        
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
    if(textView.tag == 1) {
        if([textView.text isEqualToString: @"Enter Title"]) {
            textView.text = @"";
        }
        
        tmpChar.text = @"characters left";
        int len = textView.text.length;
        _charCount.text = [NSString stringWithFormat:@"%d characters left", MAX_TITLE_LENGTH - len];
        characterLabel = [[UIBarButtonItem alloc] initWithCustomView:tmpChar];
        dismissBtn.tag = 10;
    }
    else if(textView.tag == 2) {
        tmpChar.text = @"words left";
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
}
@end
