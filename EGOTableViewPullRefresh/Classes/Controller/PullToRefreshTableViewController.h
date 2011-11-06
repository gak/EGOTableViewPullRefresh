//
//  PullToRefreshTableViewController.h
//  TableViewPull
//
//  Created by Jesse Collis on 1/07/10.
//  Copyright 2010 JC Multimedia Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface PullToRefreshTableViewController : NSObject {
	EGORefreshTableHeaderView *refreshHeaderView;
    UIScrollView *egoTableView;
	BOOL _reloading;
    id target;
}

@property(assign,getter=isReloading) BOOL reloading;
@property(nonatomic,readonly) EGORefreshTableHeaderView *refreshHeaderView;
@property(readwrite,retain) UIScrollView *egoTableView;
@property(readwrite,retain) id target;

- (void) dataSourceDidFinishLoadingNewData;
- (void) setupRefreshView;
- (void) setupRefreshView:(Class)cls;
- (void) forceRefresh;
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
