//
//  FlickrCustomCell.h
//  MyFlickrTest
//
//  Created by Christophe Dellac on 10/12/13.
//  Copyright (c) 2013 Christophe Dellac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrCustomCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UIImageView *photoImageView;

@end
