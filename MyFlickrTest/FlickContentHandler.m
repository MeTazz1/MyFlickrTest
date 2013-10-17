//
//  FlickContentHandler.m
//  MyFlickrTest
//
//  Created by Christophe Dellac on 10/12/13.
//  Copyright (c) 2013 Christophe Dellac. All rights reserved.
//

#import "FlickContentHandler.h"
#import "MBProgressHUD.h"

@implementation FlickContentHandler

@synthesize delegate;

- (FlickContentHandler*)initWithType:(ContentType)type
{
    _type = type;
    flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:FLICKR_API_KEY sharedSecret:FLICKR_SECRET_KEY];
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
    [flickrRequest setDelegate:self];
    return self;
}

- (void)switchFlickrApiType:(ContentType)type
{
    _type = type;
}

#pragma mark - 
#pragma mark - Actions

- (void)hadContent:(NSMutableArray*)content
{
    if ([delegate respondsToSelector:@selector(hadReceivedContent:)])
        [delegate performSelector:@selector(hadReceivedContent:) withObject:content];
}

- (void)searchOnFlickr:(NSString*)search
{
    if (_type == iOSApi)
    {
        if (![flickrRequest isRunning]) {
            [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
            [flickrRequest callAPIMethodWithGET:@"flickr.photos.search" arguments:[NSDictionary dictionaryWithObjectsAndKeys:search, @"text", PER_PAGE, @"per_page", nil]];
        }
    }
    else if (_type == PythonApi || _type == DjangoApi)
    {
        [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        [self performSelectorInBackground:@selector(sendSynchronousHTTPRequest:) withObject:search];
    }
}

- (void)fetchResult:(NSArray*)result
{
    NSMutableArray *daRockWilder = [[NSMutableArray alloc] init];
    
    for (NSDictionary *content in result)
    {
        NSString *title;
        [[content objectForKey:@"title"] length] == 0 ? (title = @"No title") : (title = [content objectForKey:@"title"]);
        
        NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:content size:OFFlickrLargeSize];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:photoURL]];
        
        [daRockWilder addObject:@[title, image]];
    }
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    [self hadContent:daRockWilder];
}

#pragma mark -
#pragma mark - Flickr delegate for Python APi

- (void)sendSynchronousHTTPRequest:(NSString*)search
{
    search = [search stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *requestUrl;
    if (_type == PythonApi)
        requestUrl = [NSString stringWithFormat:@"http://testflickrcd.appspot.com/?search=%@", search];
    else if (_type == DjangoApi)
        requestUrl = [NSString stringWithFormat:@"http://localhost:8080/FlickrDjango/%@/", search];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestUrl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:15];
    [request setHTTPMethod:@"GET"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];

    if (requestError)
        NSLog(@"Error while parsing");
    else
    {
        if (responseData) {
            NSDictionary *killingInTheName = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            [self fetchResult:[killingInTheName valueForKeyPath:@"photos.photo"]];
        }
    }
}

#pragma mark -
#pragma mark - Flickr delegate for iOS API

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    [self fetchResult:[inResponseDictionary valueForKeyPath:@"photos.photo"]];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    [MBProgressHUD hideAllHUDsForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
}

@end
