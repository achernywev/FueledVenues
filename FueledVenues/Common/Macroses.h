//
//  Macroses.h
//  FueledVenues
//
//  Created by Alexandr Chernyshev on 23/05/15.
//  Copyright (c) 2015 Alexandr Chernyshev. All rights reserved.
//

#define NavigationController(root)                  [[UINavigationController alloc]initWithRootViewController:root]
#define ShowError(error)                            [[[UIAlertView alloc]initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define RGBColor(R,G,B)                             [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1.0f]
#define RGBAColor(R,G,B,A)                          [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#define LOC(key)                                    NSLocalizedString((key), @"")

#define NIL_TO_NULL(obj)                            (obj != nil) ? obj : [NSNull null]
#define NULL_TO_NIL(obj)                            (obj == [NSNull null]) ? nil : obj