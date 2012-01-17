require "active_record"
require "active_support"
require "active_support/all"

require "msf_models/version"
require "msf_models/serialized_prefs"
require "msf_models/base64_serializer"
require "msf_models/db_manager/db_objects"

require "msf_models/validators/ip_format_validator"


#
#
# ---- USAGE ----
#
# When MsfModels is included by a Rails application, it simply makes
# mixins available to ActiveRecord models that provide high-level
# behavior for those models.
#
# When MsfModels is included by MSF, the gem dynamically creates
# ActiveRecord model classes.
#
# Both of these behaviors are based on the assumption that the files in
# lib/msf_models/active_record_models (though implemented here as
# mixins) actually represent the ActiveRecord models that both MSF and
# Pro use.
#
#

# Declare the common namespace we'll use in both MSF and Pro
module Msm; end

module MsfModels
  module ActiveRecordModels; end

  def self.included(base)
    ar_mixins.each{|file| load file}
    create_and_load_ar_classes if base == Msf::DBManager
  end

  # The code in each of these represents the basic structure of a correspondingly named
  # ActiveRecord model class.  Those classes are explicitly declared in
  # Rails and are dynamically generated by create_and_load_ar_classes
  # for MSF.
  def self.ar_mixins
    models_dir = File.expand_path(File.dirname(__FILE__)) + "/msf_models/active_record_models"
    Dir.glob("#{models_dir}/*.rb")
  end

  # (MSF-only) Dynamically create ActiveRecord descendant classes
  # and load them into the namespace provided by base
  def self.create_and_load_ar_classes
    constant_names_from_files.each do |cname|
      class_str =<<-RUBY
        class Msm::#{cname} < ActiveRecord::Base
          include MsfModels::ActiveRecordModels::#{cname}
        end
      RUBY
      eval(class_str)
    end
  end

  # Derive "constant" strings from the names of the files in
  # lib/msf_models/active_record_models
  def self.constant_names_from_files
    ar_mixins.inject([]) do |array, path|
      filename = File.basename(path).split(".").first
      c_name = filename.classify
      c_name << "s" if filename =~ /^[\w]+s$/
      array << c_name
      array
    end
  end

end
