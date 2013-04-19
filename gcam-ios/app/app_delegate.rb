class AppDelegate

  attr_accessor :window, :main_image, :thumbnail

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    $app = self
    $queue = Dispatch::Queue.new('com.jonsoft.gcam-ios')

    UIApplication.sharedApplication.setStatusBarHidden(true, animated:false)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    switch_to_vc(load_vc("TabView"))
    true
  end

  def load_vc(identifier)
    if Device.iphone?
      storyboard = UIStoryboard.storyboardWithName("gcam", bundle: NSBundle.mainBundle)
    else
      storyboard = UIStoryboard.storyboardWithName("gcam-ipad", bundle: NSBundle.mainBundle)
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
