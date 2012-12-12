//
//  SYGTableViewController.h
//  usedRemind
//
//  Created by YangBin on 12-11-26.
//  Copyright (c) 2012年 dacaiguoguo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface SYGTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *eventTitle;
@property (retain, nonatomic) IBOutlet UILabel *eventLocation;
@property (retain, nonatomic) IBOutlet UILabel *startDate;

@end

@interface SYGTableViewController : UITableViewController<EKEventEditViewDelegate,UINavigationControllerDelegate>
{
    BOOL isAllowAccessEvent;
}
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKEventViewController *detailViewController;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *eventList;
@end
