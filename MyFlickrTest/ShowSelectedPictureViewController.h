//
//  ShowSelectedPictureViewController.h
//  MyFlickrTest
//
//  Created by Christophe Dellac on 10/12/13.
//  Copyright (c) 2013 Christophe Dellac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowSelectedPictureViewController : UIViewController

@property (nonatomic, weak) UIImage *selectedPicture;

- (IBAction)backButtonClick;
@end
