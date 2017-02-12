module MatchHashHelper
  def generate_document_urls_from(id, original_name, folder_name=original_name, model='profile')
    {
      'url' => "/test/uploads/documents/#{model}/#{folder_name}/#{id}/#{original_name}.pdf",
      'preview' => { 'url' => "/test/uploads/documents/#{model}/#{folder_name}/#{id}/preview_#{original_name}.jpg"},
      'thumb' => {'url' => "/test/uploads/documents/#{model}/#{folder_name}/#{id}/thumb_#{original_name}.jpg"},
      'medium' => {'url' => "/test/uploads/documents/#{model}/#{folder_name}/#{id}/medium_#{original_name}.jpg"},
    }
  end

  def generate_photo_urls_from(id, original_name, folder_name=original_name, model='profile')
    {
      'url' => "/test/uploads/photos/#{model}/#{folder_name}/#{id}/#{original_name}.png",
      'thumb' => {'url' => "/test/uploads/photos/#{model}/#{folder_name}/#{id}/thumb_#{original_name}.jpg"},
      'medium' => {'url' => "/test/uploads/photos/#{model}/#{folder_name}/#{id}/medium_#{original_name}.jpg"},
    }
  end
end