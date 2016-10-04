require 'mini_magick'

# Use posix-spawn to start image magick processes to avoid deadlock
MiniMagick.configure do |config|
  config.shell_api = "posix-spawn"
  config.whiny = false
end
