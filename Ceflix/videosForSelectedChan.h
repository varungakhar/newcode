//
//  channelViewController.h
//  Ceflix
//
//  Created by Kindlebit Solution Pvt.Ltd on 05/06/15.
//  Copyright (c) 2015 Kindlebit Solution Pvt.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface channelViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *categoryArray;
    NSMutableArray *channelTitleArray;

    
    
}
@property(nonatomic,retain)IBOutlet UITableView *channelTableView;
@property(nonatomic,retain)NSString *categoryName;

-(IBAction)back_click:(id)sender;
@end
