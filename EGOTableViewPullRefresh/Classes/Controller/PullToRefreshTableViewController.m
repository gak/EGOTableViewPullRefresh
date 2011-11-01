//
//  PullToRefreshTableViewController.m
//  TableViewPull
//
//  Created by Jesse Collis on 1/07/10.
//  Copyright 2010 JC Multimedia Design. All rights reserved.
//

#import "PullToRefreshTableViewController.h"
#import "EGORefreshTableHeaderView.h"


@implementation PullToRefreshTableViewController
@synthesize reloading=_reloading;
@synthesize refreshHeaderView;
@synthesize egoTableView;
@synthesize target;

#pragma mark -
#pragma mark View lifecycle


- (void) setupRefreshView:(Class)cls
{
    refreshHeaderView = [[cls alloc] initWithFrame:CGRectMake(0.0f, 0.0f - egoTableView.bounds.size.height, 320.0f, egoTableView.bounds.size.height)];
    [egoTableView addSubview:refreshHeaderView];
    [refreshHeaderView release];
}

- (void) setupRefreshView
{
    [self setupRefreshView:[EGORefreshTableHeaderView class]];
}

- (void) forceRefresh
{
    egoTableView.contentOffset = CGPointMake(0, -65);
    [self scrollViewDidEndDragging:egoTableView willDecelerate:YES];
}

#pragma mark -
#pragma mark ScrollView Callbacks

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.isDragging) {
		if (refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_reloading) {
			[refreshHeaderView setState:EGOOPullRefreshPulling];
		}
	}
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{	
	if (scrollView.contentOffset.y <= - 65.0f && !_reloading) {
		_reloading = YES;
        if (!target)
            target = self;
        
		[target performSelector:@selector(reloadTableViewDataSource:) withObject:self];
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		egoTableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
	}
}
#pragma mark -
#pragma mark refreshHeaderView Methods

- (void) dataSourceDidFinishLoadingNewData
{	
	_reloading = NO;
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[egoTableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
	
    [refreshHeaderView setLastRefreshDate:[NSDate dateWithTimeIntervalSinceNow:0]];
	[refreshHeaderView setState:EGOOPullRefreshNormal];
}

@end

