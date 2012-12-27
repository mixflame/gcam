class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    $queue = Dispatch::Queue.new('com.jonsoft.globalchat')

    UIApplication.sharedApplication.setStatusBarHidden(true, animated:false)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    # switch_to_vc(load_vc("ServerList"))
    true
  end

  def load_vc(identifier)
    if Device.iphone?
      storyboard = UIStoryboard.storyboardWithName("GC2-ios", bundle: NSBundle.mainBundle)
    else
      storyboard = UIStoryboard.storyboardWithName("GC2-ios-ipad", bundle: NSBundle.mainBundle)
    end
    vc = storyboard.instantiateViewControllerWithIdentifier(identifier)
  end

  def switch_to_vc(vc)
    unless @window.rootViewController == vc
      @window.rootViewController = vc
      @window.rootViewController.wantsFullScreenLayout = true
      @window.makeKeyAndVisible
    end
  end

end
