//
//  FirstViewController.m
//  MyFlickrTest
//
//  Created by Christophe Dellac on 10/12/13.
//  Copyright (c) 2013 Christophe Dellac. All rights reserved.
//

#import "FirstViewController.h"
#import "FlickrCustomCell.h"
#import "ShowSelectedPictureViewController.h"

@interface FirstViewController ()

@property (nonatomic, strong) IBOutlet UITableView *contentTableView;

@end

@implementation FirstViewController

@synthesize contentTableView = _contentTableView;

#pragma mark -
#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init flickr Handler with iOS type
    _flickrHandler = [[FlickContentHandler alloc] initWithType:iOSApi];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_flickrHandler switchFlickrApiType:iOSApi];
    _flickrHandler.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    
    if (searchBar.text.length)
        [_flickrHandler searchOnFlickr:searchBar.text];
}

#pragma mark -
#pragma mark - Scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lastLoadedContent.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_lastLoadedContent && _lastLoadedContent.count == 0)
        return @"No pictures found";
    return @"Enter text to look for pictures on Flickr";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShowSelectedPictureViewController *sspvc = [[UIStoryboard storyboardWithName:@"Main" bundle:NULL] instantiateViewControllerWithIdentifier:@"ShowSelectedPictureViewController"];
    sspvc.selectedPicture = [[_lastLoadedContent objectAtIndex:indexPath.row] objectAtIndex:1];
    [self presentViewController:sspvc animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FlickrCustomCell";
    FlickrCustomCell *cell = (FlickrCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FlickrCustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    [cell.nameLabel setText:[[_lastLoadedContent objectAtIndex:indexPath.row] objectAtIndex:0]];
    [cell.photoImageView setImage:[[_lastLoadedContent objectAtIndex:indexPath.row] objectAtIndex:1]];
    return cell;
}

#pragma mark -
#pragma mark - Flickr content handler delegate

- (void)hadReceivedContent:(NSMutableArray *)content
{
    _lastLoadedContent = content;

    
    [_contentTableView reloadData];
}

@end
