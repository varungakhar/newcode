//
//  CFBannerContainerCellView.h
//  Ceflix
//
//  Created by Tobi Omotayo on 10/09/2016.
//  Copyright © 2016 Internet Multimedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFBannerContainerCellView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *collectionData;

- (void)setCollectionData:(NSArray *)collectionData;

@end
