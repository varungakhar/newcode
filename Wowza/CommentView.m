//
//  CommentView.m
//  Ceflix
//
//  Created by KindleBit on 12/12/16.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
 {
    // Drawing code
}
*/

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if(self=[super initWithCoder:aDecoder])
    {
        lasttimestamp=@"";
        commentarray=[[NSMutableArray alloc]init];
        UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
        commenttable.tableFooterView=view;
        UIImage *myImage = [[UIImage imageNamed:@"btn_post"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        rightbar.image=myImage;
        
      //  /comments/getVideoComments
    }
    
    return self;
}
-(void)awakeFromNib
{
        [super awakeFromNib];
    lasttimestamp=@"";
    commentarray=[[NSMutableArray alloc]init];
    tablefooterview=[[UIView alloc]initWithFrame:CGRectZero];
    
navigate.title=@"Comment";
    
    [nav setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:47/255.0 green:82/255.0 blue:165/255.0 alpha:1]}];
    
    
    
    commenttable.tableFooterView=tablefooterview;
    
    UIImage *myImage = [[UIImage imageNamed:@"btn_post"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    rightbar.image=myImage;
    
    refresh=[[UIRefreshControl alloc]init];
    [commenttable addSubview:refresh];
    
    [refresh addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
    

}
-(void)refreshTable
{
    if (!response)
    {
        response=YES;
        [self getcomments:_videoId];
    }
  
}


-(void)getcomments:(NSString*)videoId
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
      NSDictionary *dict=@{@"encID":[defaults valueForKey:@"UserIdentifier"],@"eventID":videoId,@"lastTimeStamp":lasttimestamp,@"mode":@"next"};
    
    [[CFCeflixService sharedInstance]webservicescall:dict action:@"angles/getVideoComments" block:^(NSData *data, NSError *error) {
   
        [refresh endRefreshing];
        
        response=NO;
        if (error)
        {
            if (error.code==NSURLErrorNotConnectedToInternet)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please check your connection and try again." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okay =[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
        [alert addAction:okay];
[_controller presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:@"Can't connect to Ceflix right now." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:okay];
[_controller presentViewController:alert animated:YES completion:nil];
            }
        }
        else
        {
          NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dict valueForKey:@"status"]integerValue]==1)
            {
                NSArray *commentdata=[dict valueForKey:@"data"];
                
                for (NSDictionary *dic in commentdata)
                {
   
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"com_time like[cd] %@",[dic valueForKey:@"com_time"]];
                    
        NSArray *array=[commentarray filteredArrayUsingPredicate:predicate];
                    if (array.count==0)
                    {
                        [commentarray addObject:dic];
                    }
                    
                    
                }
                if (commentarray.count>0)
                {
               
NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                                        initWithKey: @"com_time" ascending: YES];
                    
  commentarray=[commentarray sortedArrayUsingDescriptors:@[sortDescriptor]];
                    
        commentarray=[commentarray mutableCopy];
                    
                    
                    
                    
lasttimestamp=[NSString stringWithFormat:@"%@",[[commentarray objectAtIndex:0]valueForKey:@"com_time"]];
                }
                 [commenttable reloadData];
                
                
                if (frompost)
                {
             [commenttable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[commentarray indexOfObject:[commentarray lastObject]] inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    frompost=NO;
                }

                
navigate.title=[NSString stringWithFormat:@"Comment(%lu)",(unsigned long)commentarray.count];
                
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[dict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
[alert addAction:okay];
//[_controller presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentarray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* ind=@"cell";
    
    CommentViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ind];
    if(!cell)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"CommentViewCell" owner:self options:nil];
        cell=[nib objectAtIndex:0];
    }
    cell.commentlbl.numberOfLines=0;
   
    cell.commentlbl.text=[[commentarray objectAtIndex:indexPath.row]valueForKey:@"comment"];
    cell.timelbl.text=[[commentarray objectAtIndex:indexPath.row]valueForKey:@"timeAgo"];
    NSString *fullname=[NSString stringWithFormat:@"%@ %@",[[commentarray objectAtIndex:indexPath.row]valueForKey:@"fname"],[[commentarray objectAtIndex:indexPath.row]valueForKey:@"lname"]];
    cell.username.text=fullname;
    
    [cell.userimage loadImageUsingUrlString:[[commentarray objectAtIndex:indexPath.row]valueForKey:@"profile_pic"]];
    cell.userimage.layer.cornerRadius=20;
    cell.userimage.layer.masksToBounds=YES;
    
    cell.commentlbl.font=[UIFont systemFontOfSize:15.0f];
    
    CGFloat value=[UIScreen mainScreen].bounds.size.width-65;
    CGRect rect=[cell.commentlbl.text boundingRectWithSize:CGSizeMake(value, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f
                                                                                                                                                                                                  ]} context:nil];
    
    
    cell.commentlbl.frame=CGRectMake(cell.commentlbl.frame.origin.x,cell.commentlbl.frame.origin.y, value, rect.size.height);
    
    NSIndexSet *set =[NSIndexSet indexSetWithIndex:0];
    
    
    [tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    
    
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  //  CommentViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];

    CGFloat value=[UIScreen mainScreen].bounds.size.width-65;
    
    CGRect rect=[[[commentarray objectAtIndex:indexPath.row]valueForKey:@"comment"] boundingRectWithSize:CGSizeMake(value, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f
                                                                                                                                                                                                  ]} context:nil];
    
    return rect.size.height+50;
}
-(IBAction)postComment:(id)sender
{
    NSString *str=[commenttext.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([str isEqualToString:@""])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:okay];
     //   [_controller presentViewController:alert animated:YES completion:nil];
        
        return;
        
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *random=[NSString stringWithFormat:@"%d",arc4random()];
    
    NSDictionary *dict=@{@"encID":[defaults valueForKey:@"UserIdentifier"],@"token":[defaults valueForKey:@"CurrentUserToken"],@"eventID":_videoId,@"comment":commenttext.text,@"randNumber":random};
    
    commenttext.text=@"";
    [commenttext resignFirstResponder];
    
    frompost=YES;
    response=YES;
    [[CFCeflixService sharedInstance]webservicescall:dict action:@"angles/addcomments" block:^(NSData *data, NSError *error) {
        if (error)
        {
            if (error.code==NSURLErrorNotConnectedToInternet)
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Internet" message:@"Please check your connection and try again." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:okay];
                [_controller presentViewController:alert animated:YES completion:nil];
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Something went wrong" message:@"Can't connect to Ceflix right now." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:okay];
                [_controller presentViewController:alert animated:YES completion:nil];
            }
        }
        else
        {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dict valueForKey:@"status"]integerValue]==1)
            {
                commenttext.text=@"";
                [commenttext resignFirstResponder];
                lasttimestamp=@"";
                [self getcomments:_videoId];
            }
            else
            {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:[dict valueForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okay = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:okay];
    [_controller presentViewController:alert animated:YES completion:nil];
            }
        }
    }];
}
-(void)removeview
{
    [commentarray removeAllObjects];
    _videoId=@"";
    lasttimestamp=@"";
    [self removeFromSuperview];
}
-(IBAction)cancel:(id)sender

{
    [self removeFromSuperview];
}

@end
