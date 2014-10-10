#Mosaic UI
**IMPORTANT: I'm developing a new UI very similar to MosaicUI based on UICollectionView. Take a look at https://github.com/betzerra/MosaicLayout**

**MosaicUI** is a tiled UI for iOS that automatic layouts according to the elements' sizes.

![Landscape](http://www.betzerra.com.ar/wp-content/uploads/2013/01/mosaic_screenshot_001.png)

![Portrait](http://www.betzerra.com.ar/wp-content/uploads/2013/01/mosaic_screenshot_002.png)

##DataSource Delegate
To work properly, **MosaicView** needs a class that implements **MosaicViewDatasourceProtocol** 
```objc
-(NSArray *)mosaicElements; // Array containing MosaicData objects
```

##MosaicViewDelegate
Ok, so now you've got the **MosaicView** working but you'll probably want something to happen when someone taps an element. In that case you'll need a class that implements **MosaicViewDelegateProtocol**

```objc
-(void)mosaicViewDidTap:(MosaicDataView *)aModule;
-(void)mosaicViewDidDoubleTap:(MosaicDataView *)aModule;
```

##Look and feel
You can customize how it looks by overriding the **MosaicDataView** class.

##Feedback is welcome
Help me to improve **MosaicUI** and tell me what do you think about it

Follow me on twitter at **@betzerra** or email me at ezequiel@betzerra.com.ar

##License
This project is under MIT License. See LICENSE file for more information.
