//
//  CommentView.h
//  Ceflix
//
//  Created by KindleBit on 12/12/16.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewCell.h"
#import "CFCeflixService.h"
@interface CommentView : UIView<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UINavigationBar *nav;
    
    IBOutlet UINavigationItem *navigate;
    UIRefreshControl *refresh;
    BOOL response,frompost;
    IBOutlet UIView *footerview;
    NSString *lasttimestamp;
    NSMutableArray *commentarray;
    IBOutlet UITextField *commenttext;
    IBOutlet UITableView *commenttable;
  IBOutlet  UIBarButtonItem *rightbar;
    UIActivityIndicatorView *activity;
    UIView *tablefooterview;
}
-(void)removeview;
-(IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) NSString* videoId;
@property(strong,nonatomic)UIViewController *controller;
-(void)getcomments:(NSString*)videoId;
@end
