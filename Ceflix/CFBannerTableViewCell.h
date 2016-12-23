//
//  CFBannerTableViewCell.h
//  Ceflix
//
//  Created by Tobi Omotayo on 10/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFBannerContainerCellView.h"

@interface CFBannerTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet CFBannerContainerCellView *collectionView;

- (void)setCollectionData:(NSArray *)collectionData;

@end
