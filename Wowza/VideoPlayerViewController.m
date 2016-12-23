//
//  VideoPlayerViewController.m
//  SDKSampleApp
//
//  This code and all components (c) Copyright 2015-2016, Wowza Media Systems, LLC. All rights reserved.
//  This code is licensed pursuant to the BSD 3-Clause License.
//


#import <WowzaGoCoderSDK/WowzaGoCoderSDK.h>

#import "VideoPlayerViewController.h"

#import "MP4Writer.h"


#pragma mark VideoPlayerViewController (GoCoder SDK Sample App) -

static NSString *const SDKSampleSavedConfigKey = @"SDKSampleSavedConfigKey";
static NSString *const SDKSampleAppLicenseKey = @"GOSK-FC42-0100-24F0-9707-DC6C";




@interface VideoPlayerViewController () <WZStatusCallback, WZVideoSink, WZAudioSink, WZVideoEncoderSink, WZAudioEncoderSink, WZDataSink>

#pragma mark - UI Elements
@property (nonatomic, strong) IBOutlet UIButton           *broadcastButton;
@property (nonatomic, strong) IBOutlet UIButton           *settingsButton;

@property (nonatomic, strong) IBOutlet UIButton           *CancelButton;
@property (nonatomic, strong) IBOutlet UIButton           *torchButton;
@property (nonatomic, strong) IBOutlet UIButton           *micButton;
@property (strong, nonatomic) IBOutlet UILabel            *timeLabel;

#pragma mark - GoCoder SDK Components
@property (nonatomic, strong) WowzaGoCoder      *goCoder;
@property (nonatomic, strong) WowzaConfig       *goCoderConfig;
@property (nonatomic, strong) WZCameraPreview   *goCoderCameraPreview;

#pragma mark - Data
@property (nonatomic, strong) NSMutableArray    *receivedGoCoderEventCodes;
@property (nonatomic, assign) BOOL              blackAndWhiteVideoEffect;
@property (nonatomic, assign) BOOL              recordVideoLocally;
@property (nonatomic, assign) CMTime            broadcastStartTime;

#pragma mark - MP4Writing
@property (nonatomic, strong) MP4Writer         *mp4Writer;
@property (nonatomic, assign) BOOL              writeMP4;
@property (nonatomic, strong) dispatch_queue_t  video_capture_queue;

#pragma mark - WZData injection
@property (nonatomic, assign) long long         broadcastFrameCount;

@end

#pragma mark -
@implementation VideoPlayerViewController

#pragma mark - UIViewController Protocol Instance Methods


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    

    self.broadcastStartTime = kCMTimeInvalid;
    self.timeLabel.hidden = YES;
    self.receivedGoCoderEventCodes = [NSMutableArray new];
    [WowzaGoCoder setLogLevel:WowzaGoCoderLogLevelVerbose];
    
       self.goCoderConfig = [[WowzaConfig alloc]initWithPreset:WZFrameSizePreset1280x720];
    
    self.goCoderConfig.broadcastScaleMode=WZBroadcastScaleModeAspectFill;
        self.goCoderConfig.hostAddress=@"ceflix1.srfms.com";
        self.goCoderConfig.portNumber=1935;
        self.goCoderConfig.applicationName=@"ceflix1";
        self.goCoderConfig.username=@"ngbadebo1";
        self.goCoderConfig.password=@"manutd5055";
    NSLog (@"WowzaGoCoderSDK version =\n major:%lu\n minor:%lu\n revision:%lu\n build:%lu\n short string: %@\n verbose string: %@",
           (unsigned long)[WZVersionInfo majorVersion],
           (unsigned long)[WZVersionInfo minorVersion],
           (unsigned long)[WZVersionInfo revision],
           (unsigned long)[WZVersionInfo buildNumber],
           [WZVersionInfo string],
           [WZVersionInfo verboseString]);
    
    NSLog (@"%@", [WZPlatformInfo string]);
    
    self.goCoder = nil;
    
    // Register the GoCoder SDK license key
    NSError *goCoderLicensingError = [WowzaGoCoder registerLicenseKey:SDKSampleAppLicenseKey];
    if (goCoderLicensingError != nil)
    {
        [self showAlertWithTitle:@"GoCoder SDK Licensing Error" error:goCoderLicensingError];
    }
    else {
        // Initialize the GoCoder SDK
       self.goCoder = [WowzaGoCoder sharedInstance];

        // Specify the view in which to display the camera preview
        if (self.goCoder != nil) {
            
            // Request camera and microphone permissions
            [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeCamera response:^(WowzaGoCoderCapturePermission permission) {
                NSLog(@"Camera permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
            }];
            
            [WowzaGoCoder requestPermissionForType:WowzaGoCoderPermissionTypeMicrophone response:^(WowzaGoCoderCapturePermission permission) {
                NSLog(@"Microphone permission is: %@", permission == WowzaGoCoderCapturePermissionAuthorized ? @"authorized" : @"denied");
            }];
            
            [self.goCoder registerVideoSink:self];
            [self.goCoder registerAudioSink:self];
            [self.goCoder registerVideoEncoderSink:self];
            [self.goCoder registerAudioEncoderSink:self];
            
            [self.goCoder registerDataSink:self eventName:@"onTextData"];
            
            self.goCoder.config = self.goCoderConfig;
            self.goCoder.cameraView = self.view;
            
            // Start the camera preview
            self.goCoderCameraPreview = self.goCoder.cameraPreview;
         [self.goCoderCameraPreview startPreview];
        }

        // Update the UI controls
        [self updateUIControls];
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidekeyboard)];
    [tap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:tap];
    
    NSArray *nib= [[NSBundle mainBundle]loadNibNamed:@"CommentView" owner:self options:nil];
    
   cview=[nib objectAtIndex:0];
    
    eventid=@"";
    privacy=@"1";
    startbroadcastlbl.hidden=YES;
    livenowimg.hidden=YES;
    optionBtn.hidden=YES;
    
    
    NSData *savedConfigData = [NSKeyedArchiver archivedDataWithRootObject:self.goCoderConfig];
    [[NSUserDefaults standardUserDefaults] setObject:savedConfigData forKey:SDKSampleSavedConfigKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.goCoder.cameraPreview.previewLayer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    // Update the configuration settings in the GoCoder SDK
    if (self.goCoder != nil)
        self.goCoder.config = self.goCoderConfig;
    
    
//    cview.frame=CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
//    cview.controller=self;
//    cview.videoId=@"evt20eec1f05";
//    [cview getcomments:@"evt20eec1f05"];
//    [self.view addSubview:cview];
    
}
-(void)hidekeyboard
{
    [self.view endEditing:YES];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.bottomConstraint.constant =keyboardSize.height;
    cview.bottomConstraint.constant=keyboardSize.height;
    [self.view layoutIfNeeded];
}
- (void)keyboardWillHide:(NSNotification *)notification
{   cview.bottomConstraint.constant=0;
    self.bottomConstraint.constant = 0;
    [self.view layoutIfNeeded];
}
- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Action Methods
- (IBAction) didTapCancel:(id)sender
{
    [self.goCoder unregisterVideoSink:self];
    [self.goCoder unregisterAudioSink:self];
    [self.goCoder unregisterVideoEncoderSink:self];
    [self.goCoder unregisterAudioEncoderSink:self];
    
    [self.goCoder unregisterDataSink:self eventName:@"onTextData"];
    [self.goCoderCameraPreview stopPreview];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) didTapBroadcastButton:(id)sender {

    NSString *str=[streamnametext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([str isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Please enter a description of the event." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
            
        }];
        [alert addAction:okay];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    
    }
    
    [streamnametext resignFirstResponder];
    self.broadcastButton.hidden   = YES;
    self.CancelButton.hidden    = YES;
    startbroadcastlbl.hidden=NO;
    linelbl.hidden=YES;
    streamnametext.hidden=YES;
    privacylbl.hidden=YES;
    globeicon.hidden=YES;
    switchcamerabtn.hidden=YES;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict=@{@"encID":[defaults valueForKey:@"UserIdentifier"],@"token":[defaults valueForKey:@"CurrentUserToken"],@"eventDesc":streamnametext.text,@"isPublic":privacy};
    
    [[CFCeflixService sharedInstance]webservicescall:dict action:@"angles/create" block:^(NSData *data, NSError *error)
     {
             if (error)
             {
                 optionBtn.hidden=YES;
                 self.broadcastButton.hidden   = NO;
                 self.CancelButton.hidden    = NO;
                 startbroadcastlbl.hidden=YES;
                 linelbl.hidden=NO;
                 streamnametext.hidden=NO;
                 privacylbl.hidden=NO;
                 globeicon.hidden=NO;
                 switchcamerabtn.hidden=NO;
                 footerview.hidden=NO;
                 streamnametext.text=@""; [globeicon setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
                 privacylbl.text=@"Public";
                 privacy=@"1";
                 if (error.code==NSURLErrorNotConnectedToInternet)
                 {
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please check your connection and try again." preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *okay =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         
                     }];
                     [alert addAction:okay];
                     [self presentViewController:alert animated:YES completion:nil];
                 }
                 else
                 {
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:@"Can't connect to Ceflix right now." preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         
                     }];
                     [alert addAction:okay];
                     [self presentViewController:alert animated:YES completion:nil];
                 }
             }
             else
             {
                 NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                 if ([[dict valueForKey:@"status"]integerValue]==1)
                 {
                     shareurl=[dict valueForKey:@"shareLink"];
                     
                maxduration=[[dict valueForKey:@"duration"]integerValue];
                     
                     NSInteger forHours =    maxduration / 3600;
                     NSInteger  remainder =  maxduration % 3600;
                     NSInteger forMinutes =  remainder / 60;
                     NSInteger  forSeconds = remainder % 60;
                     
                     NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",forHours ,forMinutes, forSeconds];
                     
                     self.timeLabel.text=timeString;
                     
                     self.goCoderConfig.streamName=[NSString stringWithFormat:@"%@",[dict valueForKey:@"streamName"]];
                     self.goCoder.config.streamName=[NSString stringWithFormat:@"%@",[dict valueForKey:@"streamName"]];
                     
                     eventid=[dict valueForKey:@"eventID"];
                     
                     [self performSelector:@selector(sendthumnail) withObject:nil afterDelay:0.2];
                     [self startstream];
                     
                   
                   
                     
                
                 }
                 else
                 {
                     streamnametext.text=@""; [globeicon setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
                     privacylbl.text=@"Public";
                     privacy=@"1";
                     optionBtn.hidden=YES;
                     self.broadcastButton.hidden   = NO;
                     self.CancelButton.hidden    = NO;
                     startbroadcastlbl.hidden=YES;
                     linelbl.hidden=NO;
                     streamnametext.hidden=NO;
                     privacylbl.hidden=NO;
                     globeicon.hidden=NO;
                     switchcamerabtn.hidden=NO;
                     footerview.hidden=NO;
                     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:@"Can't connect to Ceflix right now." preferredStyle:UIAlertControllerStyleAlert];
                     UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                         
                     }];
                     [alert addAction:okay];
                     [self presentViewController:alert animated:YES completion:nil];
                 }
             }
     }];
    
    
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef ref = [context createCGImage:thumbimage fromRect:thumbimage.extent];
//    UIImage *image=[UIImage imageWithCGImage:ref];
//     NSData *daa=UIImageJPEGRepresentation(image, 0.5);
//    image=[UIImage imageWithData:daa];
//    
//    [self multipart:image requestDictionary:dict];
}
-(void)sendthumnail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dict=@{@"encID":[defaults valueForKey:@"UserIdentifier"],@"token":[defaults valueForKey:@"CurrentUserToken"],@"eventID":eventid};
    
    [self multipart:thumbimage requestDictionary:dict];

}
-(void)multipart:(UIImage *)image requestDictionary:(NSDictionary*)requestDictionary
{
    NSString *path=@"http://apix3x9.ceflix.org/angles/updatethumbnail";
    NSString *escapedPath = [path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:escapedPath];

  
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", @"boundry"];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in requestDictionary)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", @"boundry"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [requestDictionary objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    // add image data
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", @"boundry"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"myimage.png\"\r\n", @"thumbnail"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", @"boundry"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    // set URL
    [request setURL:url];
    
    NSURLSessionDataTask *data1=[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                 {
                    
                                   
                                     
                                     }];
    
    [data1 resume];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)startstream
{
    NSError *configError = [self.goCoder.config validateForBroadcast];
    if (configError != nil) {
        [self showAlertWithTitle:@"Incomplete Streaming Settings" error:configError];
        return;
    }
    [self.receivedGoCoderEventCodes removeAllObjects];
    [self.goCoder startStreaming:self];
}
- (IBAction)didTapOptionButton:(id)sender
{
    alertcontroller=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *switchcamera=[UIAlertAction actionWithTitle:@"Switch Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        [self didTapSwitchCameraButton:nil];
    }];
    [switchcamera setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [switchcamera setValue:[[UIImage imageNamed:@"ic_switch-cam"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    UIAlertAction *readComments=[UIAlertAction actionWithTitle:@"Read Comments" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        cview.frame=CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        cview.controller=self;
        cview.videoId=eventid;
        [cview getcomments:eventid];
        [self.view addSubview:cview];
    }];
    [readComments setValue:[[UIImage imageNamed:@"ic_read-comments"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [readComments setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    UIAlertAction *shareVideo=[UIAlertAction actionWithTitle:@"Share Video" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self sharelink];
        
    }];
    [shareVideo setValue:[[UIImage imageNamed:@"ic_share-video"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [shareVideo setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    UIAlertAction *hidecomments=[UIAlertAction actionWithTitle:@"Hide Comments" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    
    [hidecomments setValue:[[UIImage imageNamed:@"ic_hide-comments"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forKey:@"image"];
    [hidecomments setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    UIAlertAction *cancelbtn=[UIAlertAction actionWithTitle:@"Stop BroadCast" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
    {
    }];
    

    [alertcontroller addAction:switchcamera];
    [alertcontroller addAction:readComments];
    [alertcontroller addAction:shareVideo];
    [alertcontroller addAction:hidecomments];
    [alertcontroller addAction:cancelbtn];
    
    CGFloat margin = 8.0F;
    
    NSLog(@"%f",alertcontroller.view.frame.origin.y);

    UIButton *stopbroadcast=[[UIButton alloc]init];
    [stopbroadcast setTitle:@"Stop BroadCast" forState:UIControlStateNormal];
    [stopbroadcast setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [stopbroadcast addTarget:self action:@selector(stopbroadcaststream:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 57.5*4+6, alertcontroller.view.bounds.size.width - margin * 2.5F, 59.0F)];
    
    stopbroadcast.frame=CGRectMake(0, 0, customView.frame.size.width, 59);
    
    [stopbroadcast.titleLabel setTextAlignment: NSTextAlignmentCenter];
    
    customView.layer.cornerRadius=7.0;
    customView.layer.masksToBounds=YES;
    customView.backgroundColor = [UIColor redColor];
    [customView addSubview:stopbroadcast];
   [alertcontroller.view addSubview:customView];
    
    
[self presentViewController:alertcontroller animated:YES completion:nil];
    
}
-(void)sharelink
{
    
    
    NSArray* dataToShare = @[shareurl];
    UIActivityViewController* activityViewController =[[UIActivityViewController alloc] initWithActivityItems:dataToShare applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAirDrop];
    [self presentViewController:activityViewController animated:YES completion:^{}];
    

}
-(void)stopbroadcaststream:(id)sender
{
    [alertcontroller dismissViewControllerAnimated:YES completion:nil];
    self.timeLabel.hidden = YES;
    streamnametext.text=@""; [globeicon setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
    privacylbl.text=@"Public";
    privacy=@"1";
    if (self.goCoder.status.state == WZStateRunning)
    {
        [self.goCoder endStreaming:self];
    }
   
}

-(IBAction)privacyaction:(UIButton*)btn
{

    if ([btn.imageView.image isEqual:[UIImage imageNamed:@"globe"]])
    {
    [btn setImage:[UIImage imageNamed:@"redglobe"] forState:UIControlStateNormal];
        privacylbl.text=@"Private";
        privacy=@"0";
    }
    else
    {
    [btn setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
        privacylbl.text=@"Public";
        privacy=@"1";
    }
    
    
    
    
}
- (IBAction) didTapSwitchCameraButton:(id)sender {
    WZCamera *otherCamera = [self.goCoderCameraPreview otherCamera];
    if (![otherCamera supportsWidth:self.goCoderConfig.videoWidth]) {
        [self.goCoderConfig loadPreset:otherCamera.supportedPresetConfigs.lastObject.toPreset];
        self.goCoder.config = self.goCoderConfig;
    }
    [self.goCoderCameraPreview switchCamera];

    [self updateUIControls];
}

- (IBAction) didTapTorchButton:(id)sender {
    BOOL newTorchOnState = !self.goCoderCameraPreview.camera.torchOn;
    
    self.goCoderCameraPreview.camera.torchOn = newTorchOnState;
    [self.torchButton setImage:[UIImage imageNamed:(newTorchOnState ? @"torch_off_button" : @"torch_on_button")] forState:UIControlStateNormal];
}

- (IBAction) didTapMicButton:(id)sender {
    BOOL newMutedState = !self.goCoder.isAudioMuted;
    
    self.goCoder.audioMuted = newMutedState;
    [self.micButton setImage:[UIImage imageNamed:(newMutedState ? @"mic_off_button" : @"mic_on_button")] forState:UIControlStateNormal];
}




#pragma mark - Instance Methods

// Update the state of the UI controls
- (void) updateUIControls {

    if (self.goCoder.status.state==WZStateStopping)
    {
         [self stopstream];
        [cview cancel:nil];
        eventid=@"";
        [globeicon setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
        privacylbl.text=@"Public";
        privacy=@"1";
        optionBtn.hidden=YES;
        self.broadcastButton.hidden   = NO;
        self.CancelButton.hidden    = NO;
        startbroadcastlbl.hidden=YES;
        linelbl.hidden=NO;
        streamnametext.hidden=NO;
        privacylbl.hidden=NO;
        globeicon.hidden=NO;
        switchcamerabtn.hidden=NO;
        footerview.hidden=NO;
        self.timeLabel.hidden=YES;
        
    }
    else if (self.goCoder.status.state==WZStateRunning)
    {
        optionBtn.hidden=NO;
        self.broadcastButton.hidden   = YES;
        self.CancelButton.hidden    = YES;
        startbroadcastlbl.hidden=YES;
        linelbl.hidden=YES;
        streamnametext.hidden=YES;
        privacylbl.hidden=YES;
        globeicon.hidden=YES;
        switchcamerabtn.hidden=YES;
     footerview.hidden=YES;
        livenowimg.hidden=NO;
        [self performSelector:@selector(removeimage) withObject:nil afterDelay:2];
        
    }
}
-(void)removeimage
{
     livenowimg.hidden=YES;
}
-(void)stopstream
{

    NSDictionary *dict=@{@"eventID":eventid};
    
    [[CFCeflixService sharedInstance]webservicescall:dict action:@"angles/stopstream" block:^(NSData *data, NSError *error)
   
     {
        
        NSString *string=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"%@ %@",dict,string);
    }];
}

#pragma mark - WZStatusCallback Protocol Instance Methods

- (void) onWZStatus:(WZStatus *) goCoderStatus {
    // A successful status transition has been reported by the GoCoder SDK
    
    switch (goCoderStatus.state) {

        case WZStateIdle:
            self.timeLabel.hidden = YES;
            if (self.writeMP4 && self.mp4Writer.writing) {
                if (self.video_capture_queue) {
                    dispatch_async(self.video_capture_queue, ^{
                        [self.mp4Writer stopWriting];
                    });
                }
                else {
                    [self.mp4Writer stopWriting];
                }
            }
            self.writeMP4 = NO;
            break;
        case WZStateStarting:
        {
            self.broadcastStartTime = kCMTimeInvalid;
         //   self.timeLabel.text = @"00:00";
            self.broadcastFrameCount = 0;
            break;
        }
        case WZStateRunning:
            // A streaming broadcast session is running
            self.timeLabel.hidden = NO;
            self.writeMP4 = NO;
            if (self.recordVideoLocally) {
                self.mp4Writer = [MP4Writer new];
                self.writeMP4 = [self.mp4Writer prepareWithConfig:self.goCoderConfig];
                if (self.writeMP4) {
                    [self.mp4Writer startWriting];
                }
            }
            break;

        case WZStateStopping:
        {
            self.timeLabel.hidden = YES;
            break;
        }
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
         if(self.goCoder.status.state == WZStateStarting)
        {
                [streamnametext resignFirstResponder];
                self.broadcastButton.hidden   = YES;
                self.CancelButton.hidden    = YES;
                startbroadcastlbl.hidden=NO;
                linelbl.hidden=YES;
                streamnametext.hidden=YES;
            privacylbl.hidden=YES;
            globeicon.hidden=YES;
            switchcamerabtn.hidden=YES;
        
        }
        
        [self updateUIControls];
    });
}

- (void) onWZEvent:(WZStatus *) goCoderStatus {
    // If an event is reported by the GoCoder SDK, display an alert dialog describing the event,
    // but only if we haven't already shown an alert for this event
    
    dispatch_async(dispatch_get_main_queue(), ^{
        __block BOOL haveSeenAlertForEvent = NO;
        [self.receivedGoCoderEventCodes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([((NSNumber *)obj) isEqualToNumber:[NSNumber numberWithInteger:goCoderStatus.error.code]]) {
                haveSeenAlertForEvent = YES;
                *stop = YES;
            }
        }];
        if (!haveSeenAlertForEvent) {
            [self showAlertWithTitle:@"Live Streaming Event" status:goCoderStatus];
            [self.receivedGoCoderEventCodes addObject:[NSNumber numberWithInteger:goCoderStatus.error.code]];
        }
        
        [self updateUIControls];
    });
}

- (void) onWZError:(WZStatus *) goCoderStatus {
    // If an error is reported by the GoCoder SDK, display an alert dialog containing the error details
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [self showAlertWithTitle:@"Live Streaming Error" status:goCoderStatus];
        streamnametext.text=@"";
        [globeicon setImage:[UIImage imageNamed:@"globe"] forState:UIControlStateNormal];
        privacylbl.text=@"Public";
        privacy=@"1";
        eventid=@"";
        optionBtn.hidden=YES;
        self.broadcastButton.hidden =NO;
        self.CancelButton.hidden =NO;
        startbroadcastlbl.hidden =YES;
        linelbl.hidden=NO;
        streamnametext.hidden=NO;
        privacylbl.hidden=NO;
        globeicon.hidden=NO;
        switchcamerabtn.hidden=NO;
        footerview.hidden=NO;
        [self updateUIControls];
    });
}

#pragma mark - WZVideoSink

#warning Don't implement this protocol unless your application makes use of it
- (void) videoFrameWasCaptured:(nonnull CVImageBufferRef)imageBuffer framePresentationTime:(CMTime)framePresentationTime frameDuration:(CMTime)frameDuration {
   
        
//    UIImage *img=[WZImageUtilities imageFromCVPixelBuffer:imageBuffer destinationImageSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 363)];

    
    CIImage *frame = [CIImage imageWithCVImageBuffer:imageBuffer];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:frame fromRect:[frame extent]];
    
    UIImage* uiImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
        dispatch_async(dispatch_get_main_queue(), ^{
          thumbimage=uiImage;
              });
}

- (void) videoCaptureInterruptionStarted {
    if (!self.goCoderConfig.backgroundBroadcastEnabled) {
        [self.goCoder endStreaming:self];
    }
}

- (void) videoCaptureUsingQueue:(nullable dispatch_queue_t)queue {
    self.video_capture_queue = queue;
}

#pragma mark - WZAudioSink

#warning Don't implement this protocol unless your application makes use of it
- (void) audioLevelDidChange:(float)level {
//    NSLog(@"%@ %0.2f", @"Audio level did change", level);
}

#warning Don't implement this protocol unless your application makes use of it
- (void) audioPCMFrameWasCaptured:(nonnull const AudioStreamBasicDescription *)pcmASBD bufferList:(nonnull const AudioBufferList *)bufferList time:(CMTime)time sampleRate:(Float64)sampleRate {
    // The commented-out code below simply dampens the amplitude of the audio data.
    // It is intended as an example of how one would access and modify the audio sample data.

//    int16_t *fdata = bufferList->mBuffers[0].mData;
//    
//    for (int i = 0; i < bufferList->mBuffers[0].mDataByteSize/sizeof(*fdata); i++) {
//        *fdata = (int16_t)(*fdata * 0.1);
//        fdata++;
//    }
}


#pragma mark - WZAudioEncoderSink

#warning Don't implement this protocol unless your application makes use of it
- (void) audioSampleWasEncoded:(nullable CMSampleBufferRef)data {
    if (self.writeMP4) {
        [self.mp4Writer appendAudioSample:data];
    }
}


#pragma mark - WZVideoEncoderSink

#warning Don't implement this protocol unless your application makes use of it
- (void) videoFrameWasEncoded:(nonnull CMSampleBufferRef)data {
    
    // update the broadcast time label
    if (CMTimeCompare(self.broadcastStartTime, kCMTimeInvalid) == 0) {
        self.broadcastStartTime = CMSampleBufferGetPresentationTimeStamp(data);
    }
    else {
        CMTime diff = CMTimeSubtract(CMSampleBufferGetPresentationTimeStamp(data), self.broadcastStartTime);
        Float64 seconds = CMTimeGetSeconds(diff);
        NSInteger duration = (NSInteger)seconds;
        
        

        duration=maxduration-duration;
        
        NSInteger forHours = duration / 3600;
        NSInteger  remainder = duration % 3600;
        NSInteger forMinutes = remainder / 60;
        NSInteger  forSeconds = remainder % 60;
        
        NSString *timeString = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",forHours ,forMinutes, forSeconds];
        
        
      
        
        dispatch_async(dispatch_get_main_queue(), ^
        {
            self.timeLabel.text = timeString;
            
            if (duration==0)
            {
                [cview cancel:nil];
                [self stopbroadcaststream:nil];
            
                return;
            }
            NSInteger checktime = (NSInteger)seconds;
        
        });
        
    }
    
    if (self.writeMP4) {
        [self.mp4Writer appendVideoSample:data];
    }
    
    if (self.broadcastFrameCount++ % 60 == 0) {
        NSString *string = [NSString stringWithFormat:@"My string data at frame %lld", self.broadcastFrameCount];
        WZDataItem *myStringData = [WZDataItem itemWithString:string];
        WZDataMap *dataMap = [WZDataMap new];
        [dataMap setItem:myStringData forKey:@"textData"];
        
        NSLog(@"%@", string);
        
        WZDataEvent *event = [[WZDataEvent alloc] initWithName:@"onTextData" mapParams:dataMap];
        
        [self.goCoder sendDataEvent:event];
    }
}

#pragma mark - WZDataSink

- (void) onData:(WZDataEvent *)dataEvent {
    NSLog(@"Got data - %@", dataEvent.description);
}

#pragma mark -

- (void) showAlertWithTitle:(NSString *)title status:(WZStatus *)status {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:title
                                                          message:status.description
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alertDialog show];
}

- (void) showAlertWithTitle:(NSString *)title error:(NSError *)error {
    UIAlertView *alertDialog = [[UIAlertView alloc] initWithTitle:title
                                                          message:error.localizedDescription
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
    [alertDialog show];
}




@end





