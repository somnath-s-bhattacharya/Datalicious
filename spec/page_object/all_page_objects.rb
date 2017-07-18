# file: page_objects/all_page_objects.rb
#
current_path = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift File.join(current_path, 'drums_dojosto')

Dir.glob(File.join(current_path, '**', '*.rb')).each do |file|
  require file
end