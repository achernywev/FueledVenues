//
//  VenuesListViewController.m
//  FueledVenues
//
//  Created by Alexandr Chernyshev on 23/05/15.
//  Copyright (c) 2015 Alexandr Chernyshev. All rights reserved.
//

#import "VenuesListViewController.h"

#import "Venue.h"
#import "VenueCell.h"
#import "Macroses.h"
#import "UIColor+FVColors.h"
#import "VenueDetailsViewController.h"
#import "VenueMapViewController.h"

@implementation VenuesListViewController
@dynamic presenter;

#pragma mark - initialization
- (instancetype)initWithPresenter:(VenuesPresenter *)presenter
{
    self = [super initWithPresenter:presenter];
    return self;
}

#pragma mark - Actions
- (IBAction)updateAction:(UIRefreshControl *)refreshControl
{
    [refreshControl beginRefreshing];
    [self.presenter loadVenuesWithCompletion:^(NSError *error) {
        if(!error) {
        }
        else {
            ShowError(error);
        }
        self.navigationItem.rightBarButtonItem.enabled = (self.presenter.venues.count > 0);
        [refreshControl endRefreshing];
    }];
}

- (IBAction)dismissMapAction:(UIStoryboardSegue *)sender
{
    
}

#pragma mark - lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = LOC(@"venueslistcontroller.title");
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.view.backgroundColor = [UIColor viewBackgroundColor];
    [self registerNibForCellClass:[VenueCell class] item:[Venue class] reuseIdentifier:kVenueCellReuseIdentifier];
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.refreshControl addTarget:self action:@selector(updateAction:) forControlEvents:UIControlEventValueChanged];
    [self updateAction:self.refreshControl];
}

#pragma mark - superclass methods
- (CGFloat)rowHeightForItem:(id)item
{
    return kDynamicRowHeight;
}

- (void)configureCell:(UITableViewCell<ViewItemProtocol> *)customizeCell forItem:(id)item
{
    [super configureCell:customizeCell forItem:item];
    VenueCell *cell = (VenueCell *)customizeCell;
    NSMutableArray *buttons = [NSMutableArray array];
    [buttons sw_addUtilityButtonWithColor:[UIColor redBackgroundColor] title:LOC(@"venueslistcontroller.deletebutton")];
    cell.rightUtilityButtons = buttons;
    cell.delegate = (id<SWTableViewCellDelegate>)self;
}

#pragma mark - Segues transitions
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[VenueDetailsViewController class]]) {
        VenueDetailsViewController *detailsController = (VenueDetailsViewController *)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Venue *venue = [self.presenter itemAtIndexPath:indexPath];
        VenueDetailsPresenter *detailsPresenter = [[VenueDetailsPresenter alloc]initWithVenue:venue];
        detailsController.presenter = detailsPresenter;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if([segue.destinationViewController isKindOfClass:[VenueMapViewController class]]) {
        VenueMapViewController *mapController = (VenueMapViewController *)segue.destinationViewController;
        mapController.venues = self.presenter.venues;
    }
}

#pragma mark - <UITableViewDelegate> methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"ShowVenueDetails" sender:self];
}

#pragma mark - <SWTableViewCellDelegate> methods
- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    [self.presenter handleRightUtiltyEventWithInex:index atIndexPath:[self.tableView indexPathForCell:cell]];
}

@end
