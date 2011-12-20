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
    // By default LNClipView uses an image in the main bundle named Linen.
    // To use a different image call [LNClipView setBackgroundImage:].
    // The background image is stored statically to improve drawing performance so 
    // it can only be set once and must be set before setting up any clip views.
    // [LNClipView setBackgroundImage:[NSImage imageNamed:@"linen_background"]];
    
    // Setup a NSScrollView
    [LNClipView setupWithScrollView:self.tableScrollView];
    
    
    // Setup a WebView
    [LNWebClipView setupWithWebView:self.webView];
    
    [[self.webView preferences] setDefaultFontSize:16];
}

#pragma table delegte and data store

- (void)applicationDidFinishLaunching:(NSNotification *)notification{
    _links = [NSArray arrayWithObjects:@"http://drbl.in/cBRY", @"http://playbyplayapp.com", @"http://raven.io", nil];
    [self.tableView reloadData];
    [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [_links count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex{
    return [_links objectAtIndex:rowIndex];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    [self.webView setMainFrameURL:[_links objectAtIndex:[self.tableView selectedRow]]];
}

@end
