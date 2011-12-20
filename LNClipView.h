//
//  LNClipView.h
//  LinenClipView
//
//  Created by David Keegan on 10/22/11.
//  Copyright (c) David Keegan. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>

@interface LNClipView : NSClipView

+ (void)setBackgroundImage:(NSImage *)image;
+ (void)setupWithScrollView:(NSScrollView *)scrollView;

@end

//  From http://www.koders.com/objectivec/fid22DEE7EA2343C20D0FEEC2C079245069DF3E32A5.aspx
@interface LNWebClipView : LNClipView

+ (void)setupWithWebView:(WebView *)webView;

- (void)setAdditionalClip:(NSRect)additionalClip;
- (void)resetAdditionalClip;
- (BOOL)hasAdditionalClip;
- (NSRect)additionalClip;

@end
