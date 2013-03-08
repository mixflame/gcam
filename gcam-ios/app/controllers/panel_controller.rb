class PanelController < UIViewController
  extend IB

  # attr_accessor

  ib_action :frontCamera
  ib_action :backCamera

  outlet :image_view
  outlet :output_image_view
  outlet :table_view

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
    @filters = (1..11).collect { |i| "e#{i}" }
    @filters += (1..7).collect { |i| "g#{i}" }
    super(animated)
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    cell = tableView.dequeueReusableCellWithIdentifier("gcam")
    if not cell
      cell = UITableViewCell.alloc.initWithStyle UITableViewCellStyleDefault, reuseIdentifier:'gcam'
    end

    cell.setText @filters[indexPath.row]

    cell
  end

  def tableView(tableView, numberOfRowsInSection: section)
    @filters.nil? ? 0 : @filters.size
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    filter = @filters[indexPath.row]
    image = image_view.image
    if !(image == nil)
      new_image =
      if filter.include?("e")
        new_image = image.performSelector(filter.to_sym)
      elsif filter.include?("g")
        apply_gpuimage_filter(filter.scan(/\d+/)[0].to_i)
      end
      rotatedImage = UIImage.imageWithCGImage(new_image.CGImage, scale: 1.0, orientation: UIImageOrientationRight)
      output_image_view.image = rotatedImage
    end
  end

  # picture function

  def saveImage(sender)
    imageToSave = output_image_view.image
    if imageToSave != nil
      UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
      BubbleWrap::App.alert "Saved filtered image."
    end
  end

  def applyFilter(sender)
    filtered = output_image_view.image
    if filtered != nil
      image_view.image = filtered
      BubbleWrap::App.alert "Original image changed to filtered."
    end
  end

  def saveUnfiltered(sender)
    imageToSave = image_view.image
    if imageToSave != nil
      UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
      BubbleWrap::App.alert "Original image saved."
    end
  end

  #GPUImage

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

  # picture takers

  def frontCamera(sender)
    BW::Device.camera.front.picture(media_types: [:image]) do |result|
      if !(result[:original_image] == nil)
        image_view.image = result[:original_image] #.scaleToSize CGSize.new(640, 480)
      end
    end
  end

  def backCamera(sender)
    BW::Device.camera.rear.picture(media_types: [:image]) do |result|
      if !(result[:original_image] == nil)
        image_view.image = result[:original_image] #.scaleToSize CGSize.new(640, 480)
      end
    end
  end

  def toLibrary(sender)
    BW::Device.camera.any.picture(media_types: [:image]) do |result|
      if !(result[:original_image] == nil)
        image_view.image = result[:original_image] #.scaleToSize CGSize.new(640, 480)
      end
    end
  end

end