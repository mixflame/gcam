class PanelController < UIViewController
  extend IB

  # attr_accessor

  ib_action :frontCamera

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
    NSLog "panel view will appear"
    super(animated)
  end

  # def tableView(tableView, cellForRowAtIndexPath:indexPath)
  #   cell = tableView.dequeueReusableCellWithIdentifier("gcam")
  #   if not cell
  #     cell = UITableViewCell.alloc.initWithStyle UITableViewCellStyleDefault, reuseIdentifier:'gcam'
  #   end

  #   cell.setText @filters[indexPath.row]

  #   cell
  # end

  # def tableView(tableView, numberOfRowsInSection: section)
  #   @filters.nil? ? 0 : @filters.size
  # end

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

  def saveImage(sender)
    imageToSave = image_view.image
    if imageToSave != nil
      UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
      BubbleWrap::App.alert "Image saved."
    end
  end

  #GPUImage

  # picture takers

  def frontCamera(sender)
    BW::Device.camera.front.picture(media_types: [:image]) do |result|
      if !(result[:original_image] == nil)
        image_view.image = result[:original_image].scaleToSize CGSize.new(image_view.frame.size.width, image_view.frame.size.height)
        $app.main_image = image_view.image
      end
    end
  end

  # def backCamera(sender)
  #   BW::Device.camera.rear.picture(media_types: [:image]) do |result|
  #     if !(result[:original_image] == nil)
  #       image_view.image = result[:original_image] #.scaleToSize CGSize.new(640, 480)
  #     end
  #   end
  # end

  # def toLibrary(sender)
  #   BW::Device.camera.any.picture(media_types: [:image]) do |result|
  #     if !(result[:original_image] == nil)
  #       image_view.image = result[:original_image] #.scaleToSize CGSize.new(640, 480)
  #     end
  #   end
  # end

end