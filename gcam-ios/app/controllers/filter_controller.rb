class FilterController < UIViewController
  extend IB

  # attr_accessor

  ib_action :Use

  outlet :image_view

  # API

  # Pine rotate

  def preferredInterfaceOrientationForPresentation
    UIDeviceOrientationPortrait
  end


  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown
  end

  def shouldAutorotate
    true
  end

  def shouldAutorotateToInterfaceOrientation(interface)
    return interface == UIDeviceOrientationPortrait || interface == UIDeviceOrientationPortraitUpsideDown
  end

  # delegate methods

  def viewWillAppear(animated)
    # @filters = (1..11).collect { |i| "e#{i}" }
    # @filters += (1..7).collect { |i| "g#{i}" }
    super(animated)
  end

  # switch back to camera
  # set main image
  def Use(sender)

  end



  def numberOfSectionsInCollectionView(collectionView)
    return  noOfItem/ noOfSection
  end

  def collectionView(collectionView, numberOfItemsInSection:section)
    return noOfSection
  end

  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
    identifier = "Cell";

    cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath:indexPath)

    recipeImageView = cell.viewWithTag(100)
    recipeImageView.image = imageArray.objectAtIndex(indexPath.section * noOfSection + indexPath.row)

    return cell;
  end


end