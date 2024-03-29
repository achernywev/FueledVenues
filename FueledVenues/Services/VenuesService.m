//
//  VenuesService.m
//  FueledVenues
//
//  Created by Alexandr Chernyshev on 27/05/15.
//  Copyright (c) 2015 Alexandr Chernyshev. All rights reserved.
//

#import "VenuesService.h"

#import "VenuesCacheClient.h"
#import "VenuesDataClient.h"

static NSInteger  const kDefaultNumberOfVenues = 50;

@interface VenuesService()
@property (nonatomic, readonly) VenuesCacheClient * cacheClient;
@property (nonatomic, readonly) VenuesDataClient *  dataClient;

@end

@implementation VenuesService

#pragma mark - initialization
- (instancetype)init
{
    self = [super init];
    if(self) {
        _dataClient = [VenuesDataClient new];
        _cacheClient = [VenuesCacheClient new];
    }
    return self;
}

#pragma mark - public methods
- (void)loadVenuesWithCompletion:(void(^)(NSArray *venues, NSError *error))completion
{
    NSArray *blackListed = [self.cacheClient loadBlacklistedVenues];
    
    __weak typeof(self)weakSelf = self;
    [self.dataClient loadVenuesWithCount:kDefaultNumberOfVenues + blackListed.count
                              completion:^(NSArray *venues, NSError *error) {
                                  if(!error && venues.count) {
                                      [weakSelf.cacheClient storeVenues:venues];
                                  }
                                  else {
                                      venues = [weakSelf.cacheClient loadVenues];
                                      error = venues.count ? nil : error;
                                  }
                                  [weakSelf finishWithVenues:venues error:error
                                        blackListedArray:blackListed completion:completion];
                              }
     ];
}

- (void)loadReviewsWithVenueIdentifier:(EntityIDType)venueID
                            completion:(void(^)(NSArray *myReviews, NSArray *otherReview, NSError *error))completion;
{
    __weak typeof(self)weakSelf = self;
    [self.dataClient loadReviewsForVenueWithIdentifier:venueID
                                            completion:^(NSArray *reviews, NSError *error) {
                                                if(!error && reviews.count) {
                                                    [weakSelf.cacheClient storeReviews:reviews];
                                                }
                                                else {
                                                    reviews = [weakSelf.cacheClient loadOtherReviewsWithIdentifier:venueID];
                                                    error = reviews.count ? nil : error;
                                                }
                                                NSArray *myReviews = [weakSelf.cacheClient loadMyReviewsWithIdentifier:venueID];
                                                if(completion) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        completion(myReviews, reviews, error);
                                                    });
                                                }
                                            }
     ];
}

- (void)addToBlackList:(Venue *)venue
{
    [self.cacheClient addToBlackList:venue];
}

- (void)createReviewWithVenueIdentifier:(EntityIDType)venueID
                                   text:(NSString *)text
                             completion:(void(^)(Review *review, NSError *error))completion
{
    Review *review = [self.cacheClient createReviewWithVenueIdentifier:venueID text:text];
    if(completion) {
        completion(review, nil);
    }
}

#pragma mark - working methods
- (void)finishWithVenues:(NSArray *)venues
                   error:(NSError *)error
        blackListedArray:(NSArray *)blackListedArray
              completion:(void(^)(NSArray *venues, NSError *error))completion
{
    venues = [venues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT SELF IN %@", blackListedArray]];
    venues = [venues sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES]]];
    if(completion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(venues, error);
        });
    }
}
@end
