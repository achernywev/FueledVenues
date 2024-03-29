//
//  VenueDetailsPresenter.h
//  FueledVenues
//
//  Created by Alexandr Chernyshev on 24/05/15.
//  Copyright (c) 2015 Alexandr Chernyshev. All rights reserved.
//

#import "MutableSectionsPresenter.h"

#import "Venue.h"
#import "VenueContactItem.h"

@interface VenueDetailsPresenter : MutableSectionsPresenter
@property (nonatomic, readonly) Venue *venue;

- (instancetype)initWithVenue:(Venue *)venue;
- (void)updateInfo;
@end
