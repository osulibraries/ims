# University Libraries Image Management System

## Installation

### Prerequisites

  * [ImageMagick](http://www.imagemagick.org/)
  * [Redis](http://redis.io/) key-value store
  * FITS

**Note:**
If you install ImageMagick using homebrew, you may need to add a switch for libtiff:

    $ brew install imagemagick --with-libtiff

Or else you may get errors like this when you run the specs:  
`Magick::ImageMagickError: no decode delegate for this image format (something.tif)`

    $ bundle install

    $ cp config/secrets.yml.sample config/secrets.yml
    #!!! Important. Open config/initializer/secret_token.rb and generate a new id
    $ cp config/devise.yml.sample config/devise.yml
    #!!! Important. Open config/devise.yml and generate a new id

    $ cp config/database.yml.sample config/database.yml
    $ cp config/solr.yml.sample config/solr.yml
    $ cp config/redis.yml.sample config/redis.yml
    $ cp config/fedora.yml.sample config/fedora.yml

    $ bundle exec rake db:schema:load
    $ bundle exec rake db:seed

### Get Hydra-Jetty

Only do this once or if you want to clear out existing data in Fedora/Solr.

    $ bundle exec rake jetty:clean
    $ bundle exec rake jetty:config

### Install fits.sh

  Go to http://code.google.com/p/fits/downloads/list and download a copy of fits to /usr/local/bin, and unpack it.

        % cd /usr/local/bin
        % wget https://fits.googlecode.com/files/fits-0.6.2.zip
        % unzip fits-0.6.2.zip

  Add execute permissions to fits.sh

        % cd fits-0.6.2
        % sudo chmod a+x fits.sh
        
### Install on Webserver

    A copy of fits is already on /mnt/common
    
    ```
    sudo cp -r /mnt/common/fits-0.6.2 /home/rails
    sudo ln -s /home/rails/fits-0.6.2/fits.sh /usr/bin/fits
    ```
    
    Java also needs installed if it is not already

### Next: Google Analytics

  If you are using google analytics,

  Copy _config/analytics.yml.template_ to _config/analytics.yml_:

        % cd config
        % cp analytics.yml.sample analytics.yml

  Edit _config/analytics.yml_ - populate the values with the google analytics
id (typically of the form _UA-12345678-9_,
and populate the OAuth values provided for the project in the
Google Developers console.  See the README at https://github.com/projecthydra/sufia for additional guidance on setting up the project with Google Analytics
(however, you do _not_ need to run the sufia:models:usagestats generator).

Additionally, once you create the client ID and google generates a client email address, go to the google analytics admin page, select the account, click on User Management, add the client email address and grant it Read & Analyze permissions.  (See https://support.google.com/analytics/answer/1009702?hl=en for more information)

### Next: Browse-everything

  Copy config/browse_everything_providers.yml.template to config/browse_everything_providers.yml
  and populate with application keys required by each provider.

        % cd config
        % cp browse_everything_providers.yml.sample browse_everything_providers.yml

  and edit browse_everything_providers.yml .  As noted at the browse-everything repo (https://github.com/projecthydra-labs/browse-everything/wiki/Configuring-browse-everything), you must register your application
with each cloud provider separately:

    * Skydrive: https://account.live.com/developers/applications/create
    * Dropbox: https://www.dropbox.com/developers/apps/create
    * Box: https://app.box.com/developers/services/edit/
    * GoogleDrive: https://code.google.com/apis/console

  Note that the application must be configured with each of the above providers with a redirect URI of:

         https://<MY SERVER URL>:<PORT>/browse/connect

  Dropbox, Box, and Skydrive now require the redirect URI to be HTTPS, not HTTP.

### Configure Contact form emailing

  In order to enable the contact form page to send email when the user clicks Send,
set the following properties in config/initializers/sufia.rb :
  * config.action_mailer.contact_email
  * config.action_mailer.from_email

Copy config/initializers/setup_mail.rb.template to config/initializers/setup_mail.rb .
Set the SMTP credentials for the user as whom the app will send email.

# Questioning Authority (Authority Control, Controlled Vocabulary)
See ReadMe for adding existing Authority Sources like Library of Congress
[ReadMe](https://github.com/projecthydra-labs/questioning_authority)


## Running locally

There are two ways to start the IMS and its dependencies for local development,
manually or using [Foreman](https://github.com/ddollar/foreman). Once started,
the application will be available at [http://localhost:3000](http://localhost:3000).

### Manual start

Each process (except Hydra-Jetty) must be started in its own terminal session.

    $ bundle exec rake jetty:start
    $ bundle exec redis-server
    $ RUN_AT_EXIT_HOOKS=true TERM_CHILD=1 QUEUE=* bundle exec rake resque:work
    $ bundle exec rails s

### Start with Foreman

Foreman can be used to start sevel dependencies in one terminal session. The
Rails server will still need to be started manually in its own terminal window.

    $ bundle exec foreman start
    $ bundle exec rails s


## Initial user account configuration

Once the application has been started, an intial administrative user account
must be created.

### Create account

Start the Rails server and navigate to [http://localhost:3000/users/sign_in](http://localhost:3000/users/sign_in).

  * Click Login
  * Click Sign up
  * Complete form

### Assign admin privileges

From Rails Console

    $ bundle exec rails c

    > role = Role.find_by_name('admin')
    > user = User.find_by_email('[your email]')
    > user.roles = [role]
    > user.update(:group_list => 'admin')


## Local Authorities

Create a .yml file in config/authorities named for the authority it represents (units.yml, states.yml) and populate with options

Query it using the file's name as the sub-authority

    /qa/search/local/units?q=Car

Results are in JSON

    [{"id":"Billy Ireland Cartoon Library \u0026 Museum","label":"Billy Ireland Cartoon Library \u0026 Museum"}]

Return entire list:

    qa/terms/local/units/


## Forms

When a form requires a drop down list you can add the authority to a helper which makes using it easier.

In helpers/application_helper.rb

      def units
        Qa::Authorities::Local.sub_authority('units').terms.map do |element|
          [element[:term], element[:id]]
        end
      end

In form

    <%= f.select :unit, options_for_select(units), {prompt: 'Please select a unit', label: 'Unit'}, {required: true, :class => 'form-control'} %>


## Model

Add to model datastream

    has_attributes :unit, datastream: :descMetadata, multiple: false

## Copyright

Unless otherwise noted, this project and all content within is
Copyright © 2016 The Ohio STate University
