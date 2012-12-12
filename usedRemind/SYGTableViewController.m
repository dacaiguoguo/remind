//
//  SYGTableViewController.m
//  usedRemind
//
//  Created by YangBin on 12-11-26.
//  Copyright (c) 2012年 dacaiguoguo. All rights reserved.
//

#import "SYGTableViewController.h"
#import "SYGNormalViewController.h"
@implementation SYGTableViewCell


- (void)dealloc {
    [_eventTitle release];
    [_eventLocation release];
    [_startDate release];
    [super dealloc];
}
@end
@interface SYGTableViewController ()

@end

@implementation SYGTableViewController
@synthesize eventStore = _eventStore;
@synthesize defaultCalendar = _defaultCalendar;
@synthesize detailViewController = _detailViewController;
@synthesize eventList = _eventList;
- (void)dealloc{
    [super dealloc];
    [_eventStore release];
    [_defaultCalendar release];
    [_detailViewController release];
    [_eventList release];
}
- (void)initStore{
    if (!isAllowAccessEvent) {
        return;
    }
    dispatch_queue_t fetwork_queue;
    fetwork_queue = dispatch_queue_create("com.guoguo.me", nil);
    
    dispatch_async(fetwork_queue, ^{
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *onedayAgoComponents = [[NSDateComponents alloc] init];
        onedayAgoComponents.day = -1;
        NSDate *oneDayAgo = [calendar dateByAddingComponents:onedayAgoComponents
                                                      toDate:[NSDate date]
                                                     options:0];
        [onedayAgoComponents release];
        NSDateComponents *oneYearFromNowComponents = [[NSDateComponents alloc] init];
        oneYearFromNowComponents.year = 1;
        NSDate *oneYearFromNow = [calendar dateByAddingComponents:oneYearFromNowComponents
                                                           toDate:[NSDate date]
                                                          options:0];
        [oneYearFromNowComponents release];
//        [self.eventStore calendarsForEntityType:EKEntityTypeEvent]
        NSPredicate *predicate = [_eventStore predicateForEventsWithStartDate:oneDayAgo
                                                                      endDate:oneYearFromNow
                                                                    calendars:nil];
        NSArray *tempArray  = [[_eventStore eventsMatchingPredicate:predicate] retain];
        [tempArray sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
        // 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.eventList removeAllObjects];
            [self.eventList addObjectsFromArray:tempArray];
            [tempArray release];
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];
        });
        dispatch_release(fetwork_queue);
    });
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Event List";
    }
    return self;
}


- (void)goNormalViewController:(id)sender{
    SYGNormalViewController *aVC = [[SYGNormalViewController alloc] initWithNibName:@"SYGNormalViewController" bundle:nil];
    [self.navigationController pushViewController:aVC animated:YES];
    [aVC release];
}


- (void)setUpNavigationItem{
    //	Create an Add button
	UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      UIBarButtonSystemItemAdd target:self action:@selector(addEvent:)];
	self.navigationItem.rightBarButtonItem = addButtonItem;
	[addButtonItem release];
//    //	Create an Add button
//	UIBarButtonItem *addlButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
//                                       UIBarButtonSystemItemAdd target:self action:@selector(goNormalViewController:)];
//	self.navigationItem.leftBarButtonItem = addlButtonItem;
//	[addlButtonItem release];
}


- (void)setUpRefeshControl{
    [self.tableView registerNib:[UINib nibWithNibName:@"cellView" bundle:nil] forCellReuseIdentifier:@"displayCell"];
    
    self.refreshControl = [[[UIRefreshControl alloc]init] autorelease];
    self.refreshControl.tintColor = [UIColor blueColor];
    
    NSAttributedString *attString = [[NSAttributedString alloc]initWithString:@"下拉刷新"];
    self.refreshControl.attributedTitle =attString;
    [attString release];
    
    [self.refreshControl addTarget:self
                            action:@selector(RefreshViewControlEventValueChanged)
                  forControlEvents:UIControlEventValueChanged];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.eventStore = [[[EKEventStore alloc] init] autorelease];
    
    [_eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        NSString *aRet = granted?@"用户同意了":@"用户不同意";
        NSLog(@"%@",aRet);
        isAllowAccessEvent = granted;
        if (granted) {
            self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
            [self initStore];
        }
        
        
    }];
    [self setUpRefeshControl];
    [self setUpNavigationItem];
    self.eventList = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 114;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_eventList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"displayCell";
    SYGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (_eventList.count==0) {
        return cell;
    }
    EKEvent *aEvent = [_eventList objectAtIndex:indexPath.row];
    
    cell.eventLocation.text = aEvent.location;
    cell.eventTitle.text = aEvent.title;
    cell.startDate.text =[NSString stringWithFormat:@"%@",aEvent.startDate];
#warning  cell.startDate.text这里要转时区的。。。
    // Configure the cell...
    
    return cell;
}



#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error = nil;
        EKEvent *thisEvent = [[_eventList objectAtIndex:indexPath.row] retain];
        assert(thisEvent);
        [self.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
        [_eventList removeObject:thisEvent];
        [thisEvent release];
        [self.tableView reloadData];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailViewController = [[[EKEventViewController alloc] initWithNibName:nil bundle:nil] autorelease];
    _detailViewController.event = [self.eventList objectAtIndex:indexPath.row];
    _detailViewController.allowsEditing = YES;
    [self.navigationController pushViewController:_detailViewController animated:YES];
}
- (void)addEvent:(id)sender{
    EKEventEditViewController *addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
	
	// set the addController's event store to the current event store.
	addController.eventStore = self.eventStore;
	
	// present EventsAddViewController as a modal view controller
	[self presentViewController:addController animated:YES completion:^{
        
    }];
	
	addController.editViewDelegate = self;
	[addController release];
    
}
#pragma mark -
#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self) {
        [self initStore];
	}
}

#pragma mark -
#pragma mark EKEventEditViewDelegate


- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action{
    
    NSError *error = nil;
	EKEvent *thisEvent = controller.event;
    //也可以手动用代码写EKEvent .
//    EKEvent *newEvent = [EKEvent eventWithEventStore:self.eventStore];
//    newEvent.title = @"newEvent";
//    newEvent.startDate = [NSDate date];
//    newEvent.endDate = [NSDate dateWithTimeIntervalSinceNow:8840];
//    newEvent.calendar = thisEvent.calendar;
//    thisEvent = newEvent;
    switch (action) {
		case EKEventEditViewActionCanceled:
			// Edit action canceled, do nothing.
			break;
			
		case EKEventEditViewActionSaved:
			// When user hit "Done" button, save the newly created event to the event store,
			// and reload table view.
			// If the new event is being added to the default calendar, then update its
			// eventsList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
				[self.eventList addObject:thisEvent];
			}
			[controller.eventStore saveEvent:controller.event span:EKSpanThisEvent error:&error];
			[self.tableView reloadData];
			break;
			
		case EKEventEditViewActionDeleted:
			// When deleting an event, remove the event from the event store,
			// and reload table view.
			// If deleting an event from the currenly default calendar, then update its
			// eventsList.
			if (self.defaultCalendar ==  thisEvent.calendar) {
				[self.eventList removeObject:thisEvent];
			}
			[controller.eventStore removeEvent:thisEvent span:EKSpanThisEvent error:&error];
			[self.tableView reloadData];
			break;
			
		default:
			break;
	}
	// Dismiss the modal view controller
	[controller dismissViewControllerAnimated:YES completion:^{
        [self initStore];
    }];
    
}
// Set the calendar edited by EKEventEditViewController to our chosen calendar - the default calendar.
- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller {
	EKCalendar *calendarForEdit = self.defaultCalendar;
	return calendarForEdit;
}

- (void)RefreshViewControlEventValueChanged{
    if (isAllowAccessEvent) {
        [self initStore];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户不允许访问日历" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [alert release];
        [self.refreshControl endRefreshing];
    }
}




@end
