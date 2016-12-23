//
//  CFUploadVideoViewController.m
//  Ceflix
//
//  Created by Tobi Omotayo on 23/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CFUploadVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
#import "CFVideo.h"
#import "CFConnectVideoUpload.h"

@interface CFUploadVideoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic,strong) AVAssetImageGenerator *imageGenerator;

@end

@implementation CFUploadVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // [self.descriptionField addTarget:self action:@selector(checkStateForUpload) forControlEvents:UIControlEventAllEditingEvents];
}

- (void)dealloc {
    
}


#pragma mark - Private Helpers

- (void)checkStateForUpload {
    if (self.descriptionField.text.length > 1 && self.videoURL && self.thumbnailView.image) {
        self.doneButton.enabled = YES;
    }
    else {
        self.doneButton.enabled = NO;
    }
}

- (void)disableControls {
    self.doneButton.enabled = NO;
    // self.descriptionField.enabled = NO;
    [self.descriptionField resignFirstResponder];
}

- (void)enableControls {
    self.doneButton.enabled = YES;
    // self.descriptionField.enabled = YES;
    
}

#pragma mark - Actions 

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)didTapDone:(id)sender {
    
    CFVideo *video = [[CFVideo alloc] initWithCaption:self.descriptionField.text];
    
    CFConnectVideoUpload *uploadVideo = [[CFConnectVideoUpload alloc]
                                         initWithVideo:video
                                         localVideoURL:self.videoURL
                                         thumbnailImage:self.thumbnailView.image];
    
    [self.delegate uploadVideoController:self requestsUploadFor:uploadVideo];
}

- (IBAction)didTapLibraryButton:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    imagePicker.allowsEditing = YES;
    imagePicker.videoMaximumDuration = 60;
    // TODO: it might be necessary to set some video quality here
    // imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (IBAction)didTapRecordButton:(id)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    imagePicker.allowsEditing = YES;
    imagePicker.videoMaximumDuration = 60;
    // TODO: it might be necessary to set some video quality here
    // imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate 

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.videoURL = info[UIImagePickerControllerMediaURL];
    
    AVAsset *videoAsset = [AVAsset assetWithURL:self.videoURL];
    
    if (self.imageGenerator) {
        [self.imageGenerator cancelAllCGImageGeneration];
    }
    
    [self.spinner startAnimating];
    
    self.imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
    NSArray *times = @[[NSValue valueWithCMTime:CMTimeMake(1, 1)]];
    [self.imageGenerator generateCGImagesAsynchronouslyForTimes:times completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        
        if (image && result == AVAssetImageGeneratorSucceeded) {
            CGImageRetain(image);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.thumbnailView.image = [UIImage imageWithCGImage:image];
                [self.spinner stopAnimating];
                [self checkStateForUpload];
                
                CGImageRelease(image);
            });
        }
        else {
            NSLog(@"ERROR: unable to generate images: %@", error);
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end












