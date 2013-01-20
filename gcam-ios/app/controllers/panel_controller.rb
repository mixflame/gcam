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
      new_image = image.send(filter.to_sym)
      output_image_view.setImage new_image
    end
  end

  # picture function

  def saveImage(sender)
    imageToSave = output_image_view.image
    UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
  end

  def applyFilter(sender)
    image_view.setImage output_image_view.image
  end

  # picture takers

  def frontCamera(sender)
    BW::Device.camera.front.picture(media_types: [:image]) do |result|
      if !(result[:original_image] == nil)
        p result[:original_image]
        image_view.setImage result[:original_image].scaleToSize CGSize.new(640, 480)
      end
    end
  end

  def backCamera(sender)
    BW::Device.camera.rear.picture(media_types: [:image]) do |result|
      if !(result[:original_image] == nil)
        image_view.setImage result[:original_image].scaleToSize CGSize.new(320, 320)
      end
    end
  end

  def toLibrary(sender)
    BW::Device.camera.any.picture(media_types: [:image]) do |result|
      if !(result[:original_image] == nil)
        image_view.setImage result[:original_image].scaleToSize CGSize.new(320, 320)
      end
    end
  end

end