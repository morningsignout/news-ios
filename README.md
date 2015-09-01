# ios-app

#### To clone a local copy of the xcode project onto your computer,
`git clone https://github.com/morningsignout/ios-app.git`


#### Once you have a local copy:
**you MUST open ios-app.xcworkspace** in xcode. **NOT ios-app.xcodeproj.** This has to do with using Cocoapods as a dependency manager for the AFNetworking library.


#### Git Workflow
Let's try to work on separate branches for development and only push changes to master once they are fully functional and "production ready".

Checkout [this](http://rogerdudler.github.io/git-guide/) guide for help on git. 

##### Branch info:
If you're working on URLParser, push to branch urlparse
`git push origin urlparse`
If you're working on DataParser, push to branch dataparse
`git push origin dataparse`
