//
//  Review+Parsing.h
//  FueledVenues
//
//  Created by Alexandr Chernyshev on 28/05/15.
//  Copyright (c) 2015 Alexandr Chernyshev. All rights reserved.
//

#import "Review.h"

@interface Review (Parsing)

+ (NSArray *)reviewsArrayFromResponse:(id)responseObject;
@end
