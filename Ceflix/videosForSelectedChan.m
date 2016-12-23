//
//  channelViewController.m
//  Ceflix
//
//  Created by Kindlebit Solution Pvt.Ltd on 05/06/15.
//  Copyright (c) 2015 Kindlebit Solution Pvt.Ltd. All rights reserved.
//

#import "channelViewController.h"

@interface channelViewController ()

@end

@implementation channelViewController
@synthesize categoryName,channelTableView;

- (void)viewDidLoad
{
    categoryArray=[[NSMutableArray alloc]init];
    channelTitleArray=[[NSMutableArray alloc]init];

    [categoryArray addObject:[UIImage imageNamed:@"11.jpeg"]];
    [categoryArray addObject:[UIImage imageNamed:@"22.jpeg"]];
    [categoryArray addObject:[UIImage imageNamed:@"33.jpeg"]];
    [categoryArray addObject:[UIImage imageNamed:@"11.jpeg"]];
    [categoryArray addObject:[UIImage imageNamed:@"22.jpeg"]];
    [categoryArray addObject:[UIImage imageNamed:@"33.jpeg"]];
    
    [channelTitleArray addObject:@"Lovely World"];
    [channelTitleArray addObject:@"Dance Express"];
    [channelTitleArray addObject:@"DJ Express"];
    [channelTitleArray addObject:@"USA Express"];
    [channelTitleArray addObject:@"Express music"];
    [channelTitleArray addObject:@"funny music"];

    

    channelTableView.backgroundColor=[UIColor clearColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoryArray count];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
    return 160;
    }
    else
    {
    return 140;
 
    }
}


-(void) fillRowsForIpad:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell
{
    cell.backgroundColor=[UIColor clearColor];
    UIImageView *categoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10,120, 120)];
    categoryImageView.layer.cornerRadius = 3.0f;
    //[categoryImageView setContentMode:UIViewContentModeScaleAspectFit];
    categoryImageView.layer.masksToBounds = YES;
    categoryImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    categoryImageView.layer.borderWidth = 2;
    categoryImageView.image=[categoryArray objectAtIndex:indexPath.row];
    categoryImageView.userInteractionEnabled=YES;
    [cell.contentView addSubview:categoryImageView];
    
    UILabel *categoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 10,channelTableView.frame.size.width-150,25)];
categoryLabel.textAlignment=NSTextAlignmentLeft;
categoryLabel.textColor=[UIColor colorWithRed:117.0/255.0 green:214.0/255.0 blue:255.0/255.0 alpha:1.0f];

    categoryLabel.font=[UIFont boldSystemFontOfSize:20];
    
    categoryLabel.text=[channelTitleArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:categoryLabel];
    
    UILabel *descriptionLabel=[[UILabel alloc]initWithFrame:CGRectMake(150, 34,channelTableView.frame.size.width-150,80)];
    descriptionLabel.textAlignment=NSTextAlignmentLeft;
    descriptionLabel.textColor=[UIColor whiteColor];
    descriptionLabel.numberOfLines=4;
    descriptionLabel.font=[UIFont systemFontOfSize:16];
    //  descriptionLabel.backgroundColor=[UIColor whiteColor];
    descriptionLabel.text=@"Get to know more about your favourite gospel artist. Music Cocktail is an inspirational program, showcasing the life and music of a artist.";
    [cell.contentView addSubview:descriptionLabel];
    
    UIButton *plusbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusbutton addTarget:self
                   action:@selector(plusbuttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    plusbutton.tag=indexPath.row;
    [plusbutton setBackgroundImage:[UIImage imageNamed:@"box-ipad.png"] forState: UIControlStateNormal];
    [plusbutton setImage:[UIImage imageNamed:@"add-white-ipad.png"] forState: UIControlStateNormal];
    plusbutton.frame = CGRectMake(150,105,25,25);
    [cell.contentView addSubview:plusbutton];
    
    UIButton *sharebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sharebutton addTarget:self
                    action:@selector(sharebuttonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    sharebutton.tag=indexPath.row;
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState: UIControlStateNormal];
    sharebutton.frame = CGRectMake(190,105,25,25);
    [cell.contentView addSubview:sharebutton];

}
-(void) fillRowsForIphone:(NSIndexPath *)indexPath cell:(UITableViewCell *)cell
{
    cell.backgroundColor=[UIColor clearColor];
    
    UIImageView *categoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5,5,100,100)];
    categoryImageView.layer.cornerRadius = 3.0f;
    //[categoryImageView setContentMode:UIViewContentModeScaleAspectFit];
    categoryImageView.layer.masksToBounds = YES;
    categoryImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    categoryImageView.layer.borderWidth = 2;
    categoryImageView.image=[categoryArray objectAtIndex:indexPath.row];
    categoryImageView.userInteractionEnabled=YES;
    [cell.contentView addSubview:categoryImageView];
    
    UILabel *categoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(120,5,channelTableView.frame.size.width-120,20)];
    categoryLabel.textAlignment=NSTextAlignmentLeft;
categoryLabel.textColor=[UIColor colorWithRed:117.0/255.0 green:214.0/255.0 blue:255.0/255.0 alpha:1.0f];
    categoryLabel.font=[UIFont boldSystemFontOfSize:15];
   
    categoryLabel.text=[channelTitleArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:categoryLabel];
    
    UILabel *descriptionLabel=[[UILabel alloc]initWithFrame:CGRectMake(120,26,channelTableView.frame.size.width-120,65)];
    descriptionLabel.textAlignment=NSTextAlignmentLeft;
    descriptionLabel.textColor=[UIColor whiteColor];
    descriptionLabel.numberOfLines=4;
    descriptionLabel.font=[UIFont systemFontOfSize:12];
    //  descriptionLabel.backgroundColor=[UIColor whiteColor];
    descriptionLabel.text=@"Get to know more about your favourite gospel artist. Music Cocktail is an inspirational program, showcasing the life and music of a artist.";
    [cell.contentView addSubview:descriptionLabel];
    
    UIButton *plusbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [plusbutton addTarget:self
                   action:@selector(plusbuttonClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    plusbutton.tag=indexPath.row;
    [plusbutton setBackgroundImage:[UIImage imageNamed:@"box-ipad.png"] forState: UIControlStateNormal];
    [plusbutton setImage:[UIImage imageNamed:@"add-white-ipad.png"] forState: UIControlStateNormal];
    plusbutton.frame = CGRectMake(120,105,20,20);
    [cell.contentView addSubview:plusbutton];
    
    UIButton *sharebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [sharebutton addTarget:self
                    action:@selector(sharebuttonClicked:)
          forControlEvents:UIControlEventTouchUpInside];
    sharebutton.tag=indexPath.row;
    [sharebutton setBackgroundImage:[UIImage imageNamed:@"box-ipad.png"] forState: UIControlStateNormal];
     [sharebutton setImage:[UIImage imageNamed:@"share.png"] forState: UIControlStateNormal];
    sharebutton.frame = CGRectMake(150,105,20,20);
    [cell.contentView addSubview:sharebutton];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:
                UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        [self fillRowsForIpad:indexPath cell:cell];

    }
    else
    {
        [self fillRowsForIphone:indexPath cell:cell];
 
    }
    
      return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void) plusbuttonClicked:(UIButton*)sender
{
}

-(void) sharebuttonClicked:(UIButton*)sender
{
}
-(IBAction)back_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
