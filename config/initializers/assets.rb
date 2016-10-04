# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '2.1'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( creative.js classie.js cbpAnimatedHeader.js jquery.easing.min.js jquery.fittext.js wow.min.js creative.css /osu_navbar/*.png /osu_navbar/*.png *.js *.png *.jpg *.jpeg *.gif )
