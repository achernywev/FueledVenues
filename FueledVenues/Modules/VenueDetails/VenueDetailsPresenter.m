//
//  VenueDetailsPresenter.m
//  FueledVenues
//
//  Created by Alexandr Chernyshev on 24/05/15.
//  Copyright (c) 2015 Alexandr Chernyshev. All rights reserved.
//

#import "VenueDetailsPresenter.h"

#import "FoursquareAPI.h"

@interface VenueDetailsPresenter()
@property (nonatomic, strong) Venue *venue;

@end

@implementation VenueDetailsPresenter

#pragma mark - initialization
- (instancetype)initWithVenue:(Venue *)venue
{
    SectionItem *section = [[SectionItem alloc]initWithRows:@[venue, @123, venue.address]];
    self = [super initWithSections:[@[section] mutableCopy]];
    if(self) {
        _venue = venue;
    }
    return self;
}

#pragma mark - properties
- (NSString *)title
{
    return self.venue.name;
}

#pragma mark - pubic methods
- (void)updateInfo
{
    [[FoursquareAPI new] loadFullInfoForVenue:self.venue];
}
@end