//
//  CFUploadVideoViewController.h
//  Ceflix
//
//  Created by Tobi Omotayo on 23/11/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CFConnectVideoUpload;

@protocol CFUploadVideoViewControllerDelegate;

/**
 * The view-controller for capturing details for a new video to upload
 * to the Ceflix server
 */
@interface CFUploadVideoViewController : UIViewController

@property (nonatomic, weak) id<CFUploadVideoViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *libraryButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView; // replace this with AVPlayer for previewing the video with only play control.
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)didTapCancel:(id)sender;
- (IBAction)didTapDone:(id)sender;
- (IBAction)didTapLibraryButton:(id)sender;
- (IBAction)didTapRecordButton:(id)sender;

@end

@protocol CFUploadVideoViewControllerDelegate <NSObject>

- (void)uploadVideoController:(CFUploadVideoViewController *)controller requestsUploadFor:(CFConnectVideoUpload *)upload;

@end
