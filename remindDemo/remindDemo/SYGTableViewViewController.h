//
//  SYGTableViewViewController.h
//  remindDemo
//
//  Created by YangBin on 12-12-17.
//  Copyright (c) 2012年 dacaiguoguo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
@interface SYGTableViewViewController : UITableViewController<EKEventEditViewDelegate,UINavigationControllerDelegate>
{
    BOOL isAllowAccessEvent;
}
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKEventViewController *detailViewController;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *eventList;
@end
