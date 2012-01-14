//
//  LNAppDelegate.m
//  LinenClipView
//
//  Created by David Keegan on 10/22/11.
//  Copyright (c) David Keegan. All rights reserved.
//

#import "LNAppDelegate.h"

@implementation LNAppDelegate{
    NSArray *_links;
}

@synthesize window = _window;
@synthesize webView = _webView;
@synthesize tableView = _tableView;
@synthesize tableScrollView = _tableScrollView;

- (void)awakeFromNib{
    [self.webView setPattern:[NSImage imageNamed:@"pattern3"]];    
    [self.tableScrollView setPattern:[NSImage imageNamed:@"pattern11"]];
    
    // fix the font size of the webview, this is not 
    // related to LNClipView it's just a bug in WebView
    [[self.webView preferences] setDefaultFontSize:16];
}

#pragma table delegte and data store

- (void)applicationDidFinishLaunching:(NSNotification *)notification{
    _links = [NSArray arrayWithObjects:@"http://drbl.in/cBRY", @"http://playbyplayapp.com", @"http://raven.io",
              @"http://twitter.com/_kgn", @"http://twitter.com/Dimillian", @"http://twitter.com/caffeinatedapp",
              @"http://github.com/kgn/LinenClipView", @"http://www.minimal-patterns.com",
              nil];
    [self.tableView reloadData];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_links count]*10;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex{
    return [_links objectAtIndex:rowIndex%[_links count]];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    [self.webView setMainFrameURL:[_links objectAtIndex:[self.tableView selectedRow]%[_links count]]];
}

@end
