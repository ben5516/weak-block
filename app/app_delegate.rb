class Thing
  def test
    puts "hello, world"
  end
end

class ThingReturningBlock
  def get_block
    proc { puts "hello, world" }
  end
end

class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = UIViewController.alloc.init
    rootViewController.title = 'weak-block'
    rootViewController.view.backgroundColor = UIColor.whiteColor

    navigationController = UINavigationController.alloc.initWithRootViewController(rootViewController)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = navigationController
    @window.makeKeyAndVisible


    button = UIButton.alloc.init
    button.setTitleColor(UIColor.blueColor, forState: UIControlStateNormal)
    button.setTitle("Won't Crash (WeakRef)", forState:UIControlStateNormal)
    button.addTarget(self, action: "weak_ref", forControlEvents: UIControlEventTouchUpInside)

    button.frame = CGRectMake(screen_size.width / 2 - 150, screen_size.height / 2 - 25, 300, 50)

    button2 = UIButton.alloc.init
    button2.setTitleColor(UIColor.blueColor, forState: UIControlStateNormal)
    button2.setTitle("Will Crash (block.weak!)", forState:UIControlStateNormal)
    button2.addTarget(self, action: "weak_block", forControlEvents: UIControlEventTouchUpInside)

    button2.frame = CGRectMake(screen_size.width / 2 - 150, screen_size.height / 2 + 100, 300, 50)
    rootViewController.view.addSubview(button)
    rootViewController.view.addSubview(button2)




    @thing = WeakRef.new(Thing.new) # no strong ref, will get dealloc'ed

    thing2 = ThingReturningBlock.new
    @block = thing2.get_block.weak! # strong ref to block, but it holds weakref to its owner (thing2)

    true
  end

  def weak_ref
    begin
      @thing.test
    rescue WeakRef::RefError
      puts "@thing is no longer valid"
    end
  end

  def weak_block
    begin
      @block.call
    rescue
      puts "will never get here"
    end
  end







  def screen_size
    @screen_size ||= @window.frame.size
  end
end
