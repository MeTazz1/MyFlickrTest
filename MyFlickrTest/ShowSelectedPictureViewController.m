//
//  ShowSelectedPictureViewController.m
//  MyFlickrTest
//
//  Created by Christophe Dellac on 10/12/13.
//  Copyright (c) 2013 Christophe Dellac. All rights reserved.
//

#import "ShowSelectedPictureViewController.h"

@interface ShowSelectedPictureViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *selectedImageView;

@end

@implementation ShowSelectedPictureViewController

@synthesize selectedPicture = _selectedPicture;
@synthesize selectedImageView = _selectedImageView;


#pragma mark -
#pragma mark - Life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

	[_selectedImageView setImage:_selectedPicture];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 
#pragma mark - Actions

- (IBAction)backButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
