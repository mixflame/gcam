class FilterController < UIViewController
  extend IB

  # attr_accessor

  ib_action :Use

  outlet :collection_view, UICollectionView

  attr_accessor :filters

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


  def apply_gpuimage_filter(buttonIndex)
    selectedFilter = GPUImageFilter
    case (buttonIndex)
    when 0
      selectedFilter = GPUImageGrayscaleFilter.new
    when 1
      selectedFilter = GPUImageSepiaFilter.new
    when 2
      selectedFilter = GPUImageSketchFilter.new
    when 3
      selectedFilter = GPUImagePixellateFilter.new
    when 4
      selectedFilter = GPUImageColorInvertFilter.new
    when 5
      selectedFilter = GPUImageToonFilter.new
    when 6
      selectedFilter = GPUImagePinchDistortionFilter.new
    when 7
      selectedFilter = GPUImageFilter.new
    end
    filteredImage = selectedFilter.imageByFilteringImage(image_view.image)
    filteredImage
  end

  def viewWillAppear(animated)
    $fc = self
    NSLog "filters view will appear"
    @filters = (1..11).collect { |i| "e#{i}" }
    collection_view.reloadData
    # @filters += (1..7).collect { |i| "g#{i}" }
    super(animated)
  end

  # def tableView(tableView, didSelectRowAtIndexPath:indexPath)
  #   filter = @filters[indexPath.row]
  #   image = image_view.image
  #   if !(image == nil)
  #     new_image =
  #     if filter.include?("e")
  #       new_image = image.performSelector(filter.to_sym)
  #     elsif filter.include?("g")
  #       apply_gpuimage_filter(filter.scan(/\d+/)[0].to_i)
  #     end
  #     rotatedImage = UIImage.imageWithCGImage(new_image.CGImage, scale: 1.0, orientation: UIImageOrientationRight)
  #     output_image_view.image = rotatedImage
  #   end
  # end

  # switch back to camera
  # set main image
  def Use(sender)

  end



  def numberOfSectionsInCollectionView(collectionView)
    return  @filters.length / 1
  end

  def collectionView(collectionView, numberOfItemsInSection:section)
    return @filters.nil? ? 0 : @filters.size
  end

  def collectionView(collectionView, cellForItemAtIndexPath:indexPath)

    identifier = "Cell"

    cell = collection_view.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath:indexPath)
    if $app.thumbnail != nil
      recipeImageView = cell.viewWithTag(100)
      filter = @filters[indexPath.section * @filters.length + indexPath.row]
      if filter != nil
        recipeImageView.image = $app.thumbnail.performSelector(filter.to_sym)
      end
    end
    return cell

  end


end