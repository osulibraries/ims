require 'handle'

class HandleService

  def initialize(generic_file)
    @generic_file = generic_file

    @mint_handles = true unless Rails.configuration.x.handle["mint"] == false
    @prefix       = Rails.configuration.x.handle["prefix"]
    @index        = Rails.configuration.x.handle["index"]
    @admpriv      = Rails.configuration.x.handle["admin_priv_key"]
    @url          = Rails.configuration.x.handle["url"]
  end

  def mint
    if minting_disabled?
      Rails.logger.debug "Handle was not created for file #{@generic_file.id} because minting is disabled."
    elsif handle_needed?
      create_handle!
    else
      Rails.logger.debug "Handle not created. File #{@generic_file.id} does not need a handle."
    end

    @generic_file.handle
  end


  private
    def minting_disabled?
      ! @mint_handles
    end

    def handle_needed?
      @generic_file.handle.blank? and file_is_visible? and file_has_no_active_imports?
    end

    def create_handle!
      # Create handle string
      handle = "#{@prefix}/#{SecureRandom.uuid}"

      begin
        # Set up an authenticated connection
        conn = Handle::Connection.new("0.NA/#{@prefix}", @index, @admpriv, '')

        # Create an empty record
        record = conn.create_record(handle)

        # add field
        url =  "#{@url}files/#{@generic_file.id}"
        record.add(:URL, url).index = 2
        record << Handle::Field::HSAdmin.new("0.NA/#{@prefix}")

        # Manipulate permissions
        record.last.perms.public_read = false

        record.save
        @generic_file.handle = [handle]
        @generic_file.save
        Rails.logger.info "The handle #{handle} was successfully created for file #{@generic_file.id}"

      rescue Handle::HandleError => e
        Rails.logger.error "ERROR! A new handle could not be minted for file #{@generic_file.id}. The exception was:"
        Rails.logger.error "#{e.class}: #{e.message}"
      end
    end

    def file_is_visible?
      @generic_file.visibility != Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
    end

    def file_has_no_active_imports?
      Import.with_imported_file(@generic_file).where.not(status: Import.statuses[:final]).empty?
    end

end
