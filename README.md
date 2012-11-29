**LinenClipView** provides a subclass of `NSScrollView` and `WebView` 
that displays a linen pattern in the clip view like many of Apple's Lion apps. This library can of course be used to display any background image.

---

In **Interface Builder** change the *Class* of an `NSScrollView` to `LNScrollView` or similarly change the *Class* of a `WebView` to `LNWebView`.

These classes can also be created via code with `initWithFrame`.

To set the pattern image simply call `setPattern` on either subclass:

``` obj-c
[self.tableScrollView setPattern:[NSImage imageNamed:@"pattern11"]];
[self.webView setPattern:[NSImage imageNamed:@"pattern3"]];
```

The sample project that ships with this project demonstrates this.

![](https://github.com/kgn/LinenClipView/raw/master/Screenshot.png)

---

Special thanks to [@Dimillian](https://twitter.com/#!/dimillian) for figuring out how to keep the 
pattern stationary(`[NSGraphicsContext setPatternPhase:]`) and [@caffeinatedapp](https://twitter.com/#!/caffeinatedapp) for figuring out a fix to the scrollbars on Lion(the complicated `hitTest` code).

The background patterns included with this project are from [@minimalpatterns](http://www.minimal-patterns.com).

**LinenClipView** is available under the MIT license. See the LICENSE file for more info.