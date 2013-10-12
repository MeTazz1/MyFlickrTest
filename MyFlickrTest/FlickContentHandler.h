//
//  FlickContentHandler.h
//  MyFlickrTest
//
//  Created by Christophe Dellac on 10/12/13.
//  Copyright (c) 2013 Christophe Dellac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentType.h"
#import "ObjectiveFlickr.h"

#define FLICKR_API_KEY @"ad577200a30f4a09cb5bd01c439648ce"
#define FLICKR_SECRET_KEY @"da76a4b4375e02c9"
#define PER_PAGE @"5"

@protocol FlickContentHandlerDelegate <NSObject>

@required
- (void)hadReceivedContent:(NSArray*)content;

@end

@interface FlickContentHandler : NSObject <OFFlickrAPIRequestDelegate>
{
    ContentType _type;
    OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
}

@property (nonatomic, weak) id <FlickContentHandlerDelegate> delegate;

#pragma mark - 
#pragma mark - Flick Content Handler life cycle

- (FlickContentHandler*)initWithType:(ContentType)type;
- (void)switchFlickrApiType:(ContentType)type;


#pragma mark - Actions

- (void)hadContent:(NSMutableArray*)content;
- (void)searchOnFlickr:(NSString*)search;

@end
