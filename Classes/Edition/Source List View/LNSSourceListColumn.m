//
//  LNSSourceListColumn.m
//  SourceList
//
//  Created by Mark Alldritt on 07/09/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "LNSSourceListColumn.h"
#import "LNSSourceListCell.h"
#import "LNSSourceListSourceGroupCell.h"


@implementation LNSSourceListColumn

- (void)awakeFromNib {
	LNSSourceListCell* dataCell = [[[LNSSourceListCell alloc] init] autorelease];

	[dataCell setFont:[[self dataCell] font]];
	[dataCell setLineBreakMode:[[self dataCell] lineBreakMode]];

	[self setDataCell:dataCell];
}

- (id)dataCellForRow:(int)row {
#ifdef LNSSOURCE_LIST_COLUMN_TRACE_METHODS
	printf("IN  [LNSSourceListColumn dataCellForRow:]\n");
#endif
	
	LNSSourceListCell *cell;
	
	if (row >= 0) {
		NSDictionary* value = [[(NSOutlineView*) [self tableView] itemAtRow:row] observedObject];

		if ([[value objectForKey:@"isSourceGroup"] boolValue]) {
			LNSSourceListSourceGroupCell *groupCell = [[[LNSSourceListSourceGroupCell alloc] init] autorelease];
			
			[groupCell setFont:[[self dataCell] font]];
			[groupCell setLineBreakMode:[[self dataCell] lineBreakMode]];
			cell = groupCell;			
		}
		else {
			cell = [self dataCell];
		}
	}
	else {
		cell = [self dataCell];
	}
	
	return cell;
}

@end
